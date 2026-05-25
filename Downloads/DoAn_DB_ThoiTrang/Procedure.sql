create or replace NONEDITIONABLE PROCEDURE SP_AP_DUNG_KHUYEN_MAI (
    p_MaKM              IN  VARCHAR2,     
    p_TongTienDonHang   IN  NUMBER,       
    p_TienGiam          OUT NUMBER,       
    p_ThongBao          OUT NVARCHAR2     
)
IS
    v_TrangThai         NVARCHAR2(50);
    v_NgayBatDau        DATE;
    v_NgayKetThuc       DATE;
    v_GiaTriToiThieu    NUMBER; 
    v_PhanTramGiam      NUMBER; 
    v_GiamToiDa         NUMBER;
    v_SoLuotDung        NUMBER; 
BEGIN
    -- 1. TÌM KHUYẾN MÃI TRONG CSDL
    BEGIN
        SELECT TrangThai, NgayBatDau, NgayKetThuc, GiaTriToiThieu, PhanTramGiam, GiamToiDa, SoLuotDung
        INTO v_TrangThai, v_NgayBatDau, v_NgayKetThuc, v_GiaTriToiThieu, v_PhanTramGiam, v_GiamToiDa, v_SoLuotDung
        FROM KHUYENMAI
        WHERE MaKM = p_MaKM;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_TienGiam := 0;
            p_ThongBao := 'LỖI: Mã khuyến mãi không tồn tại!';
            RETURN;
    END;

    -- 2. KIỂM TRA TRẠNG THÁI VÀ THỜI GIAN VÀ LƯỢT DÙNG
    IF v_TrangThai != 'Đang áp dụng' THEN
        p_TienGiam := 0;
        p_ThongBao := 'LỖI: Mã khuyến mãi này đã ngưng áp dụng!';
        RETURN;
    END IF;

    IF SYSDATE < v_NgayBatDau OR SYSDATE > v_NgayKetThuc THEN
        p_TienGiam := 0;
        p_ThongBao := 'LỖI: Mã khuyến mãi chưa tới hạn hoặc đã hết hạn!';
        RETURN;
    END IF;

    -- Kiểm tra số lượt dùng còn lại
    IF v_SoLuotDung <= 0 THEN
        p_TienGiam := 0;
        p_ThongBao := 'LỖI: Mã khuyến mãi đã hết lượt sử dụng!';
        RETURN;
    END IF;

    -- 3. KIỂM TRA MỨC ÁP DỤNG (GIÁ TRỊ ĐƠN HÀNG TỐI THIỂU)
    IF p_TongTienDonHang < v_GiaTriToiThieu THEN
        p_TienGiam := 0;
        p_ThongBao := 'LỖI: Đơn hàng chưa đạt mức tối thiểu (' || TO_CHAR(v_GiaTriToiThieu) || ') để dùng mã này!';
        RETURN;
    END IF;

    -- 4. TÍNH TOÁN MỨC GIẢM THEO PHẦN TRĂM
    p_TienGiam := (p_TongTienDonHang * v_PhanTramGiam) / 100;

    -- Đảm bảo tiền giảm không vượt quá GiamToiDa
    IF p_TienGiam > v_GiamToiDa THEN
        p_TienGiam := v_GiamToiDa;
    END IF;

    -- Đảm bảo tiền giảm không vượt quá tổng tiền của đơn hàng
    IF p_TienGiam > p_TongTienDonHang THEN
        p_TienGiam := p_TongTienDonHang;
    END IF;

    -- TRẢ VỀ THÀNH CÔNG (ĐÃ XÓA LỆNH UPDATE VÀ COMMIT Ở ĐÂY)
    p_ThongBao := 'SUCCESS';

EXCEPTION
    WHEN OTHERS THEN
        p_TienGiam := 0;
        p_ThongBao := 'LỖI HỆ THỐNG: ' || SQLERRM;
END SP_AP_DUNG_KHUYEN_MAI;

