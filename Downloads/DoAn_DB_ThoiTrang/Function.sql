---1. Tính tổng giá trị cuối của đơn hàng ---------------------------
CREATE OR REPLACE FUNCTION fn_TongTien_Gop (
    p_MaDH IN VARCHAR2
)
RETURN NUMBER
IS
    v_TongTienSP NUMBER := 0;
    v_PhiShip NUMBER := 0;
    v_Giam NUMBER := 0;
    v_MaKM VARCHAR2(20);
    v_PhanTram NUMBER := 0;
    v_GiamToiDa NUMBER := 0;
    v_GiaTriToiThieu NUMBER := 0;
BEGIN
    -- 1. Tính tổng tiền của các sản phẩm có trong đơn hàng
    SELECT NVL(SUM(SoLuong * DonGia), 0)
    INTO v_TongTienSP
    FROM CHITIET_DONHANG
    WHERE MaDH = p_MaDH;

    -- 2. Lấy phí ship và mã giảm giá áp dụng cho đơn hàng này
    SELECT NVL(PhiShip, 0), MaKM
    INTO v_PhiShip, v_MaKM
    FROM DONHANG
    WHERE MaDH = p_MaDH;

    -- 3. Kiểm tra và tính toán số tiền giảm giá nếu đơn hàng có áp mã
    IF v_MaKM IS NOT NULL THEN
        BEGIN
            -- Lấy các thông số cấu hình của mã giảm giá từ bảng KHUYENMAI
            SELECT NVL(PhanTramGiam, 0), NVL(GiamToiDa, 0), NVL(GiaTriToiThieu, 0)
            INTO v_PhanTram, v_GiamToiDa, v_GiaTriToiThieu
            FROM KHUYENMAI
            WHERE MaKM = v_MaKM;

            -- Nếu tổng tiền sản phẩm đạt mức tối thiểu quy định mới được giảm giá
            IF v_TongTienSP >= v_GiaTriToiThieu THEN
                v_Giam := v_TongTienSP * v_PhanTram / 100;
                
                -- Khống chế mức giảm không vượt quá số tiền giảm tối đa cho phép
                IF v_Giam > v_GiamToiDa THEN
                    v_Giam := v_GiamToiDa;
                END IF;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN 
                v_Giam := 0; -- Không tìm thấy thông tin mã thì số tiền giảm bằng 0
        END;
    END IF;

    -- 4. Trả về tổng số tiền cuối cùng khách phải trả
    RETURN v_TongTienSP + v_PhiShip - v_Giam;
END fn_TongTien_Gop;
/
---2. Tính doanh thu theo giờ ---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_DoanhThuTheoGio (
    p_Ngay IN DATE,
    p_Gio IN NUMBER -- Truyền vào giá trị từ 0 đến 23
) RETURN NUMBER 
IS
    v_TongDoanhThu NUMBER(18, 2) := 0;
BEGIN
    -- Kiểm tra điều kiện giờ hợp lệ (từ 0 đến 23 giờ)
    IF p_Gio < 0 OR p_Gio > 23 THEN
        RETURN 0;
    END IF;

    -- Tính tổng tiền của các đơn hàng có ngày và giờ trùng khớp
    SELECT NVL(SUM(TongTien), 0)
    INTO v_TongDoanhThu
    FROM DONHANG
    WHERE TRUNC(NgayDat) = TRUNC(p_Ngay)
      AND TO_NUMBER(TO_CHAR(NgayDat, 'HH24')) = p_Gio
      AND TrangThai = N'Hoàn thành';
      
    RETURN v_TongDoanhThu;
END fn_DoanhThuTheoGio;
/




CREATE OR REPLACE FUNCTION FN_TAO_MASP_TU_DONG 
RETURN VARCHAR2 
IS
    v_MaxMa   VARCHAR2(10);
    v_NewNum  NUMBER;
    v_NewMa   VARCHAR2(10);
