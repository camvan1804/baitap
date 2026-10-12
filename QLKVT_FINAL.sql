CREATE DATABASE QL_khovattu
GO

USE QL_khovattu
GO

-- ============================================================================
-- PHẦN 1: TẠO CÁC BẢNG (10 BẢNG)
-- ============================================================================

-- 1. NHÂN VIÊN
CREATE TABLE NhanVien
(
    MaNhanVien VARCHAR(20) PRIMARY KEY,
    TenNhanVien NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(20),
    DiaChi NVARCHAR(200),
    GhiChu NVARCHAR(200),
    Email VARCHAR(100),
    NgaySinh DATE
)
GO

-- 2. TÀI KHOẢN NGƯỜI DÙNG (Đã bỏ phân quyền)
CREATE TABLE TaiKhoan
(
    TenDangNhap VARCHAR(50) PRIMARY KEY,
    MatKhau VARCHAR(255) NOT NULL,
    MaNhanVien VARCHAR(20) UNIQUE,
    TrangThai BIT NOT NULL DEFAULT 1,

    FOREIGN KEY (MaNhanVien) 
        REFERENCES NhanVien(MaNhanVien) 
        ON DELETE CASCADE
)
GO

-- 3. KHÁCH HÀNG
CREATE TABLE KhachHang
(
    MaKhachHang VARCHAR(20) PRIMARY KEY,
    TenKhachHang NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(20),
    DiaChi NVARCHAR(200),
    GhiChu NVARCHAR(200)
)
GO

-- 4. NHÀ CUNG CẤP
CREATE TABLE NhaCungCap
(
    MaNhaCungCap VARCHAR(20) PRIMARY KEY,
    TenNhaCungCap NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(20),
    DiaChi NVARCHAR(200),
    GhiChu NVARCHAR(200)
)
GO

-- 5. HÀNG HÓA / VẬT TƯ
CREATE TABLE HangHoa
(
    MaHangHoa VARCHAR(20) PRIMARY KEY,
    TenHangHoa NVARCHAR(100) NOT NULL,
    MaNhaCungCap VARCHAR(20),
    SoLuong INT DEFAULT 0,
    DonViTinh NVARCHAR(30),
    GhiChu NVARCHAR(200),
    HinhAnh NVARCHAR(255),

    FOREIGN KEY (MaNhaCungCap)
        REFERENCES NhaCungCap(MaNhaCungCap)
)
GO

-- 6. PHIẾU NHẬP
CREATE TABLE PhieuNhap
(
    MaPhieuNhap VARCHAR(20) PRIMARY KEY,
    NgayNhap DATE NOT NULL,
    MaNhaCungCap VARCHAR(20),
    MaNhanVien VARCHAR(20),
    GhiChu NVARCHAR(200),

    FOREIGN KEY (MaNhaCungCap)
        REFERENCES NhaCungCap(MaNhaCungCap),

    FOREIGN KEY (MaNhanVien)
        REFERENCES NhanVien(MaNhanVien)
)
GO

-- 7. CHI TIẾT PHIẾU NHẬP
CREATE TABLE ChiTietPhieuNhap
(
    MaPhieuNhap VARCHAR(20),
    MaHangHoa VARCHAR(20),
    SoLuong INT NOT NULL,
    DonGia FLOAT NOT NULL,

    PRIMARY KEY (MaPhieuNhap, MaHangHoa),

    FOREIGN KEY (MaPhieuNhap)
        REFERENCES PhieuNhap(MaPhieuNhap),

    FOREIGN KEY (MaHangHoa)
        REFERENCES HangHoa(MaHangHoa)
)
GO