/
create or replace NONEDITIONABLE PROCEDURE SP_DANGKY_TAIKHOAN (
    p_TenDangNhap IN TAIKHOAN.TENDANGNHAP%TYPE,
    p_MatKhau     IN TAIKHOAN.MATKHAU%TYPE,
    p_Quyen       IN TAIKHOAN.QUYEN%TYPE,
    p_Email       IN TAIKHOAN.EMAIL%TYPE
)
IS
    v_CountTen   NUMBER;
    v_CountEmail NUMBER;
BEGIN
    -- 1. Kiểm tra trùng Tên đăng nhập
    SELECT COUNT(*) INTO v_CountTen FROM TAIKHOAN WHERE TENDANGNHAP = p_TenDangNhap;
    IF v_CountTen > 0 THEN
        RAISE_APPLICATION_ERROR(-20050, 'Tên đăng nhập "' || p_TenDangNhap || '" đã tồn tại trong hệ thống!');
    END IF;

    -- 2. Kiểm tra trùng Email
    IF p_Email IS NOT NULL THEN
        SELECT COUNT(*) INTO v_CountEmail FROM TAIKHOAN WHERE EMAIL = p_Email;
        IF v_CountEmail > 0 THEN
            RAISE_APPLICATION_ERROR(-20051, 'Email "' || p_Email || '" đã được đăng ký bởi tài khoản khác!');
        END IF;
    END IF;

    -- 3. Thực hiện chèn dữ liệu (Mặc định TRANGTHAI = 1 nghĩa là tài khoản kích hoạt ngay)
    INSERT INTO TAIKHOAN (TENDANGNHAP, MATKHAU, QUYEN, TRANGTHAI, EMAIL) 
    VALUES (p_TenDangNhap, p_MatKhau, NVL(p_Quyen, 'User'), 1, p_Email);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE; -- Đẩy toàn bộ thông tin lỗi (gồm cả mã -20050, -20051) ngược về Java
END;
/
create or replace NONEDITIONABLE PROCEDURE SP_SUA_NHANVIEN (
    p_MaNV        IN NHANVIEN.MANV%TYPE,
    p_TenNV       IN NHANVIEN.TENNV%TYPE,
    p_NgaySinh    IN NHANVIEN.NGAYSINH%TYPE,
    p_GioiTinh    IN NHANVIEN.GIOITINH%TYPE,
    p_SDT         IN NHANVIEN.SDT%TYPE,
    p_DiaChi      IN NHANVIEN.DIACHI%TYPE,
    p_ChucVu      IN NHANVIEN.CHUCVU%TYPE,
    p_NgayVaoLam  IN NHANVIEN.NGAYVAOLAM%TYPE,
    p_TrangThai   IN NHANVIEN.TRANGTHAI%TYPE,
    p_TenDangNhap IN NHANVIEN.TENDANGNHAP%TYPE
)
IS
BEGIN
    -- Thực hiện cập nhật dữ liệu dựa vào Mã Nhân Viên
    UPDATE NHANVIEN
    SET 
        TENNV = p_TenNV,
        NGAYSINH = p_NgaySinh,
        GIOITINH = p_GioiTinh,
        SDT = p_SDT,
        DIACHI = p_DiaChi,
        CHUCVU = p_ChucVu,
        NGAYVAOLAM = p_NgayVaoLam,
        TRANGTHAI = p_TrangThai,
        TENDANGNHAP = p_TenDangNhap
    WHERE MANV = p_MaNV;

    -- Lưu thay đổi vào ổ cứng nếu UPDATE thành công
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        -- Hoàn tác nếu có bất kỳ lỗi nào (sai kiểu dữ liệu, vi phạm Trigger, v.v.)
        ROLLBACK;
        -- Ném lỗi thẳng lên cho Java hứng (Để hàm cleanErrorMessage của bạn bắt được lỗi)
        RAISE; 