BEGIN
    -- Tìm mã sản phẩm lớn nhất hiện tại (Ví dụ: SP009)
    SELECT MAX(MaSP) INTO v_MaxMa FROM SANPHAM;
    
    IF v_MaxMa IS NULL THEN
        v_NewMa := 'SP001';
    ELSE
        -- Cắt bỏ chữ 'SP', lấy phần số (009), đổi thành số rồi cộng thêm 1 -> 10
        v_NewNum := TO_NUMBER(SUBSTR(v_MaxMa, 3)) + 1;
        -- Định dạng lại chuỗi thành SP + 3 chữ số (Ví dụ: SP010)
        v_NewMa := 'SP' || LPAD(TO_CHAR(v_NewNum), 3, '0');
    END IF;
    
    RETURN v_NewMa;
END;
/


--- Tạo mã khách hàng tự động
CREATE OR REPLACE FUNCTION fn_TaoMaKhachHang 
RETURN VARCHAR2
IS
    v_MaxMa VARCHAR2(15);
    v_SoThuTu INTEGER := 0;
    v_MaMoi VARCHAR2(15);
BEGIN
    -- Lấy phần số của mã khách hàng lớn nhất hiện tại
    SELECT MAX(SUBSTR(MaKH, 3))
    INTO v_MaxMa
    FROM KHACHHANG;
    
    -- Nếu hệ thống chưa có khách nào thì bắt đầu từ 1, ngược lại lấy số lớn nhất + 1
    IF v_MaxMa IS NOT NULL THEN
        v_SoThuTu := TO_NUMBER(v_MaxMa);
    END IF;

    v_MaMoi := 'KH' || LPAD(TO_CHAR(v_SoThuTu + 1), 6, '0');

    RETURN v_MaMoi;
END fn_TaoMaKhachHang;
/
--- Tạo mã nhà CC 
CREATE OR REPLACE FUNCTION FC_TAO_MA_NCC 
RETURN VARCHAR2
IS
    v_MaxMa   NHACUNGCAP.MaNCC%TYPE;
    v_NextNum NUMBER;
    v_NewMa   NHACUNGCAP.MaNCC%TYPE;
BEGIN
    -- Lấy mã nhà cung cấp lớn nhất hiện tại
    SELECT MAX(MaNCC) INTO v_MaxMa FROM NHACUNGCAP;
    
    -- Nếu chưa có nhà cung cấp nào, bắt đầu bằng 1
    IF v_MaxMa IS NULL THEN
        v_NextNum := 1;
    ELSE
        -- Cắt chuỗi bỏ chữ 'NCC' để lấy phần số, sau đó cộng thêm 1
        -- Ví dụ: 'NCC005' -> '005' -> số 5 -> tăng lên 6
        v_NextNum := TO_NUMBER(SUBSTR(v_MaxMa, 4)) + 1;
    END IF;
    
    -- Định dạng lại chuỗi với 3 chữ số (ví dụ: NCC006)
    -- Bạn có thể sửa 'FM000' thành 'FM0000' nếu dự kiến có hơn 1000 nhà cung cấp
    v_NewMa := 'NCC' || TO_CHAR(v_NextNum, 'FM000');
    
    RETURN v_NewMa;
END;
/

CREATE OR REPLACE FUNCTION FC_TAO_MA_NV
RETURN VARCHAR2
IS
    v_MaxSo     NUMBER := 0;
    v_MaMoi     NHANVIEN.MANV%TYPE;
BEGIN
    -- Ép kiểu phần số sang NUMBER trước rồi mới lấy MAX để tránh lỗi sắp xếp chuỗi (ví dụ '9' > '10')
    SELECT NVL(MAX(TO_NUMBER(SUBSTR(MANV, 3))), 0)
    INTO v_MaxSo
    FROM NHANVIEN;

    -- Tăng số thứ tự lên 1 và bù 3 chữ số 0 bằng LPAD (Ví dụ: 1 -> '001', 11 -> '011')
    v_MaMoi := 'NV' || LPAD(TO_CHAR(v_MaxSo + 1), 3, '0');
    
    RETURN v_MaMoi;
END FC_TAO_MA_NV;
/