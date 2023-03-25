--Trigger
--so luong thuoc se giam sau khi xuat hoa don
CREATE TRIGGER insert_tbl_hoaDonXuat
ON dbo.HoaDonXuat
AFTER INSERT
AS
BEGIN
  UPDATE t
  SET t.Kho = t.Kho - i.SoLuongXuat
  FROM dbo.Thuoc t
  JOIN inserted i
    ON t.Mathuoc = i.MaThuoc
END

--Tự động xóa thuốc thuộc nhóm thuốc khi xóa nhóm thuốc
CREATE TRIGGER delete_tbl_nhom_thuoc
ON dbo.NhomThuoc
AFTER DELETE
AS
BEGIN
	DELETE FROM dbo.Thuoc WHERE MaNhom IN (SELECT MaNhom FROM deleted)
END


--Tự động update số lượng thuốc khi insert hoaDonNhap
CREATE TRIGGER insert_tbl_hoaDonNhap
ON dbo.HoaDonNhap
AFTER INSERT
AS
BEGIN
	IF EXISTS (SELECT * FROM dbo.Thuoc, inserted WHERE Thuoc.MaThuoc = inserted.MaThuoc)
		BEGIN
			UPDATE t
			SET t.Kho = t.Kho + i.SoLuongNhap
			FROM dbo.Thuoc t
			JOIN inserted i
			ON t.Mathuoc = i.MaThuoc
		END
END