END SP_SUA_NHANVIEN;
/
create or replace NONEDITIONABLE PROCEDURE SP_SUA_SANPHAM (
    p_MaSP IN SANPHAM.MaSP%TYPE,
    p_MaDM IN SANPHAM.MaDM%TYPE,
    p_MaKho IN SANPHAM.MaKho%TYPE,
    p_TenSP IN SANPHAM.TenSP%TYPE,
    p_MauSac IN SANPHAM.MauSac%TYPE,
    p_KichCo IN SANPHAM.KichCo%TYPE,
    p_GiaBan IN SANPHAM.GiaBan%TYPE,
    p_SoLuongTon IN SANPHAM.SoLuongTon%TYPE,
    p_TrangThai IN SANPHAM.TrangThai%TYPE,
    p_HinhAnh IN SANPHAM.HINHANH%TYPE
)
IS
BEGIN
    UPDATE SANPHAM 
    SET MaDM = p_MaDM,
        MaKho = p_MaKho,
        TenSP = p_TenSP,
        MauSac = p_MauSac,
        KichCo = p_KichCo,
        GiaBan = p_GiaBan,
        SoLuongTon = NVL(p_SoLuongTon, 0),
        TrangThai = p_TrangThai,
        HINHANH = p_HinhAnh
    WHERE MaSP = p_MaSP;

    -- Kiểm tra xem có dòng nào được cập nhật không (tránh trường hợp truyền sai mã sản phẩm)
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Không tìm thấy sản phẩm có mã: ' || p_MaSP);
    ELSE
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Cập nhật sản phẩm thành công!');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -2291 THEN
            DBMS_OUTPUT.PUT_LINE('Lỗi: Mã danh mục hoặc Mã kho không tồn tại.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Lỗi hệ thống khi sửa: ' || SQLERRM);
        END IF;
        ROLLBACK;
END;
/
create or replace NONEDITIONABLE PROCEDURE SP_THEM_CT_PHIEUNHAP (
    p_MaPN        IN CHITIET_PHIEUNHAP.MaPN%TYPE,
    p_MaSP        IN CHITIET_PHIEUNHAP.MaSP%TYPE,
    p_SoLuong     IN CHITIET_PHIEUNHAP.SoLuong%TYPE,
    p_DonGiaNhap  IN CHITIET_PHIEUNHAP.DonGiaNhap%TYPE
)
IS
BEGIN
    -- 1. Thêm vào bảng chi tiết phiếu nhập
    INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap)
    VALUES (p_MaPN, p_MaSP, p_SoLuong, p_DonGiaNhap);

    -- 2. Cập nhật tăng số lượng tồn kho của sản phẩm
    UPDATE SANPHAM 
    SET SoLuongTon = NVL(SoLuongTon, 0) + p_SoLuong 
    WHERE MaSP = p_MaSP;

    -- 3. Tự động cộng dồn giá trị món hàng này vào tổng tiền của phiếu nhập cha
    UPDATE PHIEUNHAP 
    SET TongTien = NVL(TongTien, 0) + (p_SoLuong * p_DonGiaNhap)
    WHERE MaPN = p_MaPN;

    -- Lưu ý: Vẫn giữ nguyên quy tắc KHÔNG COMMIT ở đây để Java quản lý Transaction.
END;
/
create or replace NONEDITIONABLE PROCEDURE SP_THEM_KHACHHANG (
    -- Bỏ hoàn toàn tham số p_MaKH vì Database sẽ tự sinh
    p_TenKH IN KHACHHANG.TenKH%TYPE,
    p_SDT IN KHACHHANG.SDT%TYPE,
    p_DiemTichLuy IN KHACHHANG.DiemTichLuy%TYPE,
    p_Email IN KHACHHANG.Email%TYPE,
    p_TenDangNhap IN KHACHHANG.TenDangNhap%TYPE
)
IS
    v_MaKH KHACHHANG.MaKH%TYPE;