-- 8. PHIẾU XUẤT
CREATE TABLE PhieuXuat
(
    MaPhieuXuat VARCHAR(20) PRIMARY KEY,
    NgayXuat DATE NOT NULL,
    MaKhachHang VARCHAR(20),
    MaNhanVien VARCHAR(20),
    GhiChu NVARCHAR(200),

    FOREIGN KEY (MaKhachHang)
        REFERENCES KhachHang(MaKhachHang),

    FOREIGN KEY (MaNhanVien)
        REFERENCES NhanVien(MaNhanVien)
)
GO

-- 9. CHI TIẾT PHIẾU XUẤT
CREATE TABLE ChiTietPhieuXuat
(
    MaPhieuXuat VARCHAR(20),
    MaHangHoa VARCHAR(20),
    SoLuong INT NOT NULL,
    DonGia FLOAT NOT NULL,

    PRIMARY KEY (MaPhieuXuat, MaHangHoa),

    FOREIGN KEY (MaPhieuXuat)
        REFERENCES PhieuXuat(MaPhieuXuat),

    FOREIGN KEY (MaHangHoa)
        REFERENCES HangHoa(MaHangHoa)
)
GO

-- 10. QUẢN LÝ KIỂM KÊ
CREATE TABLE KiemKe
(
    MaPhieu VARCHAR(20) PRIMARY KEY,
    NgayKiemKe DATE NOT NULL,
    MaHangHoa VARCHAR(20) NOT NULL,
    MaNhanVien VARCHAR(20),
    SoLuongTon INT NOT NULL,
    SoLuongThucTe INT NOT NULL,
    ChenhLech AS (SoLuongThucTe - SoLuongTon),
    GhiChu NVARCHAR(200),

    FOREIGN KEY (MaHangHoa)
        REFERENCES HangHoa(MaHangHoa),

    FOREIGN KEY (MaNhanVien)
        REFERENCES NhanVien(MaNhanVien)
)
GO

-- ============================================================================
-- PHẦN 2: THÊM DỮ LIỆU MẪU (INSERT DATA)
-- ============================================================================

-- 1. Thêm Nhân Viên
INSERT INTO NhanVien (MaNhanVien, TenNhanVien, SoDienThoai, DiaChi, GhiChu, Email, NgaySinh)
VALUES 
('NV01', N'Nguyễn Văn An', '0912345678', N'Hà Nội', N'Quản lý', 'an.nv@kho.vn', '1990-05-15'),
('NV02', N'Trần Thị Mai', '0987654321', N'Hà Nội', N'Nhân viên kho', 'mai.tt@kho.vn', '1995-08-20'),
('NV03', N'Lê Văn Nam', '0909123456', N'Hà Nội', N'Nhân viên kho', 'nam.lv@kho.vn', '1998-12-10'),
('NV101', N'Đỗ Minh Quân', '0918223344', N'Hà Nội', N'Thủ kho ca ngày', 'quan.dm@kho.vn', '1992-03-25'),
('NV102', N'Nguyễn Thị Ngọc', '0975112233', N'Hà Nội', N'Nhân viên kiểm định vật tư', 'ngoc.nt@kho.vn', '1996-07-19'),
('NV103', N'Bùi Thanh Tú', '0909887766', N'Hà Nội', N'Phụ trách xuất kho', 'tu.bt@kho.vn', '1994-11-02'),
('NV104', N'Hoàng Văn Nam', '0932445566', N'Hà Nội', N'Nhân viên kho', 'nam.hv@kho.vn', '1999-01-30')
GO

-- 2. Thêm Tài Khoản
INSERT INTO TaiKhoan (TenDangNhap, MatKhau, MaNhanVien, TrangThai)
VALUES 
('admin', '123456', 'NV01', 1),
('thukho1', '123456', 'NV02', 1),
('nhanvien1', '123456', 'NV03', 1)
GO

-- 3. Thêm Nhà Cung Cấp
INSERT INTO NhaCungCap (MaNhaCungCap, TenNhaCungCap, SoDienThoai, DiaChi, GhiChu)
VALUES
('NCC01', N'Công ty Thăng Long', '0123456', N'Hà Nội', N'Hàng chất lượng'),
('NCC02', N'Công ty Phan Thị', '045252523', N'Hà Nội', N'Hàng qua tay'),
('NCC03', N'Công ty Đại Duy', '0787878', N'Số 36 Phan X, Hà Nội', N'')
GO

-- 4. Thêm Khách Hàng
INSERT INTO KhachHang (MaKhachHang, TenKhachHang, SoDienThoai, DiaChi, GhiChu)
VALUES
('KH01', N'Nguyễn Tất Thành', '03141414', N'Hà Nội', N'VIP'),
('KH02', N'Đinh Công Quyền', '03142443', N'Hà Nội', N'VIP'),
('KH03', N'Cao Đức Chính', '0323231', N'Hà Nội', N'Khách mới'),
('KH04', N'Cao Mỹ Vy', '0898988', N'Hồ Chí Minh', N''),
('KH05', N'Đào Xuân', '0365668063', N'Đông Anh - Hà Nội', N'')
GO

-- 5. Thêm Hàng Hóa / Vật Tư
INSERT INTO HangHoa (MaHangHoa, TenHangHoa, MaNhaCungCap, SoLuong, DonViTinh, GhiChu, HinhAnh)
VALUES
('HH01', N'Đồng 2', 'NCC03', 1000, N'kg', N'Hàng chuyển giao', NULL),
('HH02', N'Đồng 1', 'NCC02', 1000, N'tấn', N'Hàng chuyển giao', NULL),
('HH03', N'Kim cương', 'NCC03', 2, N'kg', N'Hàng', NULL),
('HH04', N'Đồng', 'NCC03', 150, N'kg', N'Không', NULL),
('HH05', N'Sắt 6', 'NCC01', 1000, N'tạ', N'Bán gấp', NULL),
('HH07', N'Sắt', 'NCC02', 100, N'tạ', N'Không', NULL)
GO

-- 6. Thêm Phiếu Nhập
INSERT INTO PhieuNhap (MaPhieuNhap, NgayNhap, MaNhaCungCap, MaNhanVien, GhiChu) 
VALUES 
('PN01', '2026-10-01', 'NCC01', 'NV01', N'Nhập đợt 1 tháng 10'),
('PN02', '2026-10-05', 'NCC02', 'NV02', N'Nhập bổ sung vật tư kho'),
('PN03', '2026-10-10', 'NCC03', 'NV03', N'Nhập hàng nguyên liệu gấp')
GO

-- 7. Thêm Chi Tiết Phiếu Nhập
INSERT INTO ChiTietPhieuNhap (MaPhieuNhap, MaHangHoa, SoLuong, DonGia) 
VALUES 
('PN01', 'HH05', 150, 45000),
('PN01', 'HH07', 50, 30000),
('PN02', 'HH02', 100, 120000),
('PN02', 'HH04', 30, 15000),
('PN03', 'HH01', 200, 85000),
('PN03', 'HH03', 2, 5000000)
GO

-- 8. Thêm Phiếu Xuất
INSERT INTO PhieuXuat (MaPhieuXuat, NgayXuat, MaKhachHang, MaNhanVien, GhiChu)
VALUES
('PX01', '2026-08-09', 'KH01', 'NV02', N'Xuất bán hàng cho khách VIP'),
('PX02', '2026-10-10', 'KH02', 'NV03', N'Xuất vật tư công trình'),
('PX03', '2026-10-10', 'KH04', 'NV01', N'Xuất đơn hàng Hồ Chí Minh')
GO

-- 9. Thêm Chi Tiết Phiếu Xuất
INSERT INTO ChiTietPhieuXuat (MaPhieuXuat, MaHangHoa, SoLuong, DonGia)
VALUES
('PX01', 'HH01', 10, 150000),
('PX02', 'HH02', 100, 110000),
('PX03', 'HH04', 30, 95000)
GO

-- 10. Thêm Kiểm Kê
INSERT INTO KiemKe (MaPhieu, NgayKiemKe, MaHangHoa, MaNhanVien, SoLuongTon, SoLuongThucTe, GhiChu)
VALUES
('KK001', '2026-10-11', 'HH01', 'NV01', 1000, 995, N'Thiếu 5 kg đồng 2'),
('KK002', '2026-10-11', 'HH02', 'NV02', 1000, 1000, N'Đủ số lượng đồng 1'),
('KK003', '2026-10-12', 'HH03', 'NV03', 2, 1, N'Thiếu 1 kg kim cương'),
('KK004', '2026-10-12', 'HH04', 'NV01', 150, 155, N'Thừa 5 kg đồng'),
('KK005', '2026-10-12', 'HH05', 'NV02', 1000, 980, N'Thiếu 20 tạ sắt 6')
GO

-- ============================================================================
-- PHẦN 3: STORED PROCEDURE TIM KIẾM PHIẾU XUẤT
-- ============================================================================

CREATE PROCEDURE sp_timmaphieu
    @maphieuxuat VARCHAR(20),
    @tenhanghoa NVARCHAR(100)
AS
BEGIN
    SELECT 
        px.MaPhieuXuat AS [Mã phiếu],
        px.NgayXuat AS [Ngày xuất],
        ct.MaHangHoa AS [Mã vật tư],
        hh.TenHangHoa AS [Tên vật tư],
        ct.SoLuong AS [Số lượng],
        ct.DonGia AS [Đơn giá],
        px.MaKhachHang AS [Mã khách hàng],
        px.MaNhanVien AS [Mã nhân viên],
        px.GhiChu AS [Ghi chú]
    FROM PhieuXuat px
    LEFT JOIN ChiTietPhieuXuat ct ON px.MaPhieuXuat = ct.MaPhieuXuat
    LEFT JOIN HangHoa hh ON ct.MaHangHoa = hh.MaHangHoa
    WHERE (@maphieuxuat IS NULL OR @maphieuxuat = '' OR px.MaPhieuXuat LIKE '%' + @maphieuxuat + '%')
      AND (@tenhanghoa IS NULL OR @tenhanghoa = '' OR hh.TenHangHoa LIKE N'%' + @tenhanghoa + '%')
END
GO

-- ============================================================================
-- PHẦN 4: TRUY VẤN KIỂM TRA DỮ LIỆU
-- ============================================================================

SELECT * FROM NhanVien
SELECT * FROM TaiKhoan
SELECT * FROM KhachHang
SELECT * FROM NhaCungCap
SELECT * FROM HangHoa
SELECT * FROM PhieuNhap
SELECT * FROM ChiTietPhieuNhap
SELECT * FROM PhieuXuat
SELECT * FROM ChiTietPhieuXuat
SELECT * FROM KiemKe

-- Xem chi tiết phiếu nhập kèm tên hàng hóa
SELECT pn.MaPhieuNhap, pn.NgayNhap, ct.MaHangHoa, h.TenHangHoa, ct.SoLuong, ct.DonGia
FROM PhieuNhap pn 
JOIN ChiTietPhieuNhap ct ON pn.MaPhieuNhap = ct.MaPhieuNhap 
JOIN HangHoa h ON ct.MaHangHoa = h.MaHangHoa

-- Xem danh sách kiểm kê kèm tên hàng hóa và tên nhân viên
SELECT
    k.MaPhieu,
    k.NgayKiemKe,
    h.TenHangHoa,
    nv.TenNhanVien,
    k.SoLuongTon,
    k.SoLuongThucTe,
    k.ChenhLech,
    k.GhiChu
FROM KiemKe k
JOIN HangHoa h ON k.MaHangHoa = h.MaHangHoa
JOIN NhanVien nv ON k.MaNhanVien = nv.MaNhanVien
ORDER BY k.MaPhieu
GO