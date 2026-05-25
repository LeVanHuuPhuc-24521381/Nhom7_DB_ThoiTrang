create or replace NONEDITIONABLE TRIGGER tg_check_email_format
BEFORE INSERT OR UPDATE OF Email ON KHACHHANG
FOR EACH ROW
BEGIN
    IF :NEW.Email IS NOT NULL THEN
        IF NOT REGEXP_LIKE(:NEW.Email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
            RAISE_APPLICATION_ERROR(-20006, 'Lỗi: Định dạng Email khách hàng không hợp lệ.');
        END IF;
    END IF;
END;
/
create or replace NONEDITIONABLE TRIGGER tg_check_email_ncc
BEFORE INSERT OR UPDATE OF Email ON NHACUNGCAP
FOR EACH ROW
DECLARE
    v_count NUMBER;
    -- Dùng AUTONOMOUS_TRANSACTION để Oracle cho phép SELECT trên chính bảng đang thao tác
    PRAGMA AUTONOMOUS_TRANSACTION; 
BEGIN
    IF :NEW.Email IS NOT NULL THEN

        -- ====================================================
        -- 1. KIỂM TRA ĐỊNH DẠNG EMAIL
        -- ====================================================
        IF NOT REGEXP_LIKE(:NEW.Email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
            RAISE_APPLICATION_ERROR(-20008, 'Lỗi: Định dạng Email nhà cung cấp không hợp lệ.');
        END IF;

        -- ====================================================
        -- 2. KIỂM TRA TRÙNG LẶP EMAIL
        -- ====================================================
        SELECT COUNT(*)
        INTO v_count
        FROM NHACUNGCAP
        WHERE EMAIL = :NEW.Email 
          AND MANCC != NVL(:NEW.MANCC, ' '); -- Bỏ qua chính bản ghi này nếu đang bấm Sửa (Update)

        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20009, 'Lỗi: Email này đã được sử dụng cho đối tác khác!');
        END IF;

        -- Lệnh bắt buộc khi sử dụng AUTONOMOUS_TRANSACTION
        COMMIT;

    END IF;
END;
/
create or replace NONEDITIONABLE TRIGGER tg_check_product_price
BEFORE INSERT OR UPDATE OF GiaBan ON SANPHAM
FOR EACH ROW
BEGIN
    IF (:NEW.GiaBan < 0) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Lỗi: Giá bán sản phẩm không được nhỏ hơn 0.');
    END IF;
END;
/
create or replace NONEDITIONABLE TRIGGER tg_xu_ly_hoan_tra_don
BEFORE UPDATE OF TrangThai ON DONHANG
FOR EACH ROW
BEGIN
    -- Chỉ kích hoạt khi trạng thái mới chuyển sang Hủy/Trả và trạng thái cũ chưa phải Hủy/Trả
    IF (:NEW.TrangThai IN (u'\0110\00e3 h\1ee7y', u'Tr\1ea3 h\00e0ng')) AND (:OLD.TrangThai NOT IN (u'\0110\00e3 h\1ee7y', u'Tr\1ea3 h\00e0ng')) THEN      

        -- Vòng lặp cộng lại số lượng vào bảng SANPHAM
        FOR rec IN (SELECT MaSP, SoLuong FROM CHITIET_DONHANG WHERE MaDH = :NEW.MaDH) LOOP
            UPDATE SANPHAM 
            SET SoLuongTon = SoLuongTon + rec.SoLuong 
            WHERE MaSP = rec.MaSP;
        END LOOP;

        -- Gán trực tiếp giá trị tổng tiền = 0 (Không dùng lệnh UPDATE)
        :NEW.TongTien := 0;
    END IF;
END;
/
create or replace NONEDITIONABLE TRIGGER TRG_CAPNHAT_TONKHO_BANHANG
AFTER INSERT OR UPDATE OR DELETE ON CHITIET_DONHANG
FOR EACH ROW
DECLARE
    v_TonKho SANPHAM.SoLuongTon%TYPE;
BEGIN
    IF INSERTING THEN
        SELECT SoLuongTon INTO v_TonKho FROM SANPHAM WHERE MaSP = :new.MaSP;
        IF (:new.SoLuong > v_TonKho) THEN
            RAISE_APPLICATION_ERROR(-20001, 'So luong ton kho khong du');
        ELSE
            UPDATE SANPHAM SET SoLuongTon = SoLuongTon - :new.SoLuong WHERE MaSP = :new.MaSP;
        END IF;        
    ELSIF UPDATING THEN
        UPDATE SANPHAM 
        SET SoLuongTon = SoLuongTon + :old.SoLuong - :new.SoLuong 
        WHERE MaSP = :new.MaSP;     
    ELSIF DELETING THEN
        UPDATE SANPHAM SET SoLuongTon = SoLuongTon + :old.SoLuong WHERE MaSP = :old.MaSP;
    END IF;
END;
/
create or replace NONEDITIONABLE TRIGGER trg_Check_SDT_NCC
BEFORE INSERT OR UPDATE ON NHACUNGCAP
FOR EACH ROW
DECLARE
    v_count_sdt NUMBER;

    -- Lệnh này giúp Trigger chạy độc lập, tránh lỗi đụng độ bảng (ORA-04091)
    PRAGMA AUTONOMOUS_TRANSACTION; 
BEGIN
    IF :NEW.SDT IS NOT NULL THEN

        -- ====================================================
        -- 1. KIỂM TRA PHẢI LÀ SỐ VÀ ĐÚNG 10 KÝ TỰ
        -- ====================================================
        IF LENGTH(:NEW.SDT) != 10 OR NOT REGEXP_LIKE(:NEW.SDT, '^[0-9]{10}$') THEN
            RAISE_APPLICATION_ERROR(-20005, 'Lỗi: Số điện thoại đối tác phải bao gồm chính xác 10 chữ số!');
        END IF;

        -- ====================================================
        -- 2. KIỂM TRA TRÙNG LẶP SỐ ĐIỆN THOẠI
        -- ====================================================
        SELECT COUNT(*) 
        INTO v_count_sdt
        FROM NHACUNGCAP
        WHERE SDT = :NEW.SDT 
          AND MANCC != NVL(:NEW.MANCC, ' '); -- Bỏ qua chính NCC này nếu đang Cập nhật (Sửa)

        IF v_count_sdt > 0 THEN
            RAISE_APPLICATION_ERROR(-20006, 'Lỗi: Số điện thoại này đã được sử dụng cho đối tác khác!');
        END IF;

        -- Bắt buộc phải có COMMIT khi dùng AUTONOMOUS_TRANSACTION
        COMMIT; 
    END IF;
END;
/
create or replace NONEDITIONABLE TRIGGER trg_Check_SDT_NhanVien
BEFORE INSERT OR UPDATE ON NHANVIEN
FOR EACH ROW
DECLARE
    v_count NUMBER;
    -- Lệnh này giúp Trigger chạy độc lập, tránh lỗi "Mutating Table" (ORA-04091) khi Update
    PRAGMA AUTONOMOUS_TRANSACTION; 
BEGIN
    -- Chỉ kiểm tra nếu người dùng có nhập SĐT
    IF :NEW.SDT IS NOT NULL THEN

        -- ====================================================
        -- 1. KIỂM TRA PHẢI LÀ SỐ VÀ ĐÚNG 10 KÝ TỰ
        -- ====================================================
        -- Dùng REGEXP_LIKE để đảm bảo chuỗi chỉ chứa các chữ số từ 0-9
        IF LENGTH(:NEW.SDT) != 10 OR NOT REGEXP_LIKE(:NEW.SDT, '^[0-9]{10}$') THEN
            RAISE_APPLICATION_ERROR(-20003, 'Lỗi: Số điện thoại phải bao gồm chính xác 10 chữ số!');
        END IF;

        -- ====================================================
        -- 2. KIỂM TRA TRÙNG LẶP SỐ ĐIỆN THOẠI
        -- ====================================================
        SELECT COUNT(*) 
        INTO v_count
        FROM NHANVIEN
        WHERE SDT = :NEW.SDT 
          AND MANV != NVL(:NEW.MANV, ' '); -- Bỏ qua chính nhân viên này nếu đang Update

        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20004, 'Lỗi: Số điện thoại này đã tồn tại trên hệ thống!');
        END IF;

        -- Bắt buộc phải có COMMIT khi dùng AUTONOMOUS_TRANSACTION
        COMMIT; 
    END IF;