BEGIN
    -- Gọi Function tự động sinh mã mới (Ví dụ: KH000001) ngay tại đây
    v_MaKH := fn_TaoMaKhachHang();

    -- Thực hiện chèn dữ liệu với mã vừa sinh ra
    INSERT INTO KHACHHANG (MaKH, TenKH, SDT, DiemTichLuy, Email, TenDangNhap)
    VALUES (v_MaKH, p_TenKH, p_SDT, NVL(p_DiemTichLuy, 0), p_Email, p_TenDangNhap);

    COMMIT;

EXCEPTION
    -- Bẫy lỗi trùng khóa chính (Mã KH) hoặc trùng các ràng buộc duy nhất (Số điện thoại)
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        raise_application_error(-20011, 'Lỗi: Số điện thoại hoặc Mã khách hàng này đã tồn tại trên hệ thống!');

    WHEN OTHERS THEN
        ROLLBACK;
        -- Bẫy lỗi vi phạm khóa ngoại liên kết với bảng tài khoản người dùng
        IF SQLCODE = -2291 THEN
            raise_application_error(-20012, 'Lỗi ràng buộc: Tên đăng nhập không tồn tại trong hệ thống (Tài khoản không hợp lệ).');
        ELSE
            raise_application_error(-20013, 'Lỗi hệ thống Oracle khi thêm: ' || SQLERRM);
        END IF;
END;
/
create or replace NONEDITIONABLE PROCEDURE SP_THEM_KHUYENMAI (
    p_MaKM            IN KHUYENMAI.MaKM%TYPE, -- Thêm tham số nhận mã từ Java gửi sang
    p_TenKM           IN KHUYENMAI.TenKM%TYPE,
    p_PhanTramGiam    IN KHUYENMAI.PhanTramGiam%TYPE,
    p_GiaTriToiThieu  IN KHUYENMAI.GiaTriToiThieu%TYPE,
    p_GiamToiDa       IN KHUYENMAI.GiamToiDa%TYPE,
    p_NgayBatDau      IN KHUYENMAI.NgayBatDau%TYPE,
    p_NgayKetThuc     IN KHUYENMAI.NgayKetThuc%TYPE,
    p_SoLuotDung      IN KHUYENMAI.SoLuotDung%TYPE,
    p_TrangThai       IN KHUYENMAI.TrangThai%TYPE
)
IS
BEGIN
    -- 1. KIỂM TRA RÀNG BUỘC LOGIC (VALIDATION)
    IF p_NgayKetThuc < p_NgayBatDau THEN
        RAISE_APPLICATION_ERROR(-20001, 'Lỗi dữ liệu: Ngày kết thúc không được nhỏ hơn ngày bắt đầu!');
    END IF;

    IF p_PhanTramGiam < 0 OR p_PhanTramGiam > 100 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Lỗi dữ liệu: Phần trăm giảm giá phải nằm trong khoảng từ 0 đến 100!');
    END IF;

    -- 2. THỰC HIỆN CHÈN VÀO BẢNG 
    -- Sử dụng trực tiếp tham số p_MaKM do người dùng nhập từ ứng dụng truyền qua
    INSERT INTO KHUYENMAI (MaKM, TenKM, PhanTramGiam, GiaTriToiThieu, GiamToiDa, NgayBatDau, NgayKetThuc, SoLuotDung, TrangThai)
    VALUES (p_MaKM, p_TenKM, p_PhanTramGiam, p_GiaTriToiThieu, p_GiamToiDa, p_NgayBatDau, p_NgayKetThuc, p_SoLuotDung, p_TrangThai);

    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Lỗi: Mã khuyến mãi ' || p_MaKM || ' đã tồn tại trên hệ thống!');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Lỗi hệ thống khi thêm khuyến mãi: ' || SQLERRM);
END;
/
create or replace NONEDITIONABLE PROCEDURE SP_THEM_NHACUNGCAP (
    p_TenNCC IN NHACUNGCAP.TenNCC%TYPE,
    p_DiaChi IN NHACUNGCAP.DiaChi%TYPE,
    p_SDT    IN NHACUNGCAP.SDT%TYPE,
    p_Email  IN NHACUNGCAP.Email%TYPE
)
IS
    v_MaNCC NHACUNGCAP.MaNCC%TYPE;
