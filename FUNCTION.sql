--Function Loai 1
--TinhTienThuoc
USE QLQT;
CREATE FUNCTION calc_price (@price decimal(10, 2), @quantity int)
RETURNS decimal(10, 2)
AS
BEGIN
  DECLARE @total decimal(10, 2);
  SET @total = @price * @quantity;
  RETURN @total;
END;

--TinhTongThue
USE QLQT;
CREATE FUNCTION calc_tax (@price decimal(10, 2), @quantity int, @tax decimal(10, 2))
RETURNS decimal(10, 2)
AS
BEGIN
  DECLARE @total decimal(10, 2);
  SET @total = @price * @quantity * 10 / @tax;
  RETURN @total;
END;

--TinhTongTienThuoc
USE QLQT;
CREATE FUNCTION calc_total (@price decimal(10, 2), @quantity int, @tax decimal(10, 2))
RETURNS decimal(10, 2)
AS
BEGIN
  DECLARE @total decimal(10, 2);
  SET @total = @price * @quantity + @price * @quantity * 10 / @tax;
  RETURN @total;
END;

--Function Loai 2
--Tim kiem ten thuoc va ma thuoc
USE QLQT;
CREATE FUNCTION TimKiemThuoc(@param nvarchar(MAX))
RETURNS TABLE
AS
RETURN (
	SELECT *
	FROM Thuoc
	WHERE MaThuoc LIKE '%'+ @param +'%'
	OR TenThuoc LIKE '%'+ @param +'%'
);

USE QLQT;
CREATE FUNCTION thuocBanRaTheoNgay(@from datetime, @end datetime)
RETURNS TABLE
AS
RETURN (
SELECT Thuoc.*, HoaDonXuat.NgayLap
	FROM Thuoc
	LEFT JOIN HoaDonXuat
	ON Thuoc.MaThuoc = HoaDonXuat.MaThuoc
	WHERE HoaDonXuat.NgayLap BETWEEN @from AND @end
);

--Function Loai 3
USE QLQT;
CREATE FUNCTION chiTietHoaDon (@MaHoaDon NVARCHAR(255))
RETURNS @SanPham TABLE (
	MaThuoc NVARCHAR(255),
	TenThuoc NVARCHAR(255),
	SoLuong int,
	Thue DECIMAL(10,2),
	GiaThuoc DECIMAL(10,2),
	TongHD DECIMAL(10,2)
)
AS
BEGIN
	INSERT INTO @SanPham (MaThuoc, TenThuoc, SoLuong, GiaThuoc, Thue, TongHD)
	SELECT
		t.MaThuoc, t.TenThuoc, h.SoLuongNhap, t.GiaBan, h.Thue, h.TongTienHD
	FROM HoaDonNhap h
	INNER JOIN Thuoc t ON h.MaThuoc = t.MaThuoc
	WHERE h.MaHDN = @MaHoaDon;

	RETURN;
END