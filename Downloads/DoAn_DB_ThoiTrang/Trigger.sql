---1. Check định dạng nhập của email nhà cung cấp--------------------------------------
CREATE OR REPLACE TRIGGER tg_check_email_format_ncc
BEFORE INSERT OR UPDATE OF Email ON NHACUNGCAP
FOR EACH ROW
BEGIN
    IF :NEW.Email IS NOT NULL THEN
        IF NOT REGEXP_LIKE(:NEW.Email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
            RAISE_APPLICATION_ERROR(-20008, 'Lỗi: Định dạng Email nhà cung cấp không hợp lệ.');
        END IF;
    END IF;
END;

---2. Check định dạng nhập của email khách hàng--------------------------------------
CREATE OR REPLACE TRIGGER tg_check_email_format
BEFORE INSERT OR UPDATE OF Email ON KHACHHANG
FOR EACH ROW
BEGIN
    IF :NEW.Email IS NOT NULL THEN
        IF NOT REGEXP_LIKE(:NEW.Email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$') THEN
            RAISE_APPLICATION_ERROR(-20006, 'Lỗi: Định dạng Email khách hàng không hợp lệ.');
        END IF;
    END IF;
END;

---3. Số điện thoại của nhân viên không được trùng--------------------------------------
CREATE OR REPLACE TRIGGER tg_check_duplicate_employeePhone
BEFORE INSERT OR UPDATE OF SDT ON NHANVIEN
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM NHANVIEN WHERE SDT = :NEW.SDT;
    IF (v_count > 0) THEN
        RAISE_APPLICATION_ERROR(-20002, 'Lỗi: Số điện thoại nhân viên đã được đăng ký.');
    END IF;
END;

---4. Số điện thoại của khách hàng không được trùng--------------------------------------
CREATE OR REPLACE TRIGGER tg_check_duplicate_customerPhone
BEFORE INSERT OR UPDATE OF SDT ON KHACHHANG
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM KHACHHANG WHERE SDT = :NEW.SDT;
    IF (v_count > 0) THEN
        RAISE_APPLICATION_ERROR(-20001, 'Lỗi: Số điện thoại khách hàng đã tồn tại trong hệ thống.');
    END IF;
END;
---5. Giá bán của sản phẩm phải > 0 ---------------------------------------
CREATE OR REPLACE TRIGGER tg_check_product_price
BEFORE INSERT OR UPDATE OF GiaBan ON SANPHAM
FOR EACH ROW
BEGIN
    IF (:NEW.GiaBan < 0) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Lỗi: Giá bán sản phẩm không được nhỏ hơn 0.');
    END IF;
END;
---6. Xử lý hoàn trả đơn hàng
CREATE OR REPLACE TRIGGER tg_xu_ly_hoan_tra_don
AFTER UPDATE OF TrangThai ON DONHANG
FOR EACH ROW
BEGIN
        IF (:NEW.TrangThai IN ('Đã hủy', 'Trả hàng')) AND (:OLD.TrangThai NOT IN ('Đã hủy', 'Trả hàng')) THEN      
                FOR rec IN (SELECT MaSP, SoLuong FROM CHITIET_DONHANG WHERE MaDH = :NEW.MaDH) LOOP
            UPDATE SANPHAM 
            SET SoLuongTon = SoLuongTon + rec.SoLuong 
            WHERE MaSP = rec.MaSP;
        END LOOP;
              UPDATE DONHANG SET TongTien = 0 WHERE MaDH = :NEW.MaDH;
    END IF;
END;
---7. Cập nhật tồn kho bán hàng
CREATE OR REPLACE TRIGGER TRG_CAPNHAT_TONKHO_BANHANG
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