BEGIN
    -- Gọi function lấy mã tự động
    v_MaNCC := FC_TAO_MA_NCC();

    -- Thực hiện chèn dữ liệu
    INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, SDT, Email)
    VALUES (v_MaNCC, p_TenNCC, p_DiaChi, p_SDT, p_Email);

    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        -- Mã lỗi tự định nghĩa trong Oracle phải nằm trong khoảng từ -20000 đến -20999
        RAISE_APPLICATION_ERROR(-20001, 'Lỗi trùng mã: Mã ' || v_MaNCC || ' đã tồn tại trong hệ thống!');

    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Lỗi hệ thống database: ' || SQLERRM);
END;
/
create or replace NONEDITIONABLE PROCEDURE SP_THEM_NHACUNGCAP (
    p_TenNCC IN NHACUNGCAP.TenNCC%TYPE,
    p_DiaChi IN NHACUNGCAP.DiaChi%TYPE,
    p_SDT    IN NHACUNGCAP.SDT%TYPE,
    p_Email  IN NHACUNGCAP.Email%TYPE
)
IS
    v_MaNCC NHACUNGCAP.MaNCC%TYPE;
BEGIN
    -- Gọi function lấy mã tự động
    v_MaNCC := FC_TAO_MA_NCC();

    -- Thực hiện chèn dữ liệu
    INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, SDT, Email)
    VALUES (v_MaNCC, p_TenNCC, p_DiaChi, p_SDT, p_Email);

    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        -- Mã lỗi tự định nghĩa trong Oracle phải nằm trong khoảng từ -20000 đến -20999
        RAISE_APPLICATION_ERROR(-20001, 'Lỗi trùng mã: Mã ' || v_MaNCC || ' đã tồn tại trong hệ thống!');

    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Lỗi hệ thống database: ' || SQLERRM);
END;
/
create or replace NONEDITIONABLE PROCEDURE SP_THEM_PHIEUNHAP (
    p_MaNV      IN PHIEUNHAP.MaNV%TYPE,
    p_MaNCC     IN PHIEUNHAP.MaNCC%TYPE,
    p_TongTien  IN PHIEUNHAP.TongTien%TYPE,
    p_GhiChu    IN PHIEUNHAP.GhiChu%TYPE,
    p_MaPN_Out  OUT PHIEUNHAP.MaPN%TYPE 
)
IS
    v_MaxMaPN VARCHAR2(20);
    v_NextNum NUMBER;
BEGIN
    -- 1. Tìm mã lớn nhất hiện tại (ví dụ: 'PN05')
    SELECT MAX(MaPN) INTO v_MaxMaPN FROM PHIEUNHAP;

    -- 2. Nếu bảng chưa có dữ liệu (v_MaxMaPN bị NULL), bắt đầu từ số 1
    IF v_MaxMaPN IS NULL THEN
        v_NextNum := 1;
    ELSE
        -- Cắt bỏ 2 ký tự đầu 'PN', chuyển phần còn lại ('05') thành số (5) rồi cộng 1
        v_NextNum := TO_NUMBER(SUBSTR(v_MaxMaPN, 3)) + 1;
    END IF;

    -- 3. Định dạng lại mã mới (Ví dụ: PN06)
    p_MaPN_Out := 'PN' || LPAD(v_NextNum, 2, '0');

    -- 4. Chèn dữ liệu vào bảng
    INSERT INTO PHIEUNHAP (MaPN, MaNV, MaNCC, TongTien, NgayNhap, GhiChu)
    VALUES (p_MaPN_Out, p_MaNV, p_MaNCC, p_TongTien, SYSDATE, p_GhiChu);

