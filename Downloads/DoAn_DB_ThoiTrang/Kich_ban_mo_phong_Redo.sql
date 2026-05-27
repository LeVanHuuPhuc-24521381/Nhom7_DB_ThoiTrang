DROP TABLE SIM_ORACLE_DISK CASCADE CONSTRAINTS;
DROP TABLE SIM_LOG_ARCHIVE CASCADE CONSTRAINTS;
DELETE FROM DONHANG WHERE MaDH IN ('DH60', 'DH61');
DELETE FROM SANPHAM WHERE MaSP = 'SP01';
COMMIT;

------------------------------------------------------------------------------
-- 1. Tạo lại các bảng giả lập môi trường
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

-- 2. Khởi tạo sản phẩm gốc (100 chiếc áo)
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai)
VALUES ('SP01', 'DM01', 'KHO01', N'Áo Khoác Bomber', N'Đen', 'XL', 500000, 100, N'Đang bán');

-- 3. Khởi tạo 2 đơn hàng ONLINE ban đầu
INSERT INTO DONHANG (MaDH, LoaiDon, NgayDat, TrangThai, TongTien, MaDC) 
VALUES ('DH60', 'ONLINE', TO_DATE('01/05/2026 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), N'Chờ xử lý', 1000000, 'DC01');

INSERT INTO DONHANG (MaDH, LoaiDon, NgayDat, TrangThai, TongTien, MaDC) 
VALUES ('DH61', 'ONLINE', TO_DATE('01/05/2026 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), N'Chờ xử lý', 500000, 'DC01');

INSERT INTO SIM_ORACLE_DISK VALUES (N'1. Trạng thái ban đầu', 'DH60', TO_DATE('01/05/2026 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 'GOC');
INSERT INTO SIM_ORACLE_DISK VALUES (N'1. Trạng thái ban đầu', 'DH61', TO_DATE('01/05/2026 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), 'GOC');
COMMIT;

----------------------------------------------------------------------------
-- GIAO TÁC T1 (ONLINE): Đã COMMIT và đã CHECKPOINT an toàn
----------------------------------------------------------------------------
UPDATE DONHANG SET NgayDat = TO_DATE('18/05/2026 08:30:00', 'DD/MM/YYYY HH24:MI:SS') WHERE MaDH = 'DH60';
UPDATE SANPHAM SET SoLuongTon = SoLuongTon - 2 WHERE MaSP = 'SP01'; -- 100 xuống 98

INSERT INTO SIM_LOG_ARCHIVE (MaGiaoTac, NoiDungThayDoi, TrangThaiLog) 
VALUES ('T1', N'UPDATE SANPHAM (SP01) SoLuongTon: Cũ=100 -> Mới=98', 'COMMIT');

-- Giả lập Checkpoint đẩy dữ liệu T1 xuống đĩa cứng thành công
INSERT INTO SIM_ORACLE_DISK VALUES (N'2. Sau Checkpoint', 'DH60', TO_DATE('18/05/2026 08:30:00', 'DD/MM/YYYY HH24:MI:SS'), 'SAFE');
COMMIT;

----------------------------------------------------------------------------
-- GIAO TÁC T2 (ONLINE): Đã bấm thanh toán (COMMIT) nhưng ĐĨA CỨNG CHƯA KỊP GHI
----------------------------------------------------------------------------
UPDATE DONHANG SET NgayDat = TO_DATE('19/05/2026 14:05:20', 'DD/MM/YYYY HH24:MI:SS') WHERE MaDH = 'DH61';
UPDATE SANPHAM SET SoLuongTon = SoLuongTon - 1 WHERE MaSP = 'SP01'; -- 98 xuống 97

-- KHÁCH HÀNG BẤM THANH TOÁN THÀNH CÔNG: Log ghi nhận trạng thái 'COMMIT'
INSERT INTO SIM_LOG_ARCHIVE (MaGiaoTac, NoiDungThayDoi, TrangThaiLog) 
VALUES ('T2', N'UPDATE SANPHAM (SP01) SoLuongTon: Cũ=98 -> Mới=97', 'COMMIT');
COMMIT;

-- [HỆ THỐNG BỊ CRASH TẠI ĐÂY] --
-- Vì mất điện đột ngột ngay khi vừa COMMIT, bảng giả lập đĩa cứng (SIM_ORACLE_DISK) chưa kịp có dòng ghi nhận của T2.

----------------------------------------------------------------------------
-- TIẾN TRÌNH KHÔI PHỤC TỰ ĐỘNG (CRASH RECOVERY) -
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
    
    -- 2. Nếu T2 đã kịp ghi 'COMMIT' vào log, hệ thống bắt buộc phải REDO (Làm lại/Ghi ép xuống đĩa)
    IF v_trangthai_t2 = 'COMMIT' THEN
        
        -- REDO bảng DONHANG: Đảm bảo ngày đặt mới của DH61 được ghi nhận chính xác trên đĩa
        UPDATE DONHANG 
        SET NgayDat = TO_DATE('19/05/2026 14:05:20', 'DD/MM/YYYY HH24:MI:SS') 
        WHERE MaDH = 'DH61';
        
        -- REDO bảng SANPHAM: Ép số lượng tồn kho xuống 97 (Chấp nhận giao dịch thành công)
        UPDATE SANPHAM 
        SET SoLuongTon = 97 
        WHERE MaSP = 'SP01';
        
        -- Ghi vết cứu hộ REDO thành công xuống đĩa cứng vật lý
        INSERT INTO SIM_ORACLE_DISK VALUES (
            N'3. Sau Phục Hồi (REDO T2)', 
            'DH61', 
            TO_DATE('19/05/2026 14:05:20', 'DD/MM/YYYY HH24:MI:SS'), 
            'CRASH_REDO_SUCCESS'
        );
        
    END IF;
    
    COMMIT;
END;
/
----------------------------------------------------------------------
-- 1. Kiểm tra ngày đặt của 2 hóa đơn Online
SELECT MaDH, LoaiDon, NgayDat, TongTien, MaDC FROM DONHANG WHERE MaDH IN ('DH60', 'DH61');

-- 2. Kiểm tra số lượng tồn kho của sản phẩm SP01
SELECT MaSP, TenSP, So  LuongTon FROM SANPHAM WHERE MaSP = 'SP01';

-- 3. Xem lịch sử lưu đĩa vật lý
SELECT * FROM SIM_ORACLE_DISK ORDER BY ThoiDiem;