END;
/
create or replace NONEDITIONABLE TRIGGER trg_Check_ThongTinNhanVien
BEFORE INSERT OR UPDATE ON NHANVIEN
FOR EACH ROW
BEGIN
    -- Chỉ kiểm tra khi cả Ngày Sinh và Ngày Vào Làm đều có dữ liệu
    IF :NEW.NgaySinh IS NOT NULL AND :NEW.NgayVaoLam IS NOT NULL THEN

        -- 1. Kiểm tra ngày sinh không được lớn hơn ngày vào làm
        IF :NEW.NgaySinh > :NEW.NgayVaoLam THEN
            RAISE_APPLICATION_ERROR(-20001, 'Lỗi: Ngày sinh không được lớn hơn ngày vào làm.');
        END IF;

        -- 2. Kiểm tra độ tuổi từ đủ 18 trở lên (tính tại thời điểm vào làm)
        -- Dùng hàm ADD_MONTHS cộng thêm 18 năm (18 * 12 tháng) vào ngày sinh
        IF ADD_MONTHS(:NEW.NgaySinh, 18 * 12) > :NEW.NgayVaoLam THEN
            RAISE_APPLICATION_ERROR(-20002, 'Lỗi: Nhân viên phải từ đủ 18 tuổi trở lên.');
        END IF;

    END IF;
END;
/
create or replace NONEDITIONABLE TRIGGER TRG_CHK_SOLUONG_DOITRA
BEFORE INSERT OR UPDATE ON LICHSUDOITRA
FOR EACH ROW
DECLARE
    v_SoLuongMua NUMBER;
    v_DaTra NUMBER := 0;
BEGIN
    -- BƯỚC 1: Lấy số lượng thực tế khách đã mua trong đơn hàng này
    BEGIN
        SELECT SoLuong INTO v_SoLuongMua
        FROM CHITIET_DONHANG
        WHERE MaDH = :NEW.MaDH AND MaSP = :NEW.MaSP;
    EXCEPTION
        -- Nếu câu SELECT không tìm thấy dữ liệu, nghĩa là khách đang trả 1 sản phẩm họ không hề mua trong mã đơn này!
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'Lỗi: Sản phẩm [' || :NEW.MaSP || '] không hề tồn tại trong hóa đơn [' || :NEW.MaDH || ']!');
    END;

    -- BƯỚC 2: Tính tổng số lượng sản phẩm này đã từng bị đổi/trả trước đó trong cùng đơn hàng (nếu có)
    -- Ví dụ: Khách mua 5 cái, hôm qua đem trả 2 cái, hôm nay đem trả 4 cái -> Tổng trả là 6 > 5 (Lỗi)
    SELECT NVL(SUM(SoLuong), 0) INTO v_DaTra
    FROM LICHSUDOITRA
    WHERE MaDH = :NEW.MaDH AND MaSP = :NEW.MaSP 
    AND MaDT != NVL(:NEW.MaDT, ' '); -- Bỏ qua chính mã đổi trả đang được cập nhật

    -- BƯỚC 3: Kiểm tra logic (Số lượng trả lần này + Số lượng các lần trả trước phải <= Số lượng mua)
    IF (:NEW.SoLuong + v_DaTra) > v_SoLuongMua THEN
        RAISE_APPLICATION_ERROR(-20003, 'Lỗi: Thao tác thất bại! Khách hàng đã mua (' || v_SoLuongMua || ') sản phẩm, đã trả (' || v_DaTra || ') sản phẩm. Không thể trả thêm (' || :NEW.SoLuong || ') sản phẩm nữa!');
    END IF;
END;
/
create or replace NONEDITIONABLE TRIGGER TRG_CHK_SOLUONG_MUA
BEFORE INSERT OR UPDATE ON CHITIET_DONHANG
FOR EACH ROW
DECLARE
    v_SoLuongTon NUMBER;
    v_TenSP NVARCHAR2(200);
BEGIN
    -- Lấy số lượng tồn và tên sản phẩm từ bảng SANPHAM
    SELECT SoLuongTon, TenSP 
    INTO v_SoLuongTon, v_TenSP
    FROM SANPHAM
    WHERE MaSP = :NEW.MaSP;

    -- So sánh: Nếu Số lượng mua > Số lượng tồn kho thì báo lỗi và hủy giao dịch
    IF :NEW.SoLuong > v_SoLuongTon THEN
        RAISE_APPLICATION_ERROR(-20001, 'Lỗi: Sản phẩm [' || v_TenSP || '] chỉ còn ' || v_SoLuongTon || ' chiếc trong kho. Không thể bán ' || :NEW.SoLuong || '!');
    END IF;
END;
/
create or replace NONEDITIONABLE TRIGGER TRG_KM_HETLUOT
BEFORE UPDATE ON KHUYENMAI
FOR EACH ROW
BEGIN
    -- Sử dụng trực tiếp :NEW.SoLuotDung để kiểm tra, TUYỆT ĐỐI không viết câu lệnh SELECT vào bảng KHUYENMAI ở đây
    IF :NEW.SoLuotDung <= 0 THEN
    :NEW.TrangThai := 'Tạm ngưng'; -- Hoặc trạng thái 'Hết lượt' tùy bạn đặt trong DB
    END IF;
END;

CREATE OR REPLACE TRIGGER trg_Check_ThongTinNhanVien
BEFORE INSERT OR UPDATE ON NHANVIEN
FOR EACH ROW
BEGIN
    -- Chỉ kiểm tra khi cả Ngày Sinh và Ngày Vào Làm đều có dữ liệu
    IF :NEW.NgaySinh IS NOT NULL AND :NEW.NgayVaoLam IS NOT NULL THEN
        
        -- 1. Kiểm tra ngày sinh không được lớn hơn ngày vào làm
        IF :NEW.NgaySinh > :NEW.NgayVaoLam THEN
            RAISE_APPLICATION_ERROR(-20001, 'Lỗi: Ngày sinh không được lớn hơn ngày vào làm.');
        END IF;

        -- 2. Kiểm tra độ tuổi từ đủ 18 trở lên (tính tại thời điểm vào làm)
        -- Dùng hàm ADD_MONTHS cộng thêm 18 năm (18 * 12 tháng) vào ngày sinh
        IF ADD_MONTHS(:NEW.NgaySinh, 18 * 12) > :NEW.NgayVaoLam THEN
            RAISE_APPLICATION_ERROR(-20002, 'Lỗi: Nhân viên phải từ đủ 18 tuổi trở lên.');
        END IF;
        
    END IF;
END;

CREATE OR REPLACE PROCEDURE SP_AP_DUNG_KHUYEN_MAI (
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
CREATE OR REPLACE TRIGGER TRG_KM_HETLUOT
BEFORE UPDATE ON KHUYENMAI
FOR EACH ROW
BEGIN
    -- Sử dụng trực tiếp :NEW.SoLuotDung để kiểm tra, TUYỆT ĐỐI không viết câu lệnh SELECT vào bảng KHUYENMAI ở đây
    IF :NEW.SoLuotDung <= 0 THEN
:NEW.TrangThai := 'Tạm ngưng'; -- Hoặc trạng thái 'Hết lượt' tùy bạn đặt trong DB
    END IF;
END;