END;
/
create or replace NONEDITIONABLE PROCEDURE SP_THEM_SANPHAM (
    -- Bỏ tham số p_MaSP đi vì Database sẽ tự sinh
    p_MaDM IN SANPHAM.MaDM%TYPE,
    p_MaKho IN SANPHAM.MaKho%TYPE,
    p_TenSP IN SANPHAM.TenSP%TYPE,
    p_MauSac IN SANPHAM.MauSac%TYPE,
    p_KichCo IN SANPHAM.KichCo%TYPE,
    p_GiaBan IN SANPHAM.GiaBan%TYPE,
    p_SoLuongTon IN SANPHAM.SoLuongTon%TYPE,
    p_TrangThai IN SANPHAM.TrangThai%TYPE,
    p_HinhAnh IN SANPHAM.HINHANH%TYPE
)
IS
    v_MaSP_TuDong SANPHAM.MaSP%TYPE;
BEGIN
    -- Gọi Function tạo mã tự động tại đây
    v_MaSP_TuDong := FN_TAO_MASP_TU_DONG();

    -- Chèn v_MaSP_TuDong vào câu lệnh INSERT
    INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH)
    VALUES (v_MaSP_TuDong, p_MaDM, p_MaKho, p_TenSP, p_MauSac, p_KichCo, p_GiaBan, NVL(p_SoLuongTon, 0), p_TrangThai, p_HinhAnh);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Thêm sản phẩm thành công với mã: ' || v_MaSP_TuDong);
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Lỗi: Mã sản phẩm ' || v_MaSP_TuDong || ' đã tồn tại!');
        ROLLBACK;
    WHEN OTHERS THEN
        IF SQLCODE = -2291 THEN
            DBMS_OUTPUT.PUT_LINE('Lỗi: Mã danh mục hoặc Mã kho không tồn tại (Vi phạm khóa ngoại).');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Lỗi hệ thống: ' || SQLERRM);
        END IF;
        ROLLBACK;
END;
/
create or replace NONEDITIONABLE PROCEDURE sp_ThemKhachHang (
    p_TenKH IN KHACHHANG.TenKH%TYPE,
    p_SDT IN KHACHHANG.SDT%TYPE,
    p_Email IN KHACHHANG.Email%TYPE
)
AS
    v_MaKH VARCHAR2(20);
    v_max_id VARCHAR2(20);
    v_num NUMBER;
BEGIN
    SELECT MAX(MaKH) INTO v_max_id FROM KHACHHANG;
    IF v_max_id IS NULL THEN
        v_MaKH := 'KH001';
    ELSE
        v_num := TO_NUMBER(SUBSTR(v_max_id, 3)) + 1;
        v_MaKH := 'KH' || LPAD(v_num, 3, '0');
    END IF;

    INSERT INTO KHACHHANG (MaKH, TenKH, SDT, DiemTichLuy, Email)
    VALUES (v_MaKH, p_TenKH, p_SDT, 0, p_Email);
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20010, 'Lỗi: Số điện thoại này đã được đăng ký.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20011, 'Lỗi hệ thống khi thêm khách hàng.');
END;
/
create or replace NONEDITIONABLE PROCEDURE SP_XOA_KHACHHANG (
    p_MaKH IN KHACHHANG.MaKH%TYPE
)
IS
BEGIN
    DELETE FROM KHACHHANG
    WHERE MaKH = p_MaKH;

    -- Nếu không tìm thấy mã khách hàng nào để xóa
    IF SQL%ROWCOUNT = 0 THEN
        raise_application_error(-20021, 'Lỗi: Không tìm thấy Khách hàng có mã ' || p_MaKH || ' để xóa!');
    ELSE
        COMMIT;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK; -- Đảm bảo trả lại trạng thái an toàn trước khi ném lỗi

        -- Nếu vướng ràng buộc khóa ngoại (Khách đã mua hàng, có đơn hàng...)
        IF SQLCODE = -2292 THEN
            raise_application_error(-20022, 'Lỗi ràng buộc: Không thể xóa khách hàng này vì họ đã phát sinh lịch sử dữ liệu (Đơn hàng, Địa chỉ, Đánh giá...).');
        ELSE
            -- Các lỗi hệ thống phát sinh khác
            raise_application_error(-20023, 'Lỗi hệ thống Oracle khi xóa: ' || SQLERRM);
        END IF;
END;
/
create or replace NONEDITIONABLE PROCEDURE SP_XOA_KHUYENMAI (
	p_MaKM IN KHUYENMAI.MaKM%TYPE
)
IS
BEGIN
	DELETE FROM KHUYENMAI
	WHERE MaKM = p_MaKM;

	IF SQL%ROWCOUNT = 0 THEN
    	DBMS_OUTPUT.PUT_LINE('Lỗi: Không tìm thấy Mã khuyến mãi ' || p_MaKM || ' để xóa!');
	ELSE
    	COMMIT;
    	DBMS_OUTPUT.PUT_LINE('Xóa chương trình khuyến mãi thành công!');
	END IF;
EXCEPTION
	WHEN OTHERS THEN
    	IF SQLCODE = -2292 THEN
        	DBMS_OUTPUT.PUT_LINE('Lỗi: Không thể xóa vì mã khuyến mãi này đã được áp dụng cho các đơn hàng trong hệ thống.');
    	ELSE
        	DBMS_OUTPUT.PUT_LINE('Lỗi hệ thống: ' || SQLERRM);
    	END IF;
    	ROLLBACK;
END;
/
create or replace NONEDITIONABLE PROCEDURE SP_XOA_NHACUNGCAP (
    p_MaNCC IN NHACUNGCAP.MaNCC%TYPE
)
IS
BEGIN
    DELETE FROM NHACUNGCAP WHERE MaNCC = p_MaNCC;

    -- Kiểm tra nếu không có dòng nào bị xóa (mã không tồn tại)
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Không tìm thấy nhà cung cấp với mã: ' || p_MaNCC);
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        -- Kiểm tra lỗi vi phạm khóa ngoại (Foreign Key Violation)
        IF SQLCODE = -2292 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Lỗi: Không thể xóa vì nhà cung cấp này đang có ràng buộc dữ liệu (đã từng cung cấp hàng).');
        ELSE
            -- Các lỗi khác
            RAISE_APPLICATION_ERROR(-20004, 'Lỗi hệ thống: ' || SQLERRM);
        END IF;
END;
/
create or replace NONEDITIONABLE PROCEDURE SP_XOA_NHANVIEN (
    p_MaNV IN NHANVIEN.MaNV%TYPE
)
IS
BEGIN
    DELETE FROM NHANVIEN WHERE MaNV = p_MaNV;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Không tìm thấy nhân viên: ' || p_MaNV);
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        IF SQLCODE = -2292 THEN
            RAISE_APPLICATION_ERROR(-20006, 'Không thể xóa vì nhân viên này có dữ liệu liên quan!');
        ELSE
            RAISE_APPLICATION_ERROR(-20007, 'Lỗi hệ thống: ' || SQLERRM);
        END IF;
END SP_XOA_NHANVIEN;
/
create or replace NONEDITIONABLE PROCEDURE SP_XOA_SANPHAM (
    p_MaSP IN SANPHAM.MaSP%TYPE
)
IS
BEGIN
    DELETE FROM SANPHAM WHERE MaSP = p_MaSP;

    -- Nếu không tìm thấy dòng nào để xóa
    IF SQL%ROWCOUNT = 0 THEN
        raise_application_error(-20001, 'Lỗi: Không tìm thấy Sản phẩm ' || p_MaSP || ' để xóa!');
    ELSE
        COMMIT;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK; -- Rollback trước khi ném lỗi lên Java

        -- Nếu dính lỗi khóa ngoại (đang nằm trong đơn hàng, giỏ hàng...)
        IF SQLCODE = -2292 THEN
            raise_application_error(-20002, 'Lỗi ràng buộc: Không thể xóa vì sản phẩm này đang nằm trong Chi tiết Đơn hàng, Phiếu nhập hoặc Giỏ hàng.');
        ELSE
            -- Các lỗi hệ thống không lường trước được
            raise_application_error(-20003, 'Lỗi hệ thống Oracle: ' || SQLERRM);
        END IF;
END;