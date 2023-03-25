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

-- Reset Function
IF OBJECT_ID('calc_price', 'FN') IS NOT NULL
BEGIN
	DROP FUNCTION calc_price;
END;

IF OBJECT_ID('calc_tax', 'FN') IS NOT NULL
BEGIN
	DROP FUNCTION calc_tax;
END;

IF OBJECT_ID('calc_total', 'FN') IS NOT NULL
BEGIN
	DROP FUNCTION calc_total;
END;

IF OBJECT_ID('TimKiemThuoc', 'FN') IS NOT NULL
BEGIN
	DROP FUNCTION TimKiemThuoc;
END;

IF OBJECT_ID('thuocBanRaTheoNgay', 'FN') IS NOT NULL
BEGIN
	DROP FUNCTION thuocBanRaTheoNgay;
END;

IF OBJECT_ID('chiTietHoaDon', 'FN') IS NOT NULL
BEGIN
	DROP FUNCTION chiTietHoaDon;
END;

-- Reset View
IF OBJECT_ID('TatCaThuoc', 'V') IS NOT NULL
BEGIN
	DROP VIEW TatCaThuoc;
END;

IF OBJECT_ID('ThuocSapHet', 'V') IS NOT NULL
BEGIN
	DROP VIEW ThuocSapHet;
END;

IF OBJECT_ID('TongQuanThuoc', 'V') IS NOT NULL
BEGIN
	DROP VIEW TongQuanThuoc;
END;

-- Reset Trigger
IF OBJECT_ID('insert_tbl_hoaDonXuat', 'TR') IS NOT NULL
BEGIN
	DROP TRIGGER insert_tbl_hoaDonXuat;
END;

IF OBJECT_ID('delete_tbl_nhom_thuoc', 'TR') IS NOT NULL
BEGIN
	DROP TRIGGER delete_tbl_nhom_thuoc;
END;

IF OBJECT_ID('insert_tbl_hoaDonNhap', 'TR') IS NOT NULL
BEGIN
	DROP TRIGGER insert_tbl_hoaDonNhap;
END;

-- Reset Procedure
IF OBJECT_ID('themNhomThuoc', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE themNhomThuoc;
END;

IF OBJECT_ID('xoaNhomThuoc', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE xoaNhomThuoc;
END;

IF OBJECT_ID('themNhaSanXuat', 'P') IS NOT NULL
BEGIN
	DROP PROCEDURE themNhaSanXuat;
END;



