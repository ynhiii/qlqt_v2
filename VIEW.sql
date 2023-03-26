USE QLQT;
CREATE VIEW TatCaThuoc AS SELECT * FROM Thuoc;

USE QLQT;
CREATE VIEW ThuocSapHet AS SELECT * FROM Thuoc WHERE Kho < 200;

USE QLQT;
CREATE VIEW TongQuanThuoc AS SELECT
Thuoc.MaThuoc, NhomThuoc.TenNhom ,Thuoc.TenThuoc, Thuoc.NguonGoc,NhaSanXuat.TenNSX,Thuoc.GiaBan, Thuoc.SoLuong, Thuoc.Kho
FROM Thuoc
LEFT JOIN NhomThuoc
ON Thuoc.MaNhom = NhomThuoc.MaNhom
LEFT JOIN NhaSanXuat
ON Thuoc.MaNSX = NhaSanXuat.MaNSX;

