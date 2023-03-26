USE QLQT;
CREATE VIEW ToanBoDatabase 
AS
SELECT 
  NhomThuoc.MaNhom AS NhomThuoc_MaNhom, 
  NhomThuoc.TenNhom AS NhomThuoc_TenNhom, 
  NhaSanXuat.MaNSX AS NhaSanXuat_MaNSX, 
  NhaSanXuat.TenNSX AS NhaSanXuat_TenNSX, 
  NhaSanXuat.DiaChi AS NhaSanXuat_DiaChi, 
  NhaSanXuat.DienThoai AS NhaSanXuat_DienThoai, 
  NhaSanXuat.Email AS NhaSanXuat_Email, 
  NhaSanXuat.SoLoSX AS NhaSanXuat_SoLoSX, 
  NhaSanXuat.GhiChu AS NhaSanXuat_GhiChu,
  Thuoc.MaThuoc AS Thuoc_MaThuoc, 
  Thuoc.TenThuoc AS Thuoc_TenThuoc, 
  Thuoc.MaNhom AS Thuoc_MaNhom, 
  Thuoc.NguonGoc AS Thuoc_NguonGoc, 
  Thuoc.MaNSX AS Thuoc_MaNSX, 
  Thuoc.SoLuong AS Thuoc_SoLuong, 
  Thuoc.GiaBan AS Thuoc_GiaBan, 
  Thuoc.TenDVT AS Thuoc_TenDVT, 
  Thuoc.ThanhPhan AS Thuoc_ThanhPhan, 
  Thuoc.CongDung AS Thuoc_CongDung, 
  Thuoc.ChuY AS Thuoc_ChuY, 
  Thuoc.HSD AS Thuoc_HSD, 
  Thuoc.BaoQuan AS Thuoc_BaoQuan, 
  Thuoc.DangBaoChe AS Thuoc_DangBaoChe, 
  Thuoc.CachDung AS Thuoc_CachDung, 
  Thuoc.Kho AS Thuoc_Kho,	
  BenhNhan.MaBN AS BenhNhan_MaBN, 
  BenhNhan.Ten AS BenhNhan_Ten, 
  BenhNhan.Tuoi AS BenhNhan_Tuoi, 
  BenhNhan.DiaChi AS BenhNhan_DiaChi, 
  BenhNhan.GioiTinh AS BenhNhan_GioiTinh, 
  BenhNhan.NgheNghiep AS BenhNhan_NgheNghiep, 
  BenhNhan.CCCD AS BenhNhan_CCCD, 
  BenhNhan.SDT AS BenhNhan_SDT, 
  BenhNhan.DiaChiKhiCanLienHe AS BenhNhan_DiaChiKhiCanLienHe, 
  BenhNhan.SDTNguoiNha AS BenhNhan_SDTNguoiNha, 
  PhongBan.MaPB AS PhongBan_MaPB, 
  PhongBan.TenPB AS PhongBan_TenPB, 
  NhanVien.MaNV AS NhanVien_MaNV, 
  NhanVien.TenNV AS NhanVien_TenNV, 
  NhanVien.NgaySinh AS NhanVien_NgaySinh, 
  NhanVien.GioiTinh AS NhanVien_GioiTinh, 
  NhanVien.DienThoai AS NhanVien_DienThoai
FROM 
	NhomThuoc
JOIN Thuoc ON NhomThuoc.MaNhom=Thuoc.MaNhom
JOIN NhaSanXuat ON Thuoc.MaNSX = NhaSanXuat.MaNSX
JOIN HoaDonNhap ON Thuoc.MaThuoc = HoaDonNhap.MaThuoc
JOIN HoaDonXuat ON Thuoc.MaThuoc = HoaDonXuat.MaThuoc
JOIN BenhNhan ON HoaDonXuat.MaBN = BenhNhan.MaBN
JOIN NhanVien ON HoaDonNhap.MaNguoiNhan = NhanVien.MaNV OR HoaDonXuat.MaNguoiBan = NhanVien.MaNV
JOIN PhongBan ON NhanVien.MaPB = PhongBan.MaPB;



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

