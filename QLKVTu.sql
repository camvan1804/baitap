CREATE DATABASE quanly_khovattu
GO
USE quanly_khovattu
GO

-- =============================================
-- PHẦN 1: TẠO CÁC BẢNG (Sắp xếp theo thứ tự ưu tiên khóa ngoại)
-- =============================================

-- 1. NHÂN VIÊN (Tạo trước để Tài Khoản có thể tham chiếu)
CREATE TABLE NhanVien(
    MaNhanVien VARCHAR(20) PRIMARY KEY,
    TenNhanVien NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(20),
    DiaChi NVARCHAR(200),
    GhiChu NVARCHAR(200)
)
GO

-- 2. TÀI KHOẢN NGƯỜI DÙNG (Đã được đưa lên đầu)
CREATE TABLE TaiKhoan (
    TenDangNhap VARCHAR(50) PRIMARY KEY, 
    MatKhau VARCHAR(255) NOT NULL,       
    Quyen NVARCHAR(50) NOT NULL,         
    MaNhanVien VARCHAR(20) UNIQUE,       
    TrangThai BIT DEFAULT 1,             
    
    FOREIGN KEY (MaNhanVien) 
    REFERENCES NhanVien(MaNhanVien) 
    ON DELETE CASCADE                    
)
GO

-- 3. KHÁCH HÀNG
CREATE TABLE KhachHang(
    MaKhachHang VARCHAR(20) PRIMARY KEY,
    TenKhachHang NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(20),
    DiaChi NVARCHAR(200),
    GhiChu NVARCHAR(200)
)
GO

-- 4. NHÀ CUNG CẤP
CREATE TABLE NhaCungCap(
    MaNhaCungCap VARCHAR(20) PRIMARY KEY,
    TenNhaCungCap NVARCHAR(100) NOT NULL,
    SoDienThoai VARCHAR(20),
    DiaChi NVARCHAR(200),
    GhiChu NVARCHAR(200)
)
GO

-- 5. HÀNG HÓA / VẬT TƯ
CREATE TABLE HangHoa(
    MaHangHoa VARCHAR(20) PRIMARY KEY,
    TenHangHoa NVARCHAR(100) NOT NULL,
    MaNhaCungCap VARCHAR(20),
    SoLuong INT DEFAULT 0,
    DonViTinh NVARCHAR(30),
    GhiChu NVARCHAR(200),

    FOREIGN KEY (MaNhaCungCap)
    REFERENCES NhaCungCap(MaNhaCungCap)
)
GO

-- 6. PHIẾU NHẬP
CREATE TABLE PhieuNhap(
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
CREATE TABLE ChiTietPhieuNhap(
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
CREATE TABLE PhieuXuat(
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
CREATE TABLE ChiTietPhieuXuat(
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

-- =============================================
-- PHẦN 2: THÊM DỮ LIỆU MẪU (INSERT DATA)
-- =============================================

-- 1. Insert Nhân viên trước
INSERT INTO NhanVien VALUES
('NV01', N'Nguyễn Văn An', '0912345678', N'Hà Nội', N'Quản lý'),
('NV02', N'Trần Thị Mai', '0987654321', N'Hà Nội', N'Nhân viên kho'),
('NV03', N'Lê Văn Nam', '0909123456', N'Hà Nội', N'Nhân viên')
GO

-- 2. Insert Tài khoản (Dựa trên NV01, NV02, NV03)
INSERT INTO TaiKhoan (TenDangNhap, MatKhau, Quyen, MaNhanVien, TrangThai) VALUES 
('admin', '123456', N'Quản lý', 'NV01', 1),
('thukho1', '123456', N'Thủ kho', 'NV02', 1),
('nhanvien1', '123456', N'Nhân viên', 'NV03', 1)
GO

-- 3. Insert Nhà Cung Cấp
INSERT INTO NhaCungCap VALUES
('NCC01', N'Công ty Thăng Long', '0123456', N'Hà Nội', N'Hàng chất lượng'),
('NCC02', N'Công ty Phan Thị', '045252523', N'Hà Nội', N'Hàng qua tay'),
('NCC03', N'Công ty Đại Duy', '0787878', N'Số 36 Phan X, Hà Nội', N'')
GO

-- 4. Insert Khách Hàng
INSERT INTO KhachHang VALUES
('KH01', N'Nguyễn Tất Thành', '03141414', N'Hà Nội', N'VIP'),
('KH02', N'Đinh Công Quyền', '03142443', N'Hà Nội', N'VIP'),
('KH03', N'Cao Đức Chính', '0323231', N'Hà Nội', N'Khách mới'),
('KH04', N'Cao Mỹ Vy', '0898988', N'Hồ Chí Minh', N''),
('KH05', N'Đào Xuân', '0365668063', N'Đông Anh - Hà Nội', N'')
GO

-- 5. Insert Hàng Hóa
INSERT INTO HangHoa VALUES
('HH01', N'Đồng 2', 'NCC03', 1000, N'kg', N'Hàng chuyển giao'),
('HH02', N'Đồng 1', 'NCC02', 1000, N'tấn', N'Hàng chuyển giao'),
('HH03', N'Kim cương', 'NCC03', 2, N'kg', N'Hàng'),
('HH04', N'Đồng', 'NCC03', 150, N'kg', N'Không'),
('HH05', N'Sắt 6', 'NCC01', 1000, N'tạ', N'Bán gấp'),
('HH07', N'Sắt', 'NCC02', 100, N'tạ', N'Không')
GO

-- =============================================
-- KIỂM TRA DỮ LIỆU
-- =============================================
SELECT * FROM NhanVien
SELECT * FROM TaiKhoan
SELECT * FROM HangHoa
SELECT * FROM NhaCungCap
SELECT * FROM KhachHang
GO
UPDATE TaiKhoan 
SET Quyen = N'Nhân viên' 
WHERE Quyen = N'Thủ kho'