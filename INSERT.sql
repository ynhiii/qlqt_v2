-- Reset Table
IF OBJECT_ID('HoaDonNhap','U') IS NOT NULL
BEGIN
	ALTER TABLE HoaDonNhap DROP CONSTRAINT FK_HoaDonNhap_Thuoc;
	ALTER TABLE HoaDonNhap DROP CONSTRAINT FK_HoaDonNhap_NhanVien;
	DROP TABLE HoaDonNhap;
END;

IF OBJECT_ID('HoaDonXuat','U') IS NOT NULL
BEGIN
	ALTER TABLE HoaDonXuat DROP CONSTRAINT FK_HoaDonXuat_BenhNhan;
	ALTER TABLE HoaDonXuat DROP CONSTRAINT FK_HoaDonXuat_NhanVien;
	DROP TABLE HoaDonXuat;
END;

IF OBJECT_ID('Thuoc','U') IS NOT NULL
BEGIN
	ALTER TABLE Thuoc DROP CONSTRAINT FK_Thuoc_NhomThuoc;
	ALTER TABLE Thuoc DROP CONSTRAINT FK_Thuoc_NSX;
	DROP TABLE Thuoc;
END;

IF OBJECT_ID('NhanVien','U') IS NOT NULL
BEGIN
	ALTER TABLE NhanVien DROP CONSTRAINT FK_NhanVien_PhongBan;
	DROP TABLE NhanVien;
END;

IF OBJECT_ID('NhomThuoc','U') IS NOT NULL
BEGIN
	DROP TABLE NhomThuoc;
END;

IF OBJECT_ID('NhaSanXuat','U') IS NOT NULL
BEGIN
	DROP TABLE NhaSanXuat;
END;

IF OBJECT_ID('BenhNhan','U') IS NOT NULL
BEGIN
	DROP TABLE BenhNhan;
END;

IF OBJECT_ID('PhongBan','U') IS NOT NULL
BEGIN
	DROP TABLE PhongBan;
END;

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
  Kho int DEFAULT (100), 
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

INSERT INTO NhomThuoc (TenNhom) VALUES 
	(N'Thuốc cơ xương khớp'),
	(N'Thuốc giảm đau – hạ sốt'),
	(N'Thuốc ho cảm'),
	(N'Thuốc bổ gan'),
	(N'Thuốc giảm đau'),
	(N'Thuốc dị ứng'),
	(N'Vitamin'),
	(N'Thuốc tim'),
	(N'Thuốc bổ thận');

INSERT INTO NhaSanXuat (TenNSX, DiaChi, DienThoai, Email, SoLoSX, GhiChu) VALUES 
	(N'Traphaco', N'75 Yên Ninh, Ba Đình, HN', '18006612', 'info@traphaco.com.vn', 'VD-19621-13', ''),
	(N'Sao Thái Dương', N'Lô CC1-III.13.4 thuộc dự án khu đô thị mới Pháp Vân, Tứ Hiệp, P. Hoàng Liệt, Q. Hoàng Mai, HN', '1800 1799', 'nobel@thaiduong.com.vn', '11759/2020/ĐKSP', ''),
	(N'DHG Pharma', N'288 Bis Nguyễn Văn Cừ, P. An Hòa, Q. Ninh Kiều, Cần Thơ', '3891433 ', 'dhgpharma@dhgpharma.com.vn', 'VD-20546-14', ''),
	(N'VPC Pharimexco', N'164 Đường số 4, P. 16, Q. Gò Vấp, HCM', '71002929 ', 'cskh@alphabetpharma.com.vn', 'VD-16011-11', ''),
	(N'F.T Pharma', N'601 Cách Mạng Tháng 8, P.15, Q.10, HCM', '02839770967 ', 'duocpham32@ft-pharma.com', 'VD-17371-12', ''),
	(N'Công ty cổ phần Dược phẩm Hà Tây', N'Số 10A , phố Quang Trung, P.Quang Trung, Q. Hà Đông, HN', '024 3352 2525 ', 'duochatay@gmail.com', 'VD-16911-12', ''),
	(N'Phil Inter Pharma', N'20, Đại lộ Hữu Nghị, KCN VSIP, Thuận An, Bình Dương', '3979.8474', 'duochatay@gmail.com', 'VD-22373-15', ''),
	(N'Chi nhánh công ty cổ phần Armephaco', N'số 118, Phố Vũ Xuân Thiều, P. Phúc Lợi, Q. Long Biên, HN', '02438759475 ', 'armephaco@armephaco.com.vn', 'VD-30026-18', ''),
	(N'Công ty TNHH Đông Dược Phúc Hưng', N'Số 96 - 98 Nguyễn Viết Xuân, Quang Trung, Hà Đông, HN', '1800 5454  ', 'cskh@dongduocphuchung.com.vn', 'VD-25447-16', ''),
	(N'namha pharma', N' 415 Hàn Thuyên, P.Vị Xuyên, TP. Nam Định, Tỉnh Nam Định', '18001155 ', 'info@namhapharma.com', 'VD-27955-17', ''),
	(N'Công Ty Daiichi Sankyo (Nhật Bản)', N'Tầng 6, Tòa Nhà Havana, Số 132 Đường Hàm Nghi, Phường Bến Thành, Quận 1, HCM', '0283914741', '', 'VN-15416-12', ''),
	(N'Janssen Pharmaceutica N.V. ', N'Beerse, Bỉ ', '0800 14 669 ', 'janssen@jacbe.jnj.com ', 'VN-19681-16 ', ''),
	('Gracure Pharmaceuticals Ltd   ', N'Delhi, Ấn Độ', '+91-11-47770900', 'info@gracure.com', 'VN-16775-13', ''),
	('Bidiphar ', N'498 Nguyễn Thái Học, Phường Quang Trung, Thành Phố Quy Nhơn, Bình Định ', '02563846500', 'info@bidiphar.com ', 'VD-19842-13 ', ''),
	(N'Công Ty Cổ Phần BV Pharma ', N'Số 18, Đường Lê Thị Sọc, Ấp 2A, Xã Tân Thạnh Tây, Củ Chi, HCM ', '02862911184 ', 'letan@bvpharma.com.vn ', 'VD-28772-18 ', '');

INSERT INTO BenhNhan (MaBN, Ten, Tuoi, DiaChi, GioiTinh, NgheNghiep, CCCD, SDT, DiaChiKhiCanLienHe, SDTNguoiNha) VALUES
	('BN-001', N'Bùi Lan Ngọc', 43, N'318 Trần Cung, Cổ Nhuế, BTL, HN', N'Nữ', N'Nv văn phòng', '012257637654', '0843657632', N'318 Trần Cung, Cổ Nhuế, BTL, HN', '0743646783'),
	('BN-002', N'Nguyễn Lan Anh', 24, N'123 Đa Tốn, Đa Tốn, GL, HN', N'Nữ', N'Sinh viên', '042543876243', '0865382734', N'123 Đa Tốn, Đa Tốn, GL, HN', '0653265478'),
	('BN-003', N'Hoàng Văn Huy', 65, N'4 Cổ Nhuế, Cổ Nhuế, BTL, HN', N'Nam', N'Tự do', '007645827631', '0873672687', N'4 Cổ Nhuế, Cổ Nhuế, BTL, HN', '0842758735'),
	('BN-004', N'Nguyễn Hoàng Anh', 45, N'Ngách 89/12 Phạm Văn Đồng, Mai Dịch, Cầu Giấy, HN', N'Nam', N'Bảo vệ', '035678428972', '0872467263', N'Ngách 89/12 Phạm Văn Đồng, Mai Dịch, Cầu Giấy, HN', '0926374676'),
	('BN-005', N'Lê Ngọc Anh', 18, N'8 P. Tôn Quang Phiệt, Cổ Nhuế, Từ Liêm, HN', N'Nữ', N'Sinh viên', '045345876246', '0237649827', N'8 P. Tôn Quang Phiệt, Cổ Nhuế, Từ Liêm, HN', '0824679237'),
	('BN-006', N'Trần Thị Thu', 37, N'Ngách 14, Mai Dịch, Cầu Giấy, HN', N'Nữ', N'Kế toán', '078653786267', '0767528746', N'Ngách 14, Mai Dịch, Cầu Giấy, HN', '0726374672'),
	('BN-007', N'Phan Hà Châu', 34, N'79 Đ. Lê Đức Thọ, Mỹ Đình, Từ Liêm, HN', N'Nữ', N'Qlý nhà hàng', '0762367682763', '06536537862', '79 Đ. Lê Đức Thọ, Mỹ Đình, Từ Liêm, HN', '0623527726'),
	('BN-008', N'Đỗ Thu Thảo', 27, N'Đ. Nguyễn Trãi, Thanh Xuân Nam, Thanh Xuân, HN', N'Nữ', N'Nv ngân hàng', '063564732658', '0263764827', N'Đ. Nguyễn Trãi, Thanh Xuân Nam, Thanh Xuân, HN', '0236423572'),
	('BN-009', N'Hồ Anh Khoa', 48, N'131A P. Thái Thịnh, Thịnh Quang, Đống Đa, HN', N'Nam', N'Nv văn phòng', '023677263872', '0462763726', N'131A P. Thái Thịnh, Thịnh Quang, Đống Đa, HN', '0236467268'),
	('BN-010', N'Ngô Quyền Anh', 62, N'Đại Mỗ, Đai Mễ, Nam Từ Liêm, HN', N'Nam', N'Thợ điện', '024723673821', '0723538910', N'Đại Mỗ, Đai Mễ, Nam Từ Liêm, HN', '0724662809'),
	('BN-011', N'Phạm Anh Khôi', 30, N'Chung cư Ba Cây Cọ, 187 Nguyễn Lương Bằng, Quang Trung, Đống Đa, HN', N'Nam', N'Giáo viên', '004372859820', '0823481937', N'Chung cư Ba Cây Cọ, 187 Nguyễn Lương Bằng, Quang Trung, Đống Đa, HN', '082347813'),
	('BN-012', N'Nguyễn Thu Hà', 54, N'Chung cư Vinaconex 1, Thăng Long Number One, Hà Nội, VN', N'Nữ', N'Thư kí', '023758379019', '0748396872', N'	Chung cư Vinaconex 1, Thăng Long Number One, Hà Nội, VN', '0712864728'),
	('BN-013', N'Bùi Thế Anh', 20, N'xóm Tháp, Đai Mỗ, Từ Liêm, HN', N'Nam', N'Công nhân', '034678392011', '0237837929', N'xóm Tháp, Đai Mỗ, Từ Liêm, HN', '0823472389'),
	('BN-014', N'Tô Ngọc Hiền', 39, N'6 P. Nguyễn Chánh, Trung Hoà, Cầu Giấy, HN', N'Nữ', N'Công nhân', '072678298109', '0237827932', N'6 P. Nguyễn Chánh, Trung Hoà, Cầu Giấy, HN', '0734782789'),
	('BN-015', N'Trần Ngọc Trang', 26, N'5 Ng. 7 Tôn Thất Thuyết, Dịch Vọng Hậu, Cầu Giấy, HN', N'Nữ', N'Tiếp viên', '018748928790', '0173647898', N'5 Ng. 7 Tôn Thất Thuyết, Dịch Vọng Hậu, Cầu Giấy, HN', '0274738798'),
	('BN-016', N'Đỗ Thu Thảo', 37, N'278 Lương Thế Vinh, Trung Văn, Nam Từ Liêm, HN', N'Nữ', N'Tự do', '027367840198', '0274647890', N'278 Lương Thế Vinh, Trung Văn, Nam Từ Liêm, HN', '0238647893'),
	('BN-017', N'Hồ Ánh Trinh', 42, N'73 Ngh. 32/84 P. Đỗ Đức Dục, Mễ Trì, Nam Từ Liêm, HN', N'Nữ', N'Công nhân', '023757489328', '0385738920', N'73 Ngh. 32/84 P. Đỗ Đức Dục, Mễ Trì, Nam Từ Liêm, HN', '0273463782'),
	('BN-018', N'Ngô Anh Văn', 38, N'19 Nguyễn Trãi, Ngã Tư Sở, Thanh Xuân, HN', N'Nam', N'Diễn viên', '023847489223', '0823774832', N'19 Nguyễn Trãi, Ngã Tư Sở, Thanh Xuân, HN', '0237474839'),
	('BN-019', N'Hoàng Anh Giang', 28, N'Yên Hoà, Cầu Giấy, HN', N' Nam', N'Giáo viên', '023588473898', '0238584938', N'Yên Hoà, Cầu Giấy, HN', '0234737583'),
	('BN-020', N'Lê Thanh Tâm', 34, N'19 P. Tố Hữu, Vạn Phúc, Hà Đông, HN', N'Nữ', N'Kế toán', '023488578730', '0234837823', N'19 P. Tố Hữu, Vạn Phúc, Hà Đông, HN', '0238437823');

INSERT INTO PhongBan (TenPB) VALUES 
	(N'Nhân viên kho'),
	(N'Giám đốc'),
	(N'Kế toán'),
	(N'Lao công'),
	(N'Shipper'),
	(N'Quản lí'),
	(N'Dược sĩ'), 
	(N'Thư kí');

INSERT INTO NhanVien (MaNV, TenNV, NgaySinh, GioiTinh, DienThoai, DiaChi, Email, Luong, NgayVaoLam, MaPB) VALUES 
	('NV-01', 'Vũ Văn Hiệp', '1998-12-09', 0, '0447289838', '19 Nguyễn Trãi, Ngã Tư Sở, Thanh Xuân, HN', 'Vuvanhiep1209@gmail.com', 5600000, '2020-03-23', 1),
	('NV-02', 'Nguyễn Thu Thủy', '1994-04-25', 1, '0236476723', 'Trung Văn, Nam Từ Liêm, HN', 'ntt25@gmail.com', 6000000, '2020-05-19', 1),
	('NV-03', 'Phan Minh Tuấn', '1986-11-30', 0, '0234784983', 'Nhân Chính, Thanh Xuân, HN', 'panmintuan@gmail.com', 12400000, '2014-12-27', 2),
	('NV-04', 'Bùi Văn Thái', '1992-03-28', 0, '0234742782', 'Ngh. 29/28 P. Khương Hạ, Khương Đình, Thanh Xuân, HN', 'bvt@gmail.com', 7200000, '2019-10-23', 6),
	('NV-05', 'Ngô Ngọc Lan', '2000-04-08', 1, '0345889403', 'Thanh Xuân Bắc, Thanh Xuân, HN', 'ngonl@gmail.com', 5000000, '2021-12-06', 3),
	('NV-06', 'Bùi Hồng Hạnh', '1989-07-25', 1, '0845974839', '2-60 Ngh. 144/2 P. Quan Nhân, Nhân Chính, Thanh Xuân, HN', 'bhhanh@gmail.com', 9700000, '2019-08-25', 3),
	('NV-07', 'Trần Bính Liên', '1993-05-28', 1, '0234778392', 'Khương Thượng, Đống Đa, HN', 'tblien@gmail.com', 7800000, '2019-10-09', 1),
	('NV-08', 'Nguyễn Phong Lợi', '1997-09-18', 0, '0238489309', '39-1 Ng. 9 - Hoàng Cầu, Chợ Dừa, Đống Đa, HN', 'npl@gmail.com', 6700000, '2020-05-20', 5),
	('NV-09', 'Đặng Thu Trà', '1987-09-28', 1, '0874889309', '46 P. Láng Hạ, Láng Hạ, Đống Đa, HN', 'dangthutra@gmail.com', 10000000, '2013-02-18', 7),
	('NV-10', 'Trịnh Thanh Tùng', '1999-03-29', 0, '0923787809', 'P.Yên Lãng, Láng Hạ, Đống Đa, HN', 'ttt03@gmail.com', 6800000, '2020-08-19', 1),
	('NV-11', 'Bùi Hồng Nhi', '2021-01-05', 1, '0234893092', 'Ng. 25 P. Vũ Ngọc Phan, Láng Hạ, Đống Đa, HN', 'buithunhi@gmail.com', 5600000, '2022-05-20', 4),
	('NV-12', 'Trịnh Đình Vũ', '1998-04-19', 0, '0758389302', '79 P. Vũ Ngọc Phan, Láng Hạ, Đống Đa, HN', 'tdv@gmail.com', 5600000, '2019-08-10', 1),
	('NV-13', 'Phan Bá Đào', '1994-07-20', 0, '0249288920', '25 Ng. 477 P. Kim Mã, Ngọc Khánh, Ba Đình, HN', 'pndao@gmail.com', 7800000, '2017-08-21', 6),
	('NV-14', 'Trần Văn Thoan', '1998-10-29', 0, '0837892019', '70 Ng. 1194 Đ. Láng, Láng Thượng, Đống Đa, HN', 'tvthoan@gmail.com', 5600000, '2020-02-10', 1),
	('NV-15', 'Nguyễn Thu Hà','1999-06-10', 1, '0129488920', '136 P. Chùa Láng, Láng Thượng, Đống Đa, HN', 'ntha@gmail.com', 5600000, '2020-02-19', 3),
	('NV-16', 'Vũ Văn Kiệt', '1998-10-04', 0, '0238890391', 'Láng Thượng, Đống Đa, HN', 'vuvank@gmail.com', 6700000, '2019-08-10', 5),
	('NV-17', 'Hà Thu Thật','1997-05-17', 1, '0890289309', 'Nghĩa Đô, Cầu Giấy, HN', 'hatt@gmail.com', 8900000, '2019-08-23', 8),
	('NV-18', 'Lê Thị Tuyết', '1994-07-12', 1, '0982487101', '88 Ng. 173 Đ. Hoàng Hoa Thám, Ngọc Hồ, Ba Đình, HN', 'lethit@gmail.com', 7400000, '2018-02-17', 6),
	('NV-19', 'Phan Thị Trang', '1999-10-26', 1, '0238490193', '2 P. Trần Quốc Hoàn, Dịch Vọng Hậu, Cầu Giấy, HN', 'phanthit@gmail.com', 5700000, '2020-02-19', 1),
	('NV-20', 'Lê Thị Tuấn Trinh', '1998-05-18', 1, '0823499019', '143 Ngõ 143 P. Quan Hoa, Quan Hoa, Cầu Giấy, HN', 'tuantrinh@gmail.com', 6700000, '2019-08-30', 3);
		
INSERT INTO Thuoc (MaThuoc, TenThuoc, MaNhom, NguonGoc, MaNSX, SoLuong, GiaBan, TenDVT, ThanhPhan, CongDung, ChuY, HSD, BaoQuan, DangBaoChe, CachDung, Kho) VALUES 
	(N'VD-20551-14 ', N'DICLOFENAC DHG', 1, N'Việt Nam', 3, N'10viên/vỉ x10', 50000, N'viên', N'-Thành phần hoạt chất: Diclofenac natri ................. 50 mg. -Thành phần tá dược: Colloidal silicon dioxyd, đường trắng, microcrystalline cellulose M101, gelatin, lactose monohydrat, magnesi stearat, natri starch glycolat, talc, tinh bột sắn, eudragit L100, polyethylen glycol 6000, titan dioxyd, màu cam E110, oxyd sắt đỏ, oxyd sắt đen. ', N'Điều trị viêm, đau trong các trường hợp: - Rối loạn cơ xương và khớp như: viêm khớp dạng thấp, viêm xương khớp, các dạng viêm và thoái hóa tiến triển của thấp khớp, các hội chứng đau của cột sống, thoái hóa đốt sống cứng khớp, đau nhức do trật khớp, đau nhức xương. Rối loạn quanh khớp như: viêm bao hoạt dịch, viêm gân,... Rối loạn mô mềm như: bong gân, căng gân. - Các trường hợp đau nhức khác: đau lưng. đau nhức vai, đau do chấn thương, đau đầu, bệnh gout cấp, đau bụng kinh, chứng thống kinh, đau viêm phần phụ. - Đau sau phẫu thuật, nhổ răng, cắt amiđan. - Làm giảm các triệu chứng đau, viêm có hoặc không có kèm theo sốt trong các trường hợp: do nhiễm virus, vi khuẩn (ở tai, mũi xoang, họng, nướu rắng,....). N', NULL, N'6 tháng kể từ ngày sản xuất ', N'Nơi khô, nhiệt độ không quá 30oC, tránh ánh sáng. ', N'Viên nén bao phim tan trong ruột.', N'-Không được bẻ hay nghiền viền thuốc khi uống.',200 ),
	(N'11759/2020/ĐKSP', N'Xương khớp Sao Thái Dương ', 1, N'Việt Nam', 2, N'30viên ', 450000, N'viên', N'-Bột mịn cao hỗn hợp dược liệu (Được chiết từ các dược liệu Sinh địa; Bạch thược; Đảng sâm; Đỗ trọng; Đương quy; Bạch linh; Độc hoạt; Ngưu tất: Tang ký sinh; Tần giao; Xuyên khung; Cam thảo; Phòng phong; Quế chi; Tế tân). -Cao xương hỗn hợp. -Cao Quy bản. ', N'-Hỗ trợ thông kinh hoạt lạc, mạnh gân cốt. -Hỗ trợ giảm đau nhức mỏi xương khớp, tê bì chân tay do khí huyết ứ trệ, do thoái hóa khớp, do phong thấp.', N'-Không sử dụng Xương Khớp Thái Dương cho các đối tượng sau: -Người mẫn cảm với bất cứ thành phần nào của sản phẩm. -Phụ nữ có thai, phụ nữ đang cho con bú. ', N'24 tháng kể từ ngày sản xuất.', N'Nơi khô ráo, thoáng mát , tránh ánh nắng trực tiếp. Để xa tầm với của trẻ nhỏ', N'Viên nang', N'-Ngày uống 2-3 lần, mỗi lần 2-3 viên. -Sử dụng theo liệu trình 1-3 tháng liên tục để đạt được hiệu quả tốt. ',200),
	(N'VD-20546-14', N'ALPHADHG ', 1, N'Việt Nam ', 3, N'10viên/vỉ x2', 20000, N'viên', N'-Hoạt chất: Chymotrypsin 21 microkatal (Tương đương 4200 USP unit). -Tá dược: Compressible sugar, magnesi stearat vừa đủ 1 viên. ', N'Điều trị phù nề sau chấn thương, phẫu thuật, bỏng. N', N'-Người lớn: Ngậm dưới lưỡi. Mỗi lần 1 - 2 viên, ngày 3 - 4 lần. -Hoặc theo chỉ dẫn của Thầy thuốc. N', N'4 tháng kể từ ngày sản xuất. ', N'Nơi khô, nhiệt độ không quá 30°C, tránh ánh sáng và ẩm. ', N'VIÊN NÉN', N'-Người lớn: Ngậm dưới lưỡi. Mỗi lần 1 - 2 viên, ngày 3 - 4 lần. -Hoặc theo chỉ dẫn của Thầy thuốc. ',200),
	(N'VD-25497-16', N'Coldacmin sinus ', 2, N'Việt Nam ', 3, N'10viên/vỉ x10 ', 260000, N'viên', N'Paracetamol, Clorpheniramin maleat, Tá dược (Tinh bột sắn, Lactose monohydrat, talc, magnesi stearat, màu vàng tartrazin, PVP K30): vừa đủ 1 viên ', N'Dùng điều trị triệu chứng các trường hợp: cảm sốt, nhức đầu, đau nhức cơ bắp, xương khớp kèm theo sổ mũi, viêm màng nhầy xuất tiết, viêm xoang do cảm cúm hoặc do dị ứng với thời tiết. ', N'– Phụ nữ mang thai và đang cho con bú. – Rối loạn bài tiết nước tiểu (thiểu niệu, vô niệu). N', N'36 tháng kể từ ngày sản xuất. ', N'Nơi khô, nhiệt độ không quá 30oC, tránh ánh sáng. ', N'viên nén', N'-Người lớn và trẻ nhỏ trên 12 tuổi: sử dụng 1 - 2 viên/ lần. -Trẻ nhỏ từ 6 - 12 tuổi: sử dụng ½ - 1 viên/lần. ',200),
	(N'VD-24597-16', N'Coldacmin Flu ', 2, N'Việt Nam ', 3, N'10viên/vỉ x10', 33000, N'viên', N'Clorpheniramin, Paracetamol (Tinh bột mì, PVA, đường trắng, màu đỏ erythrosin, màu vàng tartrazin). ', N'-Điều trị các triệu chứng cảm cúm thông thường như: nhức đầu, cảm sốt, sổ mũi,nghẹt mũi… -Có công dụng giảm đau đối với các trường hợp đang đau nhức cơ bắp, xương khớp,… -Được dùng trong việc điều trị và ngăn ngừa sự phát triển của các tình trạng: viêm xoang, viêm xoang dị ứng do thời tiết, viêm màng nhầy xuất tiết,…. PHẢN TÁC DỤNG: Một số biểu hiện cho thấy xảy ra tác dụng phụ của thuốc thông thường là: buồn nôn, phát ban,dị ứng, khô miệng, bí tiểu,rối loạn điều tiết, vã mồ hôi. Nặng hơn có thể là: giảm tiểu cầu, giảm toàn thể huyết cầu, có thê làm suy gan nếu sử dụng với liều cao,…Ngoài ra, còn một số biểu hiện không được kể đến ở trên. Báo cáo cho bác sỹ biết nếu bạn gặp các vấn đề trên trong quá trình sử dụng thuốc.', N'-Không sử dụng thuốc đối với các bệnh nhân có tiền sử dị ứng với một trong số thành phần hoạt chất, tá dược có trong thuốc. -Khuyến cáo không sử dụng thuốc với trẻ em, phụ nữ có thai ( vì có thể gây quái thai và dị tật ở trẻ) và phụ nữ đang trong đoạn cho con bú. -Ngoài ra, chống chỉ định dùng thuốc với các đối tượng sau: thiếu hụt glucose – 6 – phosphat dehydrogenase, bệnh nhân phì đại tuyến tiền liệt, loét dạ dày, đang trong giai đoạn điều trị cơn hen cấp, người đang dùng thuốc ức chế MAO, … ', N'6 tháng kể từ ngày sản xuất', N'Nơi khô, nhiệt độ không quá 30oC, tránh ánh sáng', N'Viên nang cứng', N'-Người lớn và trẻ nhỏ trên 12 tuổi: sử dụng 1 - 2 viên/ lần. -Trẻ nhỏ từ 6 - 12 tuổi: sử dụng ½ - 1 viên/lần.', 200),
	(N'VD-16011-11', N'Terpin Codein VPC ', 3, N'Việt Nam ', 4, N'10viên/vỉ x10 ', 125000, N'viên', N'Codein, Terpin , Ngoài ra còn có 1 số tá dược và phụ liệu khác với hàm lượng vừa đủ 1 viên nang như: Talc, povidon K 30, Magnesi stearat, tinh bột mì. ', N'điều trị cho các bệnh nhân bị ho, long đờm khi điều trị bệnh viêm phế quản mạn tính hoặc cấp tính ', N'', N'36 tháng ', N'Nơi khô, nhiệt độ không quá 30oC, tránh ánh sáng. ', N'Viên nan cứng', N'-Liều dùng cho người lớn: uống 2 viên/lần, ngày uống từ 2 đến 3 lần. -Liều dùng cho trẻ em trên 5 tuổi: sử dụng 1 viên mỗi lần, uống từ 2 đến lần một ngày. ', 200),
	(N'VD-17371-12', N'Bromhexin 4mg ', 3, N'Việt Nam ', 5, N'20viên/vỉ x10 ', 60000, N'viên', N'Bromhexin, Tá dược: Microcrystalline cellulose 101 (Avicel 101), Lactose monohydrat, Tinh bột ngô, Magnesi stearat, Nước tinh khiết. ', N'điều trị bệnh tăng tiết dịch phế quản, viêm phế quản cấp tính và viêm phế quản mạn tính ', N'', N'36 tháng kể từ ngày sản xuất ', N'Để ở nơi khô ráo, nhiệt độ dưới 30°C,tránh ánh sáng ', N'Viên nén', N'-Liều dùng đối với người lớn: uống 2 viên thuốc 1 lần, uống 3 lần mỗi ngày. -Liều dùng đối với trẻ em: Trẻ em từ 2 – 6 tuổi: uống 1 viên thuốc 1 lần, uống thuốc 2 lần mỗi ngày. Trẻ em từ 6 -12 tuổi: uống 1 viên thuốc 1 lần, uống thuốc 3 lần mỗi ngày. ', 200),
	(N'VD-16911-12', N'Dexpin Hataphar ', 3, N'Việt Nam ', 6, N'10viên/vỉ x10', 40000, N'viên', N'Dextromethorphan, Terpin hydrat', N'chữa các chứng ho do nhiều nguyên nhân khác nhau, như ho do viêm đường hô hấp, ho do dị ứng, ho do sau phẫu thuật,.. ', N'', N'36 tháng kể từ ngày sản xuất ', N'Để ở nơi khô ráo, nhiệt độ dưới 30°C,tránh ánh sáng', N'viên nang', N'-Người lớn: 1-2 viên/lần x 2 lần/ngày. -Trẻ > 30 tháng tuổi: ½ -1 viên/lần x 2 lần/ngày. ', 200),
	(N'VD-22373-15', N'Batonat ', 4, N'Việt Nam ', 7, N'10viên/vỉ xx10', 580000, N'viên', N'L-Ornithine L-Aspartate. Tá dược vừa đủ viên nang cứng ', N'-Người bệnh viêm gan cấp hay mạn tính, xơ gan, gan bị nhiễm mỡ, dẫn tới tăng amoniac. -Người bệnh mắc các biến chứng ở hệ thống thần kinh trong bệnh não gan hay có tình trạng rối loạn ý thức ở tiền hôn mê gan.-Đối tượng dùng nhiều rượu bia, thuốc lá hoặc những chất kích thích thường xuyên nhiều khiến chức năng gan dần suy giảm, dị ứng, nổi mẩn, vàng da nguyên nhân tại gan.', N'', N'36 tháng kể từ ngày sản xuất', N'Để ở nơi khô ráo, nhiệt độ dưới 30°C,tránh ánh sáng ', N'Viên nang mềm', N'– Liều dùng: Mỗi lần từ 1 đến 2 viên, ngày uống 3 lần, từ 1 đến 2 tuần. – Sau đó, người bệnh chuyển sang liều duy trì 01 viên mỗi lần, ngày sử dụng 3 lần, dùng liên tục từ 4 tới 5 tuần theo chỉ dẫn của bác sĩ. ', 200),
	(N'VD-30026-18', N'Zetracare', 4, N'Việt Nam ', 8, N'21 gói', 680000, N'viên', N'L-Isoleucin, L-Leucin, L-Valin ', N'bệnh nhân suy gan mất bù bị giảm albumin dưới 3,5g/dL mặc dù được bổ sung chế độ ăn đầy đủ. ', N'', N'24 tháng kể từ ngày sản xuất ', N'Để ở nơi khô ráo, nhiệt độ dưới 30°C,tránh ánh sáng ', N'Thuốc cốm', N'1 gói x 3 lần/ngày ', 200),
	(N'VD-27955-17', N'Ausginin 500 ', 4, N'Việt Nam ', 10, N'10viên/vỉ x6', 300000, N'viên', N'-Hoạt chất L-ornithine L-aspartate -Ngoài ra thuốc còn chứa tá dược vừa đủ 1 viên nang. ', N'chỉ định điều trị tình trạng tăng nồng độ amoniac huyết tương trong các bệnh lý gan, đặc biệt trong bệnh não – gan ', N'', N'30 tháng kể từ ngày sản xuất. ', N'Bảo quản nơi khô ráo thoáng mát, nhiệt độ dưới 30 độ C. ', N'Viên nang cứng', N'Liều dùng thông thường 2 viên/ lần và uống 3 lần/ ngày',200),
	(N'VN-15416-12', N'Japrolox Tablets 60mg ', 5, N'Việt Nam', 11, N'10viên/vỉ x2', 200000, N'viên', N'Loxoprofen ', N'-Người bị bệnh về xương khớp, bao gồm các bệnh thường gặp như viêm khớp dạng thấp, viêm khớp vai, hội chứng cổ – cánh tay. -Người bị đau lưng, đau răng. -Người bị đau sau phẫu thuật hoặc do gặp phải chấn thương.-Người bị sốt cao trong các trường hợp nhiễm khuẩn, nhiễm virus, viêm đường hô hấp… ', N'', N'36 tháng kể từ ngày sản xuất ', N'-Bảo quản thuốc Japrolox Tablets 60mg ở nơi cao ráo, thoáng mát, nhiệt độ dưới 30 độ C. -Để thuốc Japrolox Tablets 60mg cách xa tầm tay của trẻ em.', N'Viên nén', N'-Đối với người bị các vấn đề về xương khớp và đau do phẫu thuật, chấn thương, đau răng: dùng 1 viên x 3 lần mỗi ngày. Có thể tăng liều lên 2 viên Japrolox Tablets 60mg nếu thấy cần thiết. -Đối với người bị sốt cao: dùng 1 viên mỗi khi sốt cao trên 38,5 độ C. Liều tối đa là 3 viên/ngày. ', 200),
	(N'VN-19681-16', N'Durogesic 50 µg/h ', 5, N'Bỉ ', 12, N' 5miếng', 319000, N'miếng', N'Fentanyl – 8,4mg. Cùng các tá dược khác vừa đủ 1 miếng dán. ', N'chỉ định trong việc kiểm soát cơn đau, làm giảm nhanh cơn đau mạn tính, đau dai dẳng cần thiết phải sử dụng thuốc giảm đau opioid kéo dài ', N'', N'24 tháng kể từ ngày sản xuất', N'-Để thuốc ở nơi thoáng mát. Tuyệt đối không để thuốc ở trong tầm với trẻ em ngay cả khi đã dùng xong. Vị trí bảo quản là nơi có nhiệt độ nhỏ hơn 30 độ C. ', N'Miếng dán phóng thích qua da', N'-Với trẻ em trên 16 tuổi và người lớn: liều khởi đầu không vượt quá 25mcg/giờ, sau đó cân nhắc giảm liều dùng trong khoảng 12-25mcg. Mức liều dùng để chuẩn liều là 12mcg/giờ và xem xét hiệu lực giảm đau trên bệnh nhân, nếu hiệu quả giảm đau không đủ cần cân nhắc tăng liều dùng lên sau 3 ngày. Với trẻ đang sử dụng uống morphin 30-44mg/ngày chuyển sử dụng miếng dán liều 12 mcg/giờ, uống morphin 45-134 mg/ngày chuyển sang dùng miếng dán 25mcg/giờ. ', 200),
	(N'VN-16775-13', N'Gramadol Capsules ', 5, N'Ấn Độ', 13, N'10viên/vỉ x3', 270000, N'viên', N'Paracetamol, Tramadol ', N'chỉ định sử dụng cho các bệnh đau cấp tính vừa đến nặng ', N'', N'24 tháng kể từ ngày sản xuất ', N'-Nhiệt độ dưới 30 độ C. Tránh tiếp với ánh sáng mặt trời. Tránh xa tầm tay trẻ em. ', N'Viên nang cứng ', N'-Người lớn và trẻ trên 16 tuổi. Nếu như bị đau cấp tính thì sử dụng mỗi lần 2 viên, mỗi lần dùng cách nhau 4-6 giờ khi cần. Không dùng quá 8 viên mỗi ngày. Người bệnh suy thận. Nếu Creatinin < 30 ml/phút: Không uống quá 2 viên/lần, mỗi 12 giờ. Trẻ dưới 16 tuổi: Không khuyến cáo sử dụng thuốc cho độ tuổi này. ', 200),
	(N'VD-25447-16', N'Thanh huyết tiêu độc P/H ', 4, N' Việt Nam', 9, N'10viên/vỉ x6', 45000, N'viên', N'Chi Tử, Hoàng bá, Hoàng cầm, Hoàng Liên, Kim ngân hoa ', N'giải độc, mát gan, thanh huyết nhiệt ', N'', N'36 tháng kể từ ngày sản xuất ', N'Để ở nơi khô ráo, nhiệt độ dưới 30°C,tránh ánh sáng ', N'Viên nén bao đường', N'-Liều dùng trẻ em dưới 14 tuổi: uống 3 viên mỗi lần, ngày uống 3 lần. Liều dùng cho người lớn và trẻ em trên 14 tuổi: uống 5 viên mỗi lần, ngày uống 3 lần. Đối với người bị bệnh nặng cần tăng liều lên 7 đến 8 viên mỗi lần, hoặc uống theo chỉ dẫn của bác sĩ. ',200),
	(N'VD-29750-18', N'Desdinta ', 6, N'Việt Nam', 6, N'10viên/vỉ x3', 85000, N'viên', N'Desloratadin', N'Điều trị viêm mũi dị ứng, điều trị mề đay ', N'', N'36 tháng kể từ ngày sản xuất. ', N'-Để Desdinta tránh xa tầm tay trẻ em, ánh sáng trực tiếp từ mặt trời. Để Desdinta ở nơi có độ ẩm thấp, nhiệt độ dưới 30 độ và nơi thoáng mát.', N'Viên Nén Bao Phim.', N'-Người lớn và trẻ > 12 tuổi: 1 viên/lần/ngày. Trẻ < 12 tuổi: độ an toàn của Desdinta trên nhóm đối tượng này chưa được thiết lập.Bệnh nhân suy thận, suy gan: liều khuyến cáo là 5mg, uống cách ngày. ',200),
	(N'VD-29749-18', N'Clorpheniramin 4mg Hataphar ', 6, N'Việt Nam', 6, N'100viên', 160000, N'lọ', N'Chlorpheniramin Maleat ', N'-Điều trị cho bệnh nhân bị dị ứng có đáp ứng với thuốc kháng histamin. Giảm các triệu chứng do thủy đậu gây ra như ngứa. ', N'', N'36 tháng kể từ ngày sản xuất. ', N'-Để Clorpheniramin 4mg Hataphar tránh xa tầm tay trẻ em, ánh sáng trực tiếp từ mặt trời. Để Clorpheniramin 4mg Hataphar ở nơi có độ ẩm thấp, nhiệt độ dưới 30 độ và nơi thoáng mát. ', N'Viên Nén', N'-Người lớn và trẻ > 12 tuổi: 1 viên/ 4-6 giờ. Tối đa 6 viên/ngày. Clorpheniramin liều dùng cho người cao tuổi: tối đa 3 viên/ngày. Trẻ 6-12 tuổi: ½ viên/ 4-6 giờ. Tối đa 3 viên/ngày. Clorpheniramin 4mg trẻ em < 6 tuổi: không khuyến cáo dùng Clorpheniramin 4mg Hataphar. ',200),
	(N'VD-19842-13', N'Bidicorbic 500 ', 7, N'Việt Nam', 14, N'100 viên', 50000, N'lọ', N'Vitamin C ', N'-Hỗ trợ điều trị cho các bệnh nhân bị thiếu hụt vitamin C Hỗ trợ điều trị cho các bệnh nhân có triệu chứng Methemoglobin huyết vô căn khi không có sẵn xanh methylen. ', N'', N'36 tháng kể từ ngày sản xuất. ', N'-Bảo quản tại nơi khô ráo, thoáng mát. Nhiệt độ bảo quản không quá 30 độ . Tránh ánh sáng trực tiếp của mặt trời. Tránh xa tầm tay trẻ em. ', N'Viên Nang Cứng', N'1 Viên/Lần/Ngày. ',200),
	(N'VD-28772-18', N'Vixcar 75mg ', 8, N'Việt Nam', 15, N'10viên/vỉ x3', 100000, N'viên', N'-Clopidogrel Bisulfat. Tá Dươc Vừa Đủ: Cellulose Tinh Thể, Lactose Monohydrat, Manitol, Croscarmellose Natri, Butylat Hydroxytoluen, Hydroxypropyl Methylcellulose 6cPs, ,Agnesi Stearat, Silic Dioxyd, Talc, Polyethylen Glycol 400, Titan Dioxyd, Màu Hồ Erythrosin, Sắt Oxyd Đỏ và Đen. ', N'Phòng ngừa các biến cố huyết khối do xơ vữa động mạch. ', N'', N'36 tháng kể từ ngày sản xuất. ', N'-Nhiệt độ < 30 độ. Nơi khô ráo, độ ẩm không khí thấp. Tránh xa tầm tay trẻ nhỏ và vật nuôi. ', N'Viên Nén Bao Phim.', N'Người Lớn: 1 Viên/Lần/Ngày ',200),
	(N'VD-25443-16', N'Bát Tiên Trường họ P/H ', 9, N'Việt Nam', 9, N'240 viên', 150000, N'lọ', N'Bạch Linh, Hoài Sơn, Mẫu Đơn Bì, Sơn Thù, Thục Địa, Trạch Tả ,Mạch Môn ,Câu Kỷ Tử ,Mật Ong ', N'Bổ can thận, trị chứng phế thận âm hư ', N'', N'36 tháng kể từ ngày sản xuất. ', N'-Bảo quản thuốc tại nơi có nhiệt độ không vượt quá 30 độ C, tránh ánh sáng trực tiếp từ mặt trời. Để thuốc ở vị trí xa tầm mắt của trẻ. ', N'Viên Hoàn Mềm ', N'-Liều dùng tham khảo cho trẻ em dưới 6 tuổi: 5 đến 10 viên mỗi lần, ngày 2 lần. Trẻ em từ 6 đến 14 tuổi: 15 đến 20 viên mỗi lần, ngày 2 lần. Người lớn và trẻ em trên 14 tuổi: 25 đến 30 viên mỗi lần, ngày 2 lần. ',200);


INSERT INTO HoaDonXuat (MaHDX, MaThuoc, MaBN, GiaBan, MaNguoiBan, SoLuongXuat, Thue, GhiChu, NgayLap) VALUES
	('HDX-1', 'VD-20546-14', 'BN-001', 50000, 'NV-06', 20, 5, ' ', '2021-06-05 15:45:12'),
	('HDX-2', '11759/2020/ĐKSP', 'BN-002', 450000, 'NV-06', 12, 5, ' ', '2021-06-06 07:34:22'),
	('HDX-3', 'VD-20546-14', 'BN-003', 45000, 'NV-06', 10, 5, ' ', '2021-06-06 09:23:59'),
	('HDX-4', 'VD-25497-16', 'BN-004', 33000, 'NV-06', 15, 5, ' ', '2021-06-06 20:47:08'),
	('HDX-5', 'VD-16011-11', 'BN-005', 125000, 'NV-06', 8, 5, ' ', '2021-06-07 10:16:03'),
	('HDX-6', 'VD-17371-12', 'BN-006', 60000, 'NV-06', 10, 5, ' ', '2021-06-07 13:37:29'),
	('HDX-7', 'VD-16911-12', 'BN-007', 40000, 'NV-06', 18, 5, ' ', '2021-06-08 09:08:15'),
	('HDX-8', 'VD-22373-15', 'BN-008', 580000, 'NV-06', 5, 5, ' ', '2021-06-08 19:20:17'),
	('HDX-9', 'VD-20551-14', 'BN-009', 50000, 'NV-06', 7, 5, ' ', '2021-06-09 11:51:01'),
	('HDX-10', 'VD-19842-13', 'BN-010', 50000, 'NV-06', 14, 5, ' ', '2021-06-09 14:43:24'),
	('HDX-11', 'VD-29750-18', 'BN-011', 85000, 'NV-06', 24, 5, ' ', '2021-06-10 08:45:12'),
	('HDX-12', 'VD-29749-18', 'BN-012', 160000, 'NV-06', 17, 5, ' ', '2021-06-10 09:32:19'),
	('HDX-13', 'VD-25497-16', 'BN-013', 260000, 'NV-15', 14, 5, ' ', '2021-06-09 10:45:24'),
	('HDX-14', 'VD-24597-16', 'BN-014', 33000, 'NV-15', 30, 5, ' ', '2021-06-09 11:56:19'),
	('HDX-15', 'VD-17371-12', 'BN-015', 60000, 'NV-15', 27, 5, ' ', '2021-06-09 12:11:48'),
	('HDX-16', 'VD-16911-12', 'BN-016', 40000, 'NV-15', 35, 5, ' ', '2021-06-09 12:32:59'),
	('HDX-17', 'VD-22373-15', 'BN-017', 580000, 'NV-15', 20, 5, ' ', '2021-06-09 13:30:12'),
	('HDX-18', 'VD-30026-18', 'BN-018', 680000, 'NV-15', 5, 5, ' ', '2021-06-09 14:23:10'),
	('HDX-19', 'VD-29750-18', 'BN-019', 85000, 'NV-15', 35, 5, ' ', '2021-06-09 15:40:11'),
	('HDX-20', 'VN-16775-13', 'Bn-020', 270000, 'NV-15', 10, 5, ' ', '2021-06-15 14:06:56');	

INSERT INTO HoaDonNhap (MaHDN, NguoiGiao, MaNguoiNhan, MaThuoc, SoLuongNhap, Thue, GiaThuoc, NgayViet, NgayNhap)  VALUES 
	('HDN-1', 'Vũ Văn Kiệt', 'NV-01', N'11759/2020/ĐKSP', 100, 450000, 10, '2022-12-14', '2023-01-14'),
	('HDN-2', 'Nguyễn Phong Lợi', 'NV-01', N'VD-28772-18', 230, 90000, 10, '2022-12-14', '2023-01-14'),
	('HDN-3', 'Nguyễn Phong Lợi', 'NV-02', N'VD-20546-14', 100, 18000, 10, '2022-12-14', '2023-01-14'),
	('HDN-4', 'Vũ Văn Kiệt', 'NV-01', N'VD-20551-14', 80, 45000, 10, '2022-12-14', '2023-01-14'),
	('HDN-5', 'Vũ Văn Kiệt', 'NV-07', N'VD-25497-16', 120, 234000, 10, '2022-12-14', '2023-01-14'),
	('HDN-6', 'Vũ Văn Kiệt', 'NV-07', N'VD-24597-16', 40, 29700, 10, '2022-12-14', '2023-01-14'),
	('HDN-7', 'Nguyễn Phong Lợi', 'NV-10', N'VD-16011-11', 70, 112000, 10, '2022-12-14', '2023-01-14'),
	('HDN-8', 'Nguyễn Phong Lợi', 'NV-12', N'VD-17371-12', 30, 54000, 10, '2022-12-14', '2023-01-14'),
	('HDN-9', 'Nguyễn Phong Lợi', 'NV-14', N'VD-16911-12', 60, 36000, 10, '2022-12-14', '2023-01-14'),
	('HDN-10', 'Vũ Văn Kiệt', 'NV-19', N'VD-22373-15', 100, 450000, 10, '2022-12-14', '2023-01-14'),
	('HDN-11', 'Nguyễn Phong Lợi', 'NV-19', N'VD-29750-18', 150, 76500, 10, ' 2022-12-14 ', ' 2023-01-14 '),
	('HDN-12', 'Nguyễn Phong Lợi', 'NV-01', N'VD-29749-18', 126, 144000, 10, ' 2022-12-14 ', '2023-01-14 '),
	('HDN-13', 'Vũ Văn Kiệt', 'NV-07', N'VD-19842-13', 200, 45000, 10, ' 2022-12-14 ', ' 2023-01-14 '),
	('HDN-14', 'Nguyễn Phong Lợi', 'NV-19', N'VD-28772-18', 110, 81000, 10, ' 2022-12-14 ', ' 2023-01-14 '),
	('HDN-15', 'Vũ Văn Kiệt', 'NV-02', N'VD-25443-16', 150, 135000, 10, ' 2022-12-14 ', ' 2023-01-14 '),
	('HDN-16', 'Vũ Văn Kiệt', 'NV-19', N'VD-16911-12', 180, 36000, 10, ' 2022-12-14 ', ' 2023-01-14'),
	('HDN-17', 'Vũ Văn Kiệt', 'NV-07', N'VD-17371-12', 90, 50000, 10, ' 2022-12-14 ', ' 2023-01-14 '),
	('HDN-18', 'Nguyễn Phong Lợi', 'NV-14', N'VD-27955-17', 80, 60000, 10, ' 2022-12-14 ', ' 2023-01-14 '),
	('HDN-19', 'Nguyễn Phong Lợi', 'NV-14', N'VN-15416-12', 210, 180000, 10, ' 2022-12-14 ', ' 2023-01-14 '),
	('HDN-20', 'Vũ Văn Kiệt', 'NV-10', N'VN-16775-13', 100, 243000, 10, ' 2022-12-14 ', ' 2023-01-14 ');

	