-- Dọn dẹp môi trường trước khi chạy
DROP TABLE SIM_ORACLE_DISK CASCADE CONSTRAINTS;
DROP TABLE SIM_LOG_ARCHIVE CASCADE CONSTRAINTS;
DELETE FROM DONHANG WHERE MaDH IN ('DH60', 'DH61');
DELETE FROM SANPHAM WHERE MaSP = 'SP01';
COMMIT;

------------------------------------------------------------------------------
-- 1. Tạo lại các bảng giả lập môi trường
------------------------------------------------------------------------------
CREATE TABLE SIM_ORACLE_DISK (
    ThoiDiem VARCHAR2(100),
    MaDH VARCHAR2(20),
    NgayDat_Tren_Disk DATE,
    TrangThai_HeThong VARCHAR2(50)
);

CREATE TABLE SIM_LOG_ARCHIVE (
    Log_Sequence NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    MaGiaoTac VARCHAR2(10),
    NoiDungThayDoi NVARCHAR2(255),
    TrangThaiLog VARCHAR2(20)
);

-- Khởi tạo sản phẩm gốc (100 chiếc áo)
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai)
VALUES ('SP01', 'DM01', 'KHO01', N'Áo Khoác Bomber', N'Đen', 'XL', 500000, 100, N'Đang bán');

-- Khởi tạo 2 đơn hàng ONLINE ban đầu
INSERT INTO DONHANG (MaDH, LoaiDon, NgayDat, TrangThai, TongTien, MaDC) 
VALUES ('DH60', 'ONLINE', TO_DATE('01/05/2026 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), N'Chờ xử lý', 1000000, 'DC01');

INSERT INTO DONHANG (MaDH, LoaiDon, NgayDat, TrangThai, TongTien, MaDC) 
VALUES ('DH61', 'ONLINE', TO_DATE('01/05/2026 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), N'Chờ xử lý', 500000, 'DC01');

-- Giả lập bộ nhớ đĩa cứng ban đầu ghi nhận dữ liệu ở trạng thái GỐC
INSERT INTO SIM_ORACLE_DISK VALUES (N'1. Trạng thái ban đầu', 'DH60', TO_DATE('01/05/2026 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 'GOC');
INSERT INTO SIM_ORACLE_DISK VALUES (N'1. Trạng thái ban đầu', 'DH61', TO_DATE('01/05/2026 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 'GOC');
COMMIT;


----------------------------------------------------------------------------
-- GIAO TÁC T1: Đã COMMIT và đã CHECKPOINT an toàn xuống đĩa cứng
----------------------------------------------------------------------------
UPDATE DONHANG SET NgayDat = TO_DATE('18/05/2026 08:30:00', 'DD/MM/YYYY HH24:MI:SS') WHERE MaDH = 'DH60';
UPDATE SANPHAM SET SoLuongTon = SoLuongTon - 2 WHERE MaSP = 'SP01'; -- 100 xuống 98

INSERT INTO SIM_LOG_ARCHIVE (MaGiaoTac, NoiDungThayDoi, TrangThaiLog) 
VALUES ('T1', N'UPDATE SANPHAM (SP01) SoLuongTon: Cũ=100 -> Mới=98', 'COMMIT');

-- Checkpoint: Đẩy thành công dữ liệu của T1 xuống đĩa cứng vật lý
INSERT INTO SIM_ORACLE_DISK VALUES (N'2. Sau Checkpoint', 'DH60', TO_DATE('18/05/2026 08:30:00', 'DD/MM/YYYY HH24:MI:SS'), 'SAFE');
COMMIT;


----------------------------------------------------------------------------
-- GIAO TÁC T2: Đang thực hiện dở dang thì HỆ THỐNG BỊ SẬP (CRASH)
-- (Trạng thái trong nhật ký Log vẫn là 'ACTIVE' - Chưa bao giờ được COMMIT)
----------------------------------------------------------------------------
UPDATE DONHANG SET NgayDat = TO_DATE('19/05/2026 14:05:20', 'DD/MM/YYYY HH24:MI:SS') WHERE MaDH = 'DH61';
UPDATE SANPHAM SET SoLuongTon = SoLuongTon - 1 WHERE MaSP = 'SP01'; -- 98 xuống 97

-- Nhật ký Log ghi nhận hành động của T2 nhưng trạng thái là ACTIVE (Dở dang)
INSERT INTO SIM_LOG_ARCHIVE (MaGiaoTac, NoiDungThayDoi, TrangThaiLog) 
VALUES ('T2', N'UPDATE SANPHAM (SP01) SoLuongTon: Cũ=98 -> Mới=97', 'ACTIVE'); -- Đã sửa thành ACTIVE
COMMIT; 


----------------------------------------------------------------------------
-- KHỐI LỆNH CỨU HỘ: KHỞI ĐỘNG LẠI HỆ THỐNG VÀ THỰC HIỆN UNDO (Giữ nguyên của bạn)
----------------------------------------------------------------------------
DECLARE
    v_trangthai_t2 VARCHAR2(20);
BEGIN
    -- 1. Quét file Log tìm trạng thái cuối cùng của giao tác T2
    SELECT TrangThaiLog INTO v_trangthai_t2 
    FROM (
        SELECT TrangThaiLog 
        FROM SIM_LOG_ARCHIVE 
        WHERE MaGiaoTac = 'T2' 
        ORDER BY Log_Sequence DESC
    ) 
    WHERE ROWNUM = 1;
    
    -- 2. Vì T2 chết ở trạng thái 'ACTIVE', thực hiện hành động UNDO hoàn tác dữ liệu
    IF v_trangthai_t2 = 'ACTIVE' THEN
        
        -- UNDO bảng DONHANG: Trả lại ngày đặt gốc cho đơn online DH61
        UPDATE DONHANG 
        SET NgayDat = TO_DATE('01/05/2026 00:00:00', 'DD/MM/YYYY HH24:MI:SS') 
        WHERE MaDH = 'DH61';
        
        -- UNDO bảng SANPHAM: Cộng trả lại 1 sản phẩm mà T2 đã lấy dở dang
        UPDATE SANPHAM 
        SET SoLuongTon = SoLuongTon + 1; -- Hệ thống tự động phục hồi từ 97 + 1 = 98
        
        -- Ghi vết cứu hộ thành công xuống đĩa cứng vật lý
        INSERT INTO SIM_ORACLE_DISK VALUES (
            N'3. Sau Phục Hồi (UNDO T2)', 
            'DH61', 
            TO_DATE('01/05/2026 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 
            'CRASH_RECOVERED'
        );
        
    END IF;
    
    COMMIT;
END;
/