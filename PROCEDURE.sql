CREATE PROCEDURE themNhomThuoc @TenNhom NVARCHAR(255)
AS
BEGIN
	INSERT INTO NhomThuoc(TenNhom) VALUES(@TenNhom);
END;

CREATE PROCEDURE xoaNhomThuoc @MaNhom BigInt
AS
BEGIN
	DELETE FROM NhomThuoc WHERE MaNhom = @MaNhom;
END

CREATE PROCEDURE themNhaSanXuat @TenNSX NVARCHAR(255), @DiaChi NVARCHAR(255), @DienThoai VARCHAR(255), @Email VARCHAR(255)
AS
BEGIN
	INSERT INTO NhaSanXuat(TenNSX, DiaChi, DienThoai, Email) VALUES (@TenNSX, @DiaChi, @DienThoai, @Email)
END