
---1. Thêm sản phẩm
CREATE OR REPLACE PROCEDURE SP_THEM_SANPHAM (
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
--2. CREATE OR REPLACE PROCEDURE SP_XOA_SANPHAM (
	CREATE OR REPLACE PROCEDURE SP_XOA_SANPHAM (
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
/
---3. Sửa sản phẩm ----------------------------
CREATE OR REPLACE PROCEDURE SP_SUA_SANPHAM (
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
----------------------------------------------------------------------

---4.Thêm khách hàng
CREATE OR REPLACE PROCEDURE SP_THEM_KHACHHANG (
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
---4.Xóa khách hàng--------------------------------------------------------
CREATE OR REPLACE PROCEDURE SP_XOA_KHACHHANG (
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
---5.Thêm khuyến mãi 
CREATE OR REPLACE PROCEDURE SP_THEM_KHUYENMAI (
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
    v_MaKM KHUYENMAI.MaKM%TYPE;
BEGIN
    -- Tự động lấy mã khuyến mãi mới
    v_MaKM := FC_TAO_MA_KM();

    -- Thực hiện chèn vào bảng
    INSERT INTO KHUYENMAI (MaKM, TenKM, PhanTramGiam, GiaTriToiThieu, GiamToiDa, NgayBatDau, NgayKetThuc, SoLuotDung, TrangThai)
    VALUES (v_MaKM, p_TenKM, p_PhanTramGiam, p_GiaTriToiThieu, p_GiamToiDa, p_NgayBatDau, p_NgayKetThuc, p_SoLuotDung, p_TrangThai);
    
    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, 'Lỗi: Mã khuyến mãi ' || v_MaKM || ' đã tồn tại trên hệ thống!');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Lỗi hệ thống khi thêm khuyến mãi: ' || SQLERRM);
END;
/
---6. Xóa khuyến mãi 
CREATE OR REPLACE PROCEDURE SP_XOA_KHUYENMAI (
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
---7. Thêm nhà cung cấp.
CREATE OR REPLACE PROCEDURE SP_THEM_NHACUNGCAP (
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
--- Xóa nhà cung cấp
CREATE OR REPLACE PROCEDURE SP_XOA_NHACUNGCAP (
    p_MaNCC IN NHACUNGCAP.MaNCC%TYPE
)
IS
BEGIN
    DELETE FROM NHACUNGCAP WHERE MaNCC = p_MaNCC;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Không tìm thấy nhà cung cấp với mã: ' || p_MaNCC);
    END IF;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Lỗi khi xóa: ' || SQLERRM);
END;
/
-----
CREATE OR REPLACE PROCEDURE SP_THEM_NHANVIEN (
    p_TenNV      IN NHANVIEN.TenNV%TYPE,
    p_NgaySinh   IN NHANVIEN.NgaySinh%TYPE,
    p_GioiTinh   IN NHANVIEN.GioiTinh%TYPE,
    p_SDT        IN NHANVIEN.SDT%TYPE,
    p_DiaChi     IN NHANVIEN.DiaChi%TYPE,
    p_ChucVu     IN NHANVIEN.ChucVu%TYPE,
    p_NgayVaoLam IN NHANVIEN.NgayVaoLam%TYPE,
    p_TrangThai  IN NHANVIEN.TrangThai%TYPE,
    p_TenDangNhap IN NHANVIEN.TenDangNhap%TYPE
)
IS
    v_MaNV NHANVIEN.MaNV%TYPE;
BEGIN
    v_MaNV := FC_TAO_MA_NV();

    INSERT INTO NHANVIEN (MaNV, TenNV, NgaySinh, GioiTinh, SDT, DiaChi, ChucVu, NgayVaoLam, TrangThai, TenDangNhap)
    VALUES (v_MaNV, p_TenNV, p_NgaySinh, p_GioiTinh, p_SDT, p_DiaChi, p_ChucVu, p_NgayVaoLam, p_TrangThai, p_TenDangNhap);

    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'Lỗi: Mã nhân viên ' || v_MaNV || ' đã tồn tại!');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Lỗi hệ thống: ' || SQLERRM);
END SP_THEM_NHANVIEN;
/

CREATE OR REPLACE PROCEDURE SP_XOA_NHANVIEN (
    p_MaNV IN NHANVIEN.MaNV%TYPE
)
IS
    v_ErrorCode NUMBER;
    v_ErrorMsg  VARCHAR2(4000);
BEGIN
    DELETE FROM NHANVIEN WHERE MaNV = p_MaNV;

    -- Kiểm tra nếu không có dòng nào bị ảnh hưởng (Mã NV không tồn tại)
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Không tìm thấy nhân viên có mã: ' || p_MaNV);
    END IF;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- 🔑 BƯỚC QUAN TRỌNG: Ghi nhận mã lỗi hệ thống ngay lập tức trước khi ROLLBACK
        v_ErrorCode := SQLCODE;
        v_ErrorMsg  := SQLERRM;
        
        ROLLBACK; -- Sau lệnh này SQLCODE hệ thống sẽ bị thay đổi

        -- Tiến hành bẫy lỗi dựa trên biến tạm đã lưu
        IF v_ErrorCode = -2292 THEN
            RAISE_APPLICATION_ERROR(-20006, 'Không thể xóa vì nhân viên này đang có dữ liệu liên quan (Hóa đơn, phiếu nhập...)!');
        ELSE
            RAISE_APPLICATION_ERROR(-20007, 'Lỗi hệ thống khi xóa: ' || v_ErrorMsg);
        END IF;
END SP_XOA_NHANVIEN;
/
---
CREATE OR REPLACE PROCEDURE SP_DANGKY_TAIKHOAN (
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