CREATE TABLE dbo.NhomThuoc (
  MaNhom bigint IDENTITY (1, 1) NOT NULL PRIMARY KEY, 
  TenNhom nvarchar(max) NOT NULL, 
  );
CREATE TABLE dbo.NhaSanXuat (
  MaNSX bigint IDENTITY (1, 1) NOT NULL PRIMARY KEY, 
  TenNSX nvarchar(max), 
  DiaChi nvarchar(max), 
  DienThoai nvarchar(max), 
  Email nvarchar(max), 
  SoLoSX varchar(255), 
  GhiChu nvarchar(max) DEFAULT NULL
);
CREATE TABLE dbo.BenhNhan (
  MaBN nvarchar(255) PRIMARY KEY NOT NULL, 
  Ten nvarchar(max) NOT NULL, 
  Tuoi int NOT NULL, 
  DiaChi nvarchar(max) DEFAULT NULL, 
  GioiTinh nvarchar(max) NOT NULL, 
  NgheNghiep nvarchar(max) DEFAULT NULL, 
  CCCD varchar(13) DEFAULT NULL, 
  SDT varchar(11) DEFAULT NULL, 
  DiaChiKhiCanLienHe nvarchar(max) DEFAULT NULL, 
  SDTNguoiNha varchar(11) DEFAULT NULL, 
  );
CREATE TABLE PhongBan (
  MaPB bigint IDENTITY (1, 1) NOT NULL PRIMARY KEY, 
  TenPB nvarchar(max) NOT NULL, 
  );
CREATE TABLE dbo.Thuoc (
  MaThuoc nvarchar(255) NOT NULL PRIMARY KEY, 
  TenThuoc nvarchar(max) NOT NULL, 
  MaNhom BigInt NOT NULL, 
  NguonGoc nvarchar(max) NOT NULL, 
  MaNSX bigint NOT NULL, 
  SoLuong nvarchar(max) NOT NULL, 
  GiaBan int NOT NULL, 
  TenDVT nvarchar(max) DEFAULT NULL, 
  ThanhPhan nvarchar(max), 
  CongDung nvarchar(max), 
  ChuY nvarchar(max), 
  HSD nvarchar(max) DEFAULT NULL, 
  BaoQuan nvarchar(max) DEFAULT NULL, 
  DangBaoChe nvarchar(max) DEFAULT NULL, 
  CachDung nvarchar(max) DEFAULT NULL, 
  Kho int NOT NULL, 
  --Relationship
  CONSTRAINT FK_Thuoc_NhomThuoc FOREIGN KEY(MaNhom) REFERENCES NhomThuoc(MaNhom), 
  CONSTRAINT FK_Thuoc_NSX FOREIGN KEY(MaNSX) REFERENCES NhaSanXuat(MaNSX), 
  );
CREATE TABLE NhanVien (
  MaNV NVARCHAR(255) PRIMARY KEY NOT NULL, 
  TenNV NVARCHAR(255) NOT NULL, 
  NgaySinh DATE NOT NULL, 
  GioiTinh int NOT NULL, -- Nam:0, Nu:1
  DienThoai VARCHAR(15) DEFAULT NULL, 
  DiaChi NVARCHAR(255) DEFAULT NULL, 
  Email VARCHAR(255) DEFAULT NULL, 
  Luong int NOT NULL, 
  NgayVaoLam date NOT NULL, 
  MaPB BigInt NOT NULL, 
  --Relationship
  CONSTRAINT FK_NhanVien_PhongBan FOREIGN KEY (MaPB) REFERENCES PhongBan(MaPB), 
  );
CREATE TABLE dbo.HoaDonNhap (
  MaHDN varchar(255) NOT NULL PRIMARY KEY, 
  NguoiGiao nvarchar(max) NOT NULL, 
  MaNguoiNhan NVARCHAR(255) NOT NULL, 
  MaThuoc nvarchar(255) NOT NULL, 
  SoLuongNhap int NOT NULL, 
  Thue decimal(10, 2) NOT NULL, 
  GiaThuoc decimal(10, 2) NOT NULL,
  TongTienThuoc AS (
    dbo.calc_price(GiaThuoc, SoLuongNhap)
  ), 
  TongThue AS (
    dbo.calc_tax(GiaThuoc, SoLuongNhap, Thue)
  ), 
  TongTienHD AS (
    dbo.calc_total(GiaThuoc, SoLuongNhap, Thue)
  ), 
  NgayViet datetime NOT NULL, 
  NgayNhap datetime NOT NULL,
  --Relationship
  CONSTRAINT FK_HoaDonNhap_Thuoc FOREIGN KEY(MaThuoc) REFERENCES Thuoc(MaThuoc), 
  CONSTRAINT FK_HoaDonNhap_NhanVien FOREIGN KEY(MaNguoiNhan) REFERENCES NhanVien(MaNV), 
  );
CREATE TABLE dbo.HoaDonXuat (
  MaHDX varchar(255) PRIMARY KEY NOT NULL, 
  MaThuoc nvarchar(255) NOT NULL, 
  MaBN nvarchar(255) NOT NULL, 
  GiaBan int NOT NULL,
  MaNguoiBan NVARCHAR(255) NOT NULL, 
  SoLuongXuat int NOT NULL, 
  Thue decimal(10, 2) NOT NULL,  
  TongTienThuoc AS (
    dbo.calc_price(GiaBan, SoLuongXuat)
  ), 
  TongThue AS (
    dbo.calc_tax(GiaBan, SoLuongXuat, Thue)
  ), 
  TongTienHD AS (
    dbo.calc_total(GiaBan, SoLuongXuat, Thue)
  ), 
  GhiChu nvarchar(max) DEFAULT NULL, 
  NgayLap datetime NOT NULL, 
  --Relationship
  CONSTRAINT FK_HoaDonXuat_BenhNhan FOREIGN KEY(MaBN) REFERENCES BenhNhan(MaBN),
  CONSTRAINT FK_HoaDonXuat_NhanVien FOREIGN KEY(MaNguoiBan) REFERENCES NhanVien(MaNV)
);
