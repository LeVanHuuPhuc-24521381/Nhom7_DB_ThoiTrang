--Check số lượng sản phẩm
CREATE OR REPLACE TRIGGER trg_check_soluong_sanpham
BEFORE INSERT OR UPDATE ON SANPHAM
FOR EACH ROW
BEGIN
    IF :NEW.SoLuongTon < 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'So luong san pham khong duoc nho hon 0');
    END IF;
END;    
/
--Chặn xóa khi sản phẩm đã có trong bảng khác
CREATE OR REPLACE TRIGGER trg_block_delete_sanpham
BEFORE DELETE ON SANPHAM
FOR EACH ROW
DECLARE
    v_donhang   NUMBER;
    v_giohang   NUMBER;
    v_phieunhap NUMBER;
    v_danhgia   NUMBER;
    v_km        NUMBER;
BEGIN
    -- Kiểm tra trong chi tiết đơn hàng
    SELECT COUNT(*) INTO v_donhang
    FROM CHITIET_DONHANG
    WHERE MaSP = :OLD.MaSP;

    -- Kiểm tra trong giỏ hàng
    SELECT COUNT(*) INTO v_giohang
    FROM CHITIET_GIOHANG
    WHERE MaSP = :OLD.MaSP;

    -- Kiểm tra trong phiếu nhập
    SELECT COUNT(*) INTO v_phieunhap
    FROM CHITIET_PHIEUNHAP
    WHERE MaSP = :OLD.MaSP;

    -- Kiểm tra đánh giá
    SELECT COUNT(*) INTO v_danhgia
    FROM DANHGIA
    WHERE MaSP = :OLD.MaSP;

    -- Kiểm tra khuyến mãi
    SELECT COUNT(*) INTO v_km
    FROM CHITIET_KHUYENMAI
    WHERE MaSP = :OLD.MaSP;

    -- Nếu có dữ liệu liên quan → chặn xóa
    IF v_donhang > 0 THEN
        RAISE_APPLICATION_ERROR(-20031,
            'Khong the xoa san pham da co trong don hang');
    ELSIF v_giohang > 0 THEN
        RAISE_APPLICATION_ERROR(-20032,
            'San pham dang ton tai trong gio hang');
    ELSIF v_phieunhap > 0 THEN
        RAISE_APPLICATION_ERROR(-20033,
            'San pham da duoc nhap kho');
    ELSIF v_danhgia > 0 THEN
        RAISE_APPLICATION_ERROR(-20034,
            'San pham da co danh gia');
    ELSIF v_km > 0 THEN
        RAISE_APPLICATION_ERROR(-20035,
            'San pham dang ap dung khuyen mai');
    END IF;

END;
/
-- Khi cập nhật sản phẩm
CREATE OR REPLACE TRIGGER trg_update_sanpham
BEFORE UPDATE ON SANPHAM
FOR EACH ROW
DECLARE
    v_count_dh NUMBER;
BEGIN
    -- 1. KIỂM TRA SỐ LƯỢNG KHÔNG ÂM
    IF :NEW.SoLuong < 0 THEN
        RAISE_APPLICATION_ERROR(-20050,
            'So luong san pham khong duoc am');
    END IF;

    -- 2. KIỂM TRA GIÁ KHÔNG ÂM
    IF :NEW.DonGia <= 0 THEN
        RAISE_APPLICATION_ERROR(-20051,
            'Don gia phai lon hon 0');
    END IF;

    -- 3. KHÔNG CHO SỬA MÃ SẢN PHẨM NẾU ĐÃ CÓ ĐƠN HÀNG
    SELECT COUNT(*) INTO v_count_dh
    FROM CHITIET_DONHANG
    WHERE MaSP = :OLD.MaSP;

    IF v_count_dh > 0 AND :NEW.MaSP <> :OLD.MaSP THEN
        RAISE_APPLICATION_ERROR(-20052,
            'Khong duoc sua MaSP da ton tai trong don hang');
    END IF;

    -- 4. TRÁNH SET NULL CÁC FIELD QUAN TRỌNG
    IF :NEW.TenSP IS NULL THEN
        RAISE_APPLICATION_ERROR(-20053,
            'Ten san pham khong duoc NULL');
    END IF;

END;
/
---Ràng buộc của danh mục 
CREATE OR REPLACE TRIGGER trg_danhmuc_full
BEFORE INSERT OR UPDATE ON DANHMUC
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN

    -- =========================
    -- 1. KIỂM TRA MaDM
    -- =========================
    IF :NEW.MaDM IS NULL THEN
        RAISE_APPLICATION_ERROR(-20060, 'Ma danh muc khong duoc NULL');
    END IF;

    -- =========================
    -- 2. KIỂM TRA TÊN DANH MỤC
    -- =========================
    IF :NEW.TenDM IS NULL OR TRIM(:NEW.TenDM) = '' THEN
        RAISE_APPLICATION_ERROR(-20061, 'Ten danh muc khong duoc rong');
    END IF;

    -- =========================
    -- 3. KIỂM TRA TRÙNG TÊN (INSERT + UPDATE)
    -- =========================
    SELECT COUNT(*) INTO v_count
    FROM DANHMUC
    WHERE UPPER(TenDM) = UPPER(:NEW.TenDM)
      AND MaDM <> NVL(:OLD.MaDM, '###');

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20062, 'Danh muc da ton tai');
    END IF;

    -- =========================
    -- 4. KIỂM TRA TRẠNG THÁI
    -- =========================
    IF :NEW.TrangThai IS NULL THEN
        :NEW.TrangThai := 'ACTIVE';
    ELSIF :NEW.TrangThai NOT IN ('ACTIVE','INACTIVE') THEN
        RAISE_APPLICATION_ERROR(-20063, 'Trang thai khong hop le');
    END IF;

    -- =========================
    -- 5. RÀNG BUỘC UPDATE (KHÔNG CHO SỬA KHI CÓ SẢN PHẨM)
    -- =========================
    IF UPDATING THEN
        SELECT COUNT(*) INTO v_count
        FROM SANPHAM
        WHERE MaDM = :OLD.MaDM;

        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20064,
                'Khong the cap nhat danh muc da co san pham');
        END IF;
    END IF;

END;
/
--Chặn xóa khi danh mục đã có sản phẩm
CREATE OR REPLACE TRIGGER trg_block_delete_danhmuc
BEFORE DELETE ON DANHMUC
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM SANPHAM
    WHERE MaDM = :OLD.MaDM;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20070,
            'Khong the xoa danh muc da co san pham');
    END IF;
END;
/
--Giỏ hàng 
-- thêm sản phẩm vào giỏ 
CREATE OR REPLACE TRIGGER trg_gh_insert
BEFORE INSERT ON CHITIET_GIOHANG
FOR EACH ROW
DECLARE
    v_stock NUMBER;
BEGIN
    -- kiểm tra số lượng hợp lệ
    IF :NEW.SoLuong <= 0 THEN
        RAISE_APPLICATION_ERROR(-20090, 'So luong phai > 0');
    END IF;

    -- kiểm tra tồn kho
    SELECT SoLuong INTO v_stock
    FROM SANPHAM
    WHERE MaSP = :NEW.MaSP;

    IF :NEW.SoLuong > v_stock THEN
        RAISE_APPLICATION_ERROR(-20091, 'Khong du hang trong kho');
    END IF;
END;
/

-- trường hợp đã có sản phẩm sản thì chỉ cần tăng số lượng
CREATE OR REPLACE TRIGGER trg_gh_merge
BEFORE INSERT ON CHITIET_GIOHANG
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM CHITIET_GIOHANG
    WHERE MaGH = :NEW.MaGH
      AND MaSP = :NEW.MaSP;

    IF v_count > 0 THEN
        UPDATE CHITIET_GIOHANG
        SET SoLuong = SoLuong + :NEW.SoLuong
        WHERE MaGH = :NEW.MaGH
          AND MaSP = :NEW.MaSP;

        -- chặn insert gốc
        RAISE_APPLICATION_ERROR(-20095,
            'Da ton tai san pham - da cong don so luong');
    END IF;
END;
/
---Cập nhật thành tiền và số lượng giỏ hàng khi thêm, xóa sản phẩm.
CREATE OR REPLACE TRIGGER trg_gh_update_total
AFTER INSERT OR UPDATE OR DELETE ON CHITIET_GIOHANG
FOR EACH ROW
DECLARE
    v_maGH CHITIET_GIOHANG.MaGH%TYPE;
BEGIN

    -- xác định MaGH (INSERT/UPDATE/DELETE)
    v_maGH := NVL(:NEW.MaGH, :OLD.MaGH);

    -- =========================
    -- 1. CẬP NHẬT THÀNH TIỀN TỪNG DÒNG
    -- =========================
    UPDATE CHITIET_GIOHANG ct
    SET ct.SoLuong = ct.SoLuong
    WHERE ct.MaGH = v_maGH;

    -- =========================
    -- 2. CẬP NHẬT TỔNG TIỀN GIỎ HÀNG
    -- =========================
    UPDATE GIOHANG gh
    SET gh.TongTien = (
        SELECT NVL(SUM(ct.SoLuong * sp.DonGia), 0)
        FROM CHITIET_GIOHANG ct
        JOIN SANPHAM sp ON ct.MaSP = sp.MaSP
        WHERE ct.MaGH = v_maGH
    )
    WHERE gh.MaGH = v_maGH;

END;
/