-- =======================================================
-- LÀM SẠCH DATABASE TRƯỚC KHI INSERT (XÓA TỪ NGỌN XUỐNG GỐC)
-- =======================================================
DELETE FROM CHITIET_GIOHANG;
DELETE FROM CHITIET_PHIEUNHAP;
DELETE FROM CHITIET_DONHANG;
DELETE FROM DANHGIA;
DELETE FROM DONHANG;
DELETE FROM PHIEUNHAP;
DELETE FROM GIOHANG;
DELETE FROM DIACHI;
DELETE FROM SANPHAM;
DELETE FROM KHACHHANG;
DELETE FROM NHANVIEN;
DELETE FROM KHUYENMAI;
DELETE FROM NHACUNGCAP;
DELETE FROM KHOHANG;
DELETE FROM DANHMUC;
DELETE FROM TAIKHOAN;

-- =======================================================
-- 1. DANH MỤC, KHO HÀNG & SẢN PHẨM (MÃ TỪ 01)
-- =======================================================
INSERT INTO DANHMUC (MaDM, TenDM) VALUES ('DM01', N'Áo');
INSERT INTO DANHMUC (MaDM, TenDM) VALUES ('DM02', N'Quần');
INSERT INTO DANHMUC (MaDM, TenDM) VALUES ('DM03', N'Váy');
INSERT INTO DANHMUC (MaDM, TenDM) VALUES ('DM04', N'Giày');
INSERT INTO DANHMUC (MaDM, TenDM) VALUES ('DM05', N'Mũ');
INSERT INTO DANHMUC (MaDM, TenDM) VALUES ('DM06', N'Túi');

INSERT INTO KHOHANG (MaKho, TenKho, DiaChiKho) VALUES ('KHO01', N'Kho Trung Tâm', N'ĐHQG HCM');

-- Sản phẩm Váy (SP001 - SP006)
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP001', 'DM03', 'KHO01', N'Váy suông basic', N'Xanh nhạt', 'FreeSize', 250000, 20, N'Đang bán', 'vay_suong.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP002', 'DM03', 'KHO01', N'Váy ôm body sexy', N'Đen', 'S', 350000, 15, N'Đang bán', 'vay_body.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP003', 'DM03', 'KHO01', N'Váy sơ mi công sở', N'Trắng', 'M', 420000, 12, N'Đang bán', 'vay_so_mi.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP004', 'DM03', 'KHO01', N'Váy hai dây lụa', N'Đỏ rượu', 'S', 290000, 25, N'Đang bán', 'vay_hai_day.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP005', 'DM03', 'KHO01', N'Váy Babydoll', N'Hồng phấn', 'M', 310000, 18, N'Đang bán', 'vay_babydoll.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP006', 'DM03', 'KHO01', N'Váy Hoa Nhí', N'Họa tiết', 'S', 890000, 20, N'Đang bán', 'vay_hoa.png');

-- Sản phẩm Áo (SP07 - SP012)
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP007', 'DM01', 'KHO01', N'Áo ba lỗ thể thao', N'Xám', 'L', 150000, 40, N'Đang bán', 'ao_ba_lo.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP008', 'DM01', 'KHO01', N'Áo khoác Jean Denim', N'Xanh bụi', 'XL', 650000, 15, N'Đang bán', 'ao_jean.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP009', 'DM01', 'KHO01', N'Áo Vest Hàn Quốc', N'Đen', 'L', 1200000, 10, N'Đang bán', 'ao_vest.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP010', 'DM01', 'KHO01', N'Áo khoác gió nhẹ', N'Xanh Navy', 'M', 380000, 25, N'Đang bán', 'ao_khoac.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP011', 'DM01', 'KHO01', N'Áo thun Cotton Premium', N'Trắng', 'S', 220000, 60, N'Đang bán', 'ao_thun.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP012', 'DM01', 'KHO01', N'Áo Sơ Mi Lụa', N'Trắng', 'M', 550000, 50, N'Đang bán', 'ao_so_mi.png');

-- Sản phẩm Mũ (SP013 - SP18)
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP013', 'DM05', 'KHO01', N'Mũ nơ tiểu thư', N'Kem', 'FreeSize', 180000, 25, N'Đang bán', 'mu_no.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP014', 'DM05', 'KHO01', N'Mũ quân đội Army', N'Xanh rêu', 'L', 220000, 15, N'Đang bán', 'mu_army.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP015', 'DM05', 'KHO01', N'Mũ cói đi biển', N'Vàng mây', 'FreeSize', 250000, 30, N'Đang bán', 'mu_di_bien.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP016', 'DM05', 'KHO01', N'Mũ vành tròn basic', N'Trắng', 'M', 160000, 20, N'Đang bán', 'mu_vanh.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP017', 'DM05', 'KHO01', N'Mũ lưỡi trai bóng chày', N'Đen', 'FreeSize', 195000, 50, N'Đang bán', 'mu_bong_chay.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP018', 'DM05', 'KHO01', N'Mũ chạy bộ siêu nhẹ', N'Xám', 'FreeSize', 210000, 35, N'Đang bán', 'mu_chay_bo.png');

-- Sản phẩm Quần (SP19 - SP024)
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP019', 'DM02', 'KHO01', N'Quần Jean Slimfit', N'Xanh đậm', '32', 450000, 40, N'Đang bán', 'quan_jean.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP020', 'DM02', 'KHO01', N'Quần Jogger thun túi hộp', N'Xám', 'M', 280000, 50, N'Đang bán', 'quan_jogger.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP021', 'DM02', 'KHO01', N'Quần Short Kaki', N'Be', '30', 190000, 60, N'Đang bán', 'quan_short.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP022', 'DM02', 'KHO01', N'Quần Kaki ống đứng', N'Xanh rêu', '31', 350000, 25, N'Đang bán', 'quan_kaki.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP023', 'DM02', 'KHO01', N'Quần Baggy vải trendy', N'Nâu tây', 'S', 320000, 20, N'Đang bán', 'quan_baggy.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP024', 'DM02', 'KHO01', N'Quần Tây Âu', N'Đen', 'L', 720000, 30, N'Đang bán', 'quan_tay.png');

-- Sản phẩm Túi (SP025 - SP30)
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP025', 'DM06', 'KHO01', N'Ví cầm tay nữ sang trọng', N'Kem', 'S', 450000, 20, N'Đang bán', 'vi_nu.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP026', 'DM06', 'KHO01', N'Túi vải Tote Canvas', N'Trắng', 'L', 120000, 100, N'Đang bán', 'tui_tote.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP027', 'DM06', 'KHO01', N'Túi đeo chéo màu hồng', N'Hồng', 'M', 320000, 15, N'Đang bán', 'tui_hong.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP028', 'DM06', 'KHO01', N'Túi da đeo chéo cao cấp', N'Nâu', 'M', 580000, 25, N'Đang bán', 'tui_da.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP029', 'DM06', 'KHO01', N'Ví da nam dáng đứng', N'Đen', 'S', 350000, 30, N'Đang bán', 'vi_nam.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP030', 'DM06', 'KHO01', N'Túi xách tay công sở', N'Xám', 'L', 850000, 10, N'Đang bán', 'tui_xach.png');

-- Sản phẩm Giày (SP31 - SP36)
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP031', 'DM04', 'KHO01', N'Giày tây công sở', N'Đen', '40', 950000, 15, N'Đang bán', 'giay_tay.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP032', 'DM04', 'KHO01', N'Giày cao gót nữ', N'Nude', '37', 450000, 20, N'Đang bán', 'giay_cao_got.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP033', 'DM04', 'KHO01', N'Giày búp bê đáng yêu', N'Hồng', '36', 300000, 25, N'Đang bán', 'giay_bup_be.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP034', 'DM04', 'KHO01', N'Giày Sandal quai mảnh', N'Nâu', '38', 250000, 30, N'Đang bán', 'giay_sandal.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP035', 'DM04', 'KHO01', N'Giày Sneaker Streetwear', N'Trắng', '42', 1200000, 10, N'Đang bán', 'giay_sneaker.png');
INSERT INTO SANPHAM (MaSP, MaDM, MaKho, TenSP, MauSac, KichCo, GiaBan, SoLuongTon, TrangThai, HINHANH) VALUES ('SP036', 'DM04', 'KHO01', N'Giày thể thao chạy bộ', N'Xám', '41', 850000, 12, N'Đang bán', 'giay_thethao.png');

-- =======================================================
-- 2. TÀI KHOẢN & NHÂN SỰ CHUẨN (MÃ TỪ NV01 - NV12)
-- =======================================================
-- Tài khoản Nhân sự
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('ql_an', '123456', N'Quản lý', 1, 'an.nguyen@cuahang.com');
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('ql_binh', '123456', N'Quản lý', 1, 'binh.tran@cuahang.com');
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('ql_cuong', '123456', N'Quản lý', 1, 'cuong.le@cuahang.com');
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('ql_dung', '123456', N'Quản lý', 1, 'dung.pham@cuahang.com');

-- Tài khoản Nhân viên kho
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('nvk_ha', '123456', N'Nhân viên', 1, 'ha.hoang@cuahang.com');
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('nvk_hoang', '123456', N'Nhân viên', 1, 'hoang.vu@cuahang.com');
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('nvk_khoa', '123456', N'Nhân viên', 1, 'khoa.dang@cuahang.com');
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('nvk_lam', '123456', N'Nhân viên', 1, 'lam.bui@cuahang.com');

-- Tài khoản Nhân viên bán hàng
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('nvb_mai', '123456', N'Nhân viên', 1, 'mai.ngo@cuahang.com');
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('nvb_ngoc', '123456', N'Nhân viên', 1, 'ngoc.dinh@cuahang.com');
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('nvb_oanh', '123456', N'Nhân viên', 1, 'oanh.ly@cuahang.com');
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('nvb_phuong', '123456', N'Nhân viên', 1, 'phuong.ho@cuahang.com');

-- Mã NV01-NV04: Quản lý
INSERT INTO NHANVIEN (MaNV, TenNV, NgaySinh, GioiTinh, SDT, DiaChi, ChucVu, NgayVaoLam, TrangThai, TenDangNhap) VALUES ('NV01', N'Nguyễn Trọng An', TO_DATE('1995-02-10', 'YYYY-MM-DD'), 'Nam', '0911000001', N'Q1, TP.HCM', N'Quản lý', SYSDATE - 365, 1, 'ql_an');
INSERT INTO NHANVIEN (MaNV, TenNV, NgaySinh, GioiTinh, SDT, DiaChi, ChucVu, NgayVaoLam, TrangThai, TenDangNhap) VALUES ('NV02', N'Trần Thái Bình', TO_DATE('1996-04-15', 'YYYY-MM-DD'), 'Nam', '0911000002', N'Q3, TP.HCM', N'Quản lý', SYSDATE - 300, 1, 'ql_binh');
INSERT INTO NHANVIEN (MaNV, TenNV, NgaySinh, GioiTinh, SDT, DiaChi, ChucVu, NgayVaoLam, TrangThai, TenDangNhap) VALUES ('NV03', N'Lê Việt Cường', TO_DATE('1994-08-20', 'YYYY-MM-DD'), 'Nam', '0911000003', N'Q5, TP.HCM', N'Quản lý', SYSDATE - 400, 1, 'ql_cuong');
INSERT INTO NHANVIEN (MaNV, TenNV, NgaySinh, GioiTinh, SDT, DiaChi, ChucVu, NgayVaoLam, TrangThai, TenDangNhap) VALUES ('NV04', N'Phạm Tiến Dũng', TO_DATE('1997-11-05', 'YYYY-MM-DD'), 'Nam', '0911000004', N'Q7, TP.HCM', N'Quản lý', SYSDATE - 200, 1, 'ql_dung');

-- Mã NV05-NV08: Nhân viên Kho
INSERT INTO NHANVIEN (MaNV, TenNV, NgaySinh, GioiTinh, SDT, DiaChi, ChucVu, NgayVaoLam, TrangThai, TenDangNhap) VALUES ('NV05', N'Hoàng Thu Hà', TO_DATE('2000-01-20', 'YYYY-MM-DD'), N'Nữ', '0922000001', N'Thủ Đức', N'Nhân viên kho', SYSDATE - 150, 1, 'nvk_ha');
INSERT INTO NHANVIEN (MaNV, TenNV, NgaySinh, GioiTinh, SDT, DiaChi, ChucVu, NgayVaoLam, TrangThai, TenDangNhap) VALUES ('NV06', N'Vũ Huy Hoàng', TO_DATE('1999-05-12', 'YYYY-MM-DD'), 'Nam', '0922000002', N'Bình Thạnh', N'Nhân viên kho', SYSDATE - 100, 1, 'nvk_hoang');
INSERT INTO NHANVIEN (MaNV, TenNV, NgaySinh, GioiTinh, SDT, DiaChi, ChucVu, NgayVaoLam, TrangThai, TenDangNhap) VALUES ('NV07', N'Đặng Anh Khoa', TO_DATE('2001-09-08', 'YYYY-MM-DD'), 'Nam', '0922000003', N'Gò Vấp', N'Nhân viên kho', SYSDATE - 80, 1, 'nvk_khoa');
INSERT INTO NHANVIEN (MaNV, TenNV, NgaySinh, GioiTinh, SDT, DiaChi, ChucVu, NgayVaoLam, TrangThai, TenDangNhap) VALUES ('NV08', N'Bùi Tùng Lâm', TO_DATE('1998-12-25', 'YYYY-MM-DD'), 'Nam', '0922000004', N'Tân Bình', N'Nhân viên kho', SYSDATE - 50, 1, 'nvk_lam');

-- Mã NV09-NV12: Nhân viên Bán hàng
INSERT INTO NHANVIEN (MaNV, TenNV, NgaySinh, GioiTinh, SDT, DiaChi, ChucVu, NgayVaoLam, TrangThai, TenDangNhap) VALUES ('NV09', N'Ngô Ngọc Mai', TO_DATE('2002-03-14', 'YYYY-MM-DD'), N'Nữ', '0933000001', N'Q10, TP.HCM', N'Nhân viên bán hàng', SYSDATE - 60, 1, 'nvb_mai');
INSERT INTO NHANVIEN (MaNV, TenNV, NgaySinh, GioiTinh, SDT, DiaChi, ChucVu, NgayVaoLam, TrangThai, TenDangNhap) VALUES ('NV10', N'Đinh Bảo Ngọc', TO_DATE('2003-07-22', 'YYYY-MM-DD'), N'Nữ', '0933000002', N'Q1, TP.HCM', N'Nhân viên bán hàng', SYSDATE - 45, 1, 'nvb_ngoc');
INSERT INTO NHANVIEN (MaNV, TenNV, NgaySinh, GioiTinh, SDT, DiaChi, ChucVu, NgayVaoLam, TrangThai, TenDangNhap) VALUES ('NV11', N'Lý Kiều Oanh', TO_DATE('2001-10-10', 'YYYY-MM-DD'), N'Nữ', '0933000003', N'Q3, TP.HCM', N'Nhân viên bán hàng', SYSDATE - 30, 1, 'nvb_oanh');
INSERT INTO NHANVIEN (MaNV, TenNV, NgaySinh, GioiTinh, SDT, DiaChi, ChucVu, NgayVaoLam, TrangThai, TenDangNhap) VALUES ('NV12', N'Hồ Lan Phương', TO_DATE('2000-02-28', 'YYYY-MM-DD'), N'Nữ', '0933000004', N'Q5, TP.HCM', N'Nhân viên bán hàng', SYSDATE - 15, 1, 'nvb_phuong');

-- =======================================================
-- 3. KHÁCH HÀNG (MÃ TỪ KH01 - KH06)
-- =======================================================
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('kh_thu', '123456', N'Khách hàng', 1, 'thunguyen@gmail.com');
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('kh_quyen', '123456', N'Khách hàng', 1, 'quyen@gmail.com');
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('kh_tam', '123456', N'Khách hàng', 1, 'tam@gmail.com');
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('kh_uyen', '123456', N'Khách hàng', 1, 'uyen@gmail.com');
INSERT INTO TAIKHOAN (TenDangNhap, MatKhau, Quyen, TrangThai, Email) VALUES ('kh_vy', '123456', N'Khách hàng', 1, 'vy@gmail.com');

INSERT INTO KHACHHANG (MaKH, TenKH, SDT, DiemTichLuy, Email, TenDangNhap) VALUES ('KH01', N'Khách Vãng Lai', '0000000000', 0, NULL, NULL);
INSERT INTO KHACHHANG (MaKH, TenKH, SDT, DiemTichLuy, Email, TenDangNhap) VALUES ('KH02', N'Nguyễn Thị Thu', '0987654321', 150, 'thunguyen@gmail.com', 'kh_thu');
INSERT INTO KHACHHANG (MaKH, TenKH, SDT, DiemTichLuy, Email, TenDangNhap) VALUES ('KH03', N'Trịnh Tú Quyên', '0944000001', 50, 'quyen@gmail.com', 'kh_quyen');
INSERT INTO KHACHHANG (MaKH, TenKH, SDT, DiemTichLuy, Email, TenDangNhap) VALUES ('KH04', N'Cao Thanh Tâm', '0944000002', 120, 'tam@gmail.com', 'kh_tam');
INSERT INTO KHACHHANG (MaKH, TenKH, SDT, DiemTichLuy, Email, TenDangNhap) VALUES ('KH05', N'Đào Tố Uyên', '0944000003', 0, 'uyen@gmail.com', 'kh_uyen');
INSERT INTO KHACHHANG (MaKH, TenKH, SDT, DiemTichLuy, Email, TenDangNhap) VALUES ('KH06', N'Châu Tường Vy', '0944000004', 300, 'vy@gmail.com', 'kh_vy');

-- =======================================================
-- 4. NHÀ CUNG CẤP & KHUYẾN MÃI CHUẨN (MÃ TỪ 01)
-- =======================================================
INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, SDT, Email) VALUES ('NCC01', N'Xưởng May Tân Bình', N'Q. Tân Bình, TP.HCM', '02838123456', 'tanbinh@xuongmay.com');
INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, SDT, Email) VALUES ('NCC02', N'Đại lý Phụ Kiện và Giày', N'Q. 10, TP.HCM', '02838654321', 'phukien@daily.com');
INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, SDT, Email) VALUES ('NCC03', N'Xưởng May Thủ Đức', N'Linh Trung, Thủ Đức, TP.HCM', '0901234003', 'thuduc@xuongmay.vn');
INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, SDT, Email) VALUES ('NCC04', N'Tổng Kho Vải Chợ Lớn', N'Q. 5, TP.HCM', '0901234004', 'vaicholon@tongkho.com');
INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, SDT, Email) VALUES ('NCC05', N'Công Ty Dệt May Vina', N'KCN Sóng Thần, Bình Dương', '0901234005', 'contact@vinadetmay.vn');
INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, SDT, Email) VALUES ('NCC06', N'Xưởng Gia Công Đồ Jean', N'Q. Tân Phú, TP.HCM', '0901234006', 'jeantanphu@xuong.com');
INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, SDT, Email) VALUES ('NCC07', N'Kho Phụ Kiện Quảng Châu', N'Q. Hà Đông, Hà Nội', '0901234007', 'phukienqc@kho.vn');
INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, SDT, Email) VALUES ('NCC08', N'Xưởng Giày Da VNXK', N'Củ Chi, TP.HCM', '0901234008', 'vnxkgiayda@xuonggiay.com');
INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, SDT, Email) VALUES ('NCC09', N'Đại Lý Sỉ Quần Tây Âu', N'Q. 10, TP.HCM', '0901234009', 'siquantay@daily.com');
INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, SDT, Email) VALUES ('NCC10', N'Xưởng May Áo Thun Cotton', N'Q. 12, TP.HCM', '0901234010', 'aothunq12@xuongmay.vn');
INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, SDT, Email) VALUES ('NCC11', N'Kho Túi Xách Xuất Khẩu', N'Biên Hòa, Đồng Nai', '0901234011', 'tuixachxk@kho.vn');
INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, SDT, Email) VALUES ('NCC12', N'Xưởng Mũ Nón Hạnh Phúc', N'Q. Bình Tân, TP.HCM', '0901234012', 'munonhp@xuong.com');

INSERT INTO KHUYENMAI (MaKM, TenKM, PhanTramGiam, GiaTriToiThieu, GiamToiDa, NgayBatDau, NgayKetThuc, SoLuotDung, TrangThai) VALUES ('KM01', N'Mừng Khai Trương', 10, 500000, 100000, SYSDATE - 1, SYSDATE + 30, 0, N'Đang áp dụng');
INSERT INTO KHUYENMAI (MaKM, TenKM, PhanTramGiam, GiaTriToiThieu, GiamToiDa, NgayBatDau, NgayKetThuc, SoLuotDung, TrangThai) VALUES ('KM02', N'Ưu đãi Sinh viên', 15, 0, 50000, SYSDATE - 10, SYSDATE + 100, 5, N'Đang áp dụng');
INSERT INTO KHUYENMAI (MaKM, TenKM, PhanTramGiam, GiaTriToiThieu, GiamToiDa, NgayBatDau, NgayKetThuc, SoLuotDung, TrangThai) VALUES ('KM03', N'Flash Sale Cuối Tuần', 10, 300000, 50000, SYSDATE - 1, SYSDATE + 2, 12, N'Đang áp dụng');
INSERT INTO KHUYENMAI (MaKM, TenKM, PhanTramGiam, GiaTriToiThieu, GiamToiDa, NgayBatDau, NgayKetThuc, SoLuotDung, TrangThai) VALUES ('KM04', N'Mừng Sinh Nhật', 40, 1000000, 400000, SYSDATE - 5, SYSDATE + 25, 45, N'Đang áp dụng');
INSERT INTO KHUYENMAI (MaKM, TenKM, PhanTramGiam, GiaTriToiThieu, GiamToiDa, NgayBatDau, NgayKetThuc, SoLuotDung, TrangThai) VALUES ('KM05', N'Xả Hàng Tồn Kho', 50, 0, 200000, SYSDATE - 2, SYSDATE + 10, 80, N'Đang áp dụng');
INSERT INTO KHUYENMAI (MaKM, TenKM, PhanTramGiam, GiaTriToiThieu, GiamToiDa, NgayBatDau, NgayKetThuc, SoLuotDung, TrangThai) VALUES ('KM06', N'Tri Ân Hội Viên', 15, 200000, 100000, SYSDATE - 60, SYSDATE + 300, 150, N'Đang áp dụng');
INSERT INTO KHUYENMAI (MaKM, TenKM, PhanTramGiam, GiaTriToiThieu, GiamToiDa, NgayBatDau, NgayKetThuc, SoLuotDung, TrangThai) VALUES ('KM07', N'Black Friday Sale', 50, 1000000, 500000, SYSDATE - 180, SYSDATE - 175, 300, N'Hết hạn');
INSERT INTO KHUYENMAI (MaKM, TenKM, PhanTramGiam, GiaTriToiThieu, GiamToiDa, NgayBatDau, NgayKetThuc, SoLuotDung, TrangThai) VALUES ('KM08', N'Vui Giáng Sinh', 20, 500000, 150000, SYSDATE - 150, SYSDATE - 140, 120, N'Hết hạn');
INSERT INTO KHUYENMAI (MaKM, TenKM, PhanTramGiam, GiaTriToiThieu, GiamToiDa, NgayBatDau, NgayKetThuc, SoLuotDung, TrangThai) VALUES ('KM09', N'Đón Tết Nguyên Đán', 30, 800000, 300000, SYSDATE - 100, SYSDATE - 80, 250, N'Hết hạn');
INSERT INTO KHUYENMAI (MaKM, TenKM, PhanTramGiam, GiaTriToiThieu, GiamToiDa, NgayBatDau, NgayKetThuc, SoLuotDung, TrangThai) VALUES ('KM10', N'Sale Giữa Năm', 20, 600000, 150000, SYSDATE + 30, SYSDATE + 45, 0, N'Tạm ngưng');

-- =======================================================
-- 5. PHIẾU NHẬP KHO (MÃ TỪ PN01 - PN06, KẾT NỐI NV05-NV08)
-- =======================================================
INSERT INTO PHIEUNHAP (MaPN, MaNV, MaNCC, TongTien, GhiChu) VALUES ('PN01', 'NV05', 'NCC01', 23370000, N'Nhập đủ lô Váy');
INSERT INTO PHIEUNHAP (MaPN, MaNV, MaNCC, TongTien, GhiChu) VALUES ('PN02', 'NV06', 'NCC03', 40550000, N'Nhập lô Áo');
INSERT INTO PHIEUNHAP (MaPN, MaNV, MaNCC, TongTien, GhiChu) VALUES ('PN03', 'NV07', 'NCC12', 17925000, N'Nhập các loại mũ nón');
INSERT INTO PHIEUNHAP (MaPN, MaNV, MaNCC, TongTien, GhiChu) VALUES ('PN04', 'NV08', 'NCC06', 39450000, N'Nhập quần các loại');
INSERT INTO PHIEUNHAP (MaPN, MaNV, MaNCC, TongTien, GhiChu) VALUES ('PN05', 'NV05', 'NCC11', 29550000, N'Nhập túi xách');
INSERT INTO PHIEUNHAP (MaPN, MaNV, MaNCC, TongTien, GhiChu) VALUES ('PN06', 'NV06', 'NCC08', 29990000, N'Nhập giày tây, sneaker');

-- Chi tiết Phiếu nhập
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN01', 'SP001', 20, 120000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN01', 'SP002', 15, 180000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN01', 'SP003', 12, 220000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN01', 'SP004', 25, 150000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN01', 'SP005', 18, 1600000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN01', 'SP006', 20, 450000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN02', 'SP007', 40, 80000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN02', 'SP008', 15, 350000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN02', 'SP009', 10, 650000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN02', 'SP010', 25, 200000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN02', 'SP011', 60, 110000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN02', 'SP012', 50, 280000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN03', 'SP013', 25, 90000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN03', 'SP014', 15, 110000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN03', 'SP015', 30, 125000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN03', 'SP016', 20, 80000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN03', 'SP017', 50, 100000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN03', 'SP018', 35, 105000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN04', 'SP019', 40, 2200000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN04', 'SP020', 50, 140000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN04', 'SP021', 60, 90000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN04', 'SP022', 25, 170000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN04', 'SP023', 20, 160000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN04', 'SP024', 30, 360000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN05', 'SP025', 20, 220000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN05', 'SP026', 100, 60000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN05', 'SP027', 15, 160000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN05', 'SP028', 25, 290000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN05', 'SP029', 30, 175000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN05', 'SP030', 10, 425000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN06', 'SP031', 15, 470000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN06', 'SP032', 20, 220000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN06', 'SP033', 25, 150000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN06', 'SP034', 30, 125000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN06', 'SP035', 10, 600000);
INSERT INTO CHITIET_PHIEUNHAP (MaPN, MaSP, SoLuong, DonGiaNhap) VALUES ('PN06', 'SP036', 12, 420000);

-- =======================================================
-- 6. ĐƠN HÀNG (MÃ TỪ DH01 - DH10, KẾT NỐI KH01-KH06, NV09-NV12)
-- =======================================================
INSERT INTO DIACHI (MaDC, MaKH, TenNguoiNhan, SDTNguoiNhan, TinhThanh, PhuongXa, DiaChiChiTiet) VALUES ('DC01', 'KH03', N'Trịnh Tú Quyên', '0944000001', N'TP. Hồ Chí Minh', N'Linh Trung', N'Số 12 Đường số 5');
INSERT INTO DIACHI (MaDC, MaKH, TenNguoiNhan, SDTNguoiNhan, TinhThanh, PhuongXa, DiaChiChiTiet) VALUES ('DC02', 'KH04', N'Cao Thanh Tâm', '0944000002', N'TP. Hồ Chí Minh', N'Tăng Nhơn Phú A', N'24/5 Lê Văn Việt');
INSERT INTO DIACHI (MaDC, MaKH, TenNguoiNhan, SDTNguoiNhan, TinhThanh, PhuongXa, DiaChiChiTiet) VALUES ('DC03', 'KH05', N'Đào Tố Uyên', '0944000003', N'Bình Dương', N'Đông Hòa', N'Khu phố Tân Hòa');
INSERT INTO DIACHI (MaDC, MaKH, TenNguoiNhan, SDTNguoiNhan, TinhThanh, PhuongXa, DiaChiChiTiet) VALUES ('DC04', 'KH06', N'Châu Tường Vy', '0944000004', N'TP. Hồ Chí Minh', N'Bến Nghé', N'100 Đồng Khởi');
INSERT INTO DIACHI (MaDC, MaKH, TenNguoiNhan, SDTNguoiNhan, TinhThanh, PhuongXa, DiaChiChiTiet) VALUES ('DC05', 'KH02', N'Nguyễn Thị Thu', '0987654321', N'TP. Hồ Chí Minh', N'Phường 14', N'453 Cách Mạng Tháng 8');

-- Đơn Offline
INSERT INTO DONHANG (MaDH, MaKH, MaNV, MaDC, MaKM, LoaiDon, TrangThai, TongTien, PhiShip, HinhThucThanhToan, DiemThuong) VALUES ('DH01', 'KH02', 'NV09', NULL, 'KM01', 'OFFLINE', N'Đã hoàn thành', 700000, 0, N'Tiền mặt', 70);
INSERT INTO CHITIET_DONHANG (MaDH, MaSP, SoLuong, DonGia) VALUES ('DH01', 'SP001', 1 ,250000);
INSERT INTO CHITIET_DONHANG (MaDH, MaSP, SoLuong, DonGia) VALUES ('DH01', 'SP019', 1 ,450000);

INSERT INTO DONHANG (MaDH, MaKH, MaNV, MaDC, MaKM, LoaiDon, TrangThai, TongTien, PhiShip, HinhThucThanhToan, DiemThuong) VALUES ('DH02', 'KH01', 'NV10', NULL, NULL, 'OFFLINE', N'Đã hoàn thành', 350000, 0, N'Chuyển khoản Momo', 0);
INSERT INTO CHITIET_DONHANG (MaDH, MaSP, SoLuong, DonGia) VALUES ('DH02', 'SP002', 1 ,350000);

INSERT INTO DONHANG (MaDH, MaKH, MaNV, MaDC, MaKM, LoaiDon, TrangThai, TongTien, PhiShip, HinhThucThanhToan, DiemThuong) VALUES ('DH03', 'KH03', 'NV11', NULL, NULL, 'OFFLINE', N'Đã hoàn thành', 560000, 0, N'Tiền mặt', 56);
INSERT INTO CHITIET_DONHANG (MaDH, MaSP, SoLuong, DonGia) VALUES ('DH03', 'SP011', 2 ,440000);
INSERT INTO CHITIET_DONHANG (MaDH, MaSP, SoLuong, DonGia) VALUES ('DH03', 'SP026', 1, 120000);

INSERT INTO DONHANG (MaDH, MaKH, MaNV, MaDC, MaKM, LoaiDon, TrangThai, TongTien, PhiShip, HinhThucThanhToan, DiemThuong) VALUES ('DH04', 'KH01', 'NV12', NULL, NULL, 'OFFLINE', N'Đã hoàn thành', 300000, 0, N'Thẻ ngân hàng', 0);
INSERT INTO CHITIET_DONHANG (MaDH, MaSP, SoLuong, DonGia) VALUES ('DH04', 'SP007', 2, 300000);

INSERT INTO DONHANG (MaDH, MaKH, MaNV, MaDC, MaKM, LoaiDon, TrangThai, TongTien, PhiShip, HinhThucThanhToan, DiemThuong) VALUES ('DH05', 'KH04', 'NV09', NULL, NULL, 'OFFLINE', N'Đã hoàn thành', 1200000, 0, N'Chuyển khoản VNPAY', 120);
INSERT INTO CHITIET_DONHANG (MaDH, MaSP, SoLuong, DonGia) VALUES ('DH05', 'SP035', 1, 1200000);

-- Đơn Online
INSERT INTO DONHANG (MaDH, MaKH, MaNV, MaDC, MaKM, LoaiDon, TrangThai, TongTien, PhiShip, HinhThucThanhToan, DiemThuong) VALUES ('DH06', 'KH03', 'NV10', 'DC01', NULL, 'ONLINE', N'Đang giao', 450000, 30000, N'Ví điện tử ZaloPay', 42);
INSERT INTO CHITIET_DONHANG (MaDH, MaSP, SoLuong, DonGia) VALUES ('DH06', 'SP003', 1,  420000);

INSERT INTO DONHANG (MaDH, MaKH, MaNV, MaDC, MaKM, LoaiDon, TrangThai, TongTien, PhiShip, HinhThucThanhToan, DiemThuong) VALUES ('DH07', 'KH04', 'NV11', 'DC02', NULL, 'ONLINE', N'Đã giao', 600000, 20000, N'COD (Tiền mặt)', 58);
INSERT INTO CHITIET_DONHANG (MaDH, MaSP, SoLuong, DonGia) VALUES ('DH07', 'SP004', 2, 580000);

INSERT INTO DONHANG (MaDH, MaKH, MaNV, MaDC, MaKM, LoaiDon, TrangThai, TongTien, PhiShip, HinhThucThanhToan, DiemThuong) VALUES ('DH08', 'KH05', 'NV12', 'DC03', NULL, 'ONLINE', N'Chờ xác nhận', 530000, 30000, N'Thẻ quốc tế Visa', 50);
INSERT INTO CHITIET_DONHANG (MaDH, MaSP, SoLuong, DonGia) VALUES ('DH08', 'SP013', 1,  180000);
INSERT INTO CHITIET_DONHANG (MaDH, MaSP, SoLuong, DonGia) VALUES ('DH08', 'SP027', 1,  320000);

INSERT INTO DONHANG (MaDH, MaKH, MaNV, MaDC, MaKM, LoaiDon, TrangThai, TongTien, PhiShip, HinhThucThanhToan, DiemThuong) VALUES ('DH09', 'KH06', 'NV09', 'DC04', NULL, 'ONLINE', N'Đã hủy', 380000, 30000, N'Ví điện tử MoMo', 0);
INSERT INTO CHITIET_DONHANG (MaDH, MaSP, SoLuong, DonGia) VALUES ('DH09', 'SP022', 1, 350000);

INSERT INTO DONHANG (MaDH, MaKH, MaNV, MaDC, MaKM, LoaiDon, TrangThai, TongTien, PhiShip, HinhThucThanhToan, DiemThuong) VALUES ('DH10', 'KH02', 'NV10', 'DC05', 'KM02', 'ONLINE', N'Đang giao', 850000, 0, N'Chuyển khoản ngân hàng', 85);
INSERT INTO CHITIET_DONHANG (MaDH, MaSP, SoLuong, DonGia) VALUES ('DH10', 'SP036', 1,  850000);


-- =======================================================
-- 7. ĐÁNH GIÁ (MÃ TỪ DG01 - DG36, KẾT NỐI KH02-KH06)
-- =======================================================
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG01', 'KH02', 'SP001', 5, N'Váy chất vải mềm, mặc mát, rất ưng ý!');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG02', 'KH03', 'SP002', 4, N'Form ôm tôn dáng, vải hơi mỏng nhưng mặc đi tiệc rất xinh.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG03', 'KH04', 'SP003', 5, N'Mặc đi làm lịch sự, chuẩn form công sở.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG04', 'KH05', 'SP004', 5, N'Lụa xịn mịn, sờ rất mát tay, màu đỏ rượu sang chảnh.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG05', 'KH06', 'SP005', 4, N'Màu hồng phấn dễ thương, giặt không bị phai màu.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG06', 'KH02', 'SP006', 5, N'Họa tiết hoa nhí xinh xẻo, mùa hè mặc đi biển cực hợp.');

INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG07', 'KH03', 'SP007', 5, N'Vải thấm hút mồ hôi tốt, mặc đi tập gym thoải mái.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG08', 'KH04', 'SP008', 4, N'Màu xanh bụi ngầu, form rộng rãi đúng chuẩn style streetwear.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG09', 'KH05', 'SP009', 5, N'Lên dáng áo vest rất đẹp, đường may chỉn chu không chỉ thừa.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG10', 'KH06', 'SP010', 5, N'Áo khoác mỏng nhẹ, bỏ vào cốp xe tiện lợi, cản gió cực tốt.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG11', 'KH02', 'SP011', 3, N'Chất cotton dày dặn nhưng giặt xong cần phải ủi lại.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG12', 'KH03', 'SP012', 5, N'Áo sơ mi lụa mặc rất mát, màu trắng tinh khôi dễ phối đồ.');

INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG13', 'KH04', 'SP013', 5, N'Mũ xinh, đội lên nhìn như tiểu thư, lên hình bao đẹp.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG14', 'KH05', 'SP014', 4, N'Form cá tính, màu rêu rất tây, chất kaki cứng cáp.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG15', 'KH06', 'SP015', 5, N'Cói đan chắc chắn, vành rộng che nắng tốt khi đi biển.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG16', 'KH02', 'SP016', 4, N'Đội vừa vặn, màu trắng basic dễ mix quần áo.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG17', 'KH03', 'SP017', 5, N'Đội ngầu, mũ cứng cáp không bị móp méo khi giao.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG18', 'KH04', 'SP018', 5, N'Mũ siêu nhẹ, thoát mồ hôi tốt, rất ưng ý để chạy bộ.');

INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG19', 'KH05', 'SP019', 4, N'Vải jean co giãn nhẹ, mặc đi làm cả ngày vẫn thoải mái.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG20', 'KH06', 'SP020', 5, N'Dáng thể thao năng động, túi hộp lớn tiện để điện thoại.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG21', 'KH02', 'SP021', 5, N'Quần kaki dáng lửng trẻ trung, đường may chắc chắn.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG22', 'KH03', 'SP022', 3, N'Ống đứng đẹp nhưng ống quần hơi dài so với mình, phải đi cắt gấu.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG23', 'KH04', 'SP023', 5, N'Dáng baggy che khuyết điểm chân to cực tốt, màu nâu tây tôn da.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG24', 'KH05', 'SP024', 5, N'Form quần tây chuẩn, là ủi dễ dàng, xếp ly đẹp.');

INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG25', 'KH06', 'SP025', 5, N'Ví thiết kế sang trọng, cầm vừa tay, chất da mềm mịn.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG26', 'KH02', 'SP026', 5, N'Túi tote đựng được cả laptop và sách vở, giá quá rẻ.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG27', 'KH03', 'SP027', 4, N'Màu hồng pastel xinh, dây xích chắc chắn, nhưng chất liệu dễ bám bẩn.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG28', 'KH04', 'SP028', 5, N'Da thật sờ rất thích, form túi đứng không bị xẹp, khóa kéo xịn.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG29', 'KH05', 'SP029', 5, N'Mình mua tặng bạn nam, bạn ấy rất thích, ngăn đựng thẻ tiện lợi.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG30', 'KH06', 'SP030', 4, N'Túi rộng rãi, form công sở thanh lịch, quai xách chắc tay.');

INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG31', 'KH02', 'SP031', 5, N'Giày da bóng loáng, đi êm chân không bị đau gót, chuẩn size.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG32', 'KH03', 'SP032', 4, N'Gót cao tôn dáng, chắc chắn, nhưng mũi nhọn đi cả ngày hơi mỏi.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG33', 'KH04', 'SP033', 5, N'Xinh xỉu, mang phối với váy babydoll cực kỳ hợp, đệm giày êm.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG34', 'KH05', 'SP034', 5, N'Quai mảnh lên chân nhìn thon gọn, khóa cài mượt mà.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG35', 'KH06', 'SP035', 5, N'Đế cao su xịn, phối đồ streetwear cực chất, ôm chân.');
INSERT INTO DANHGIA (MaDG, MaKH, MaSP, SoSao, NoiDung) VALUES ('DG36', 'KH02', 'SP036', 5, N'Trọng lượng siêu nhẹ, đế nhún tốt, chạy bộ rất thoải mái.');

COMMIT;