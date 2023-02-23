Create database Quanlybanhang
use  Quanlybanhang
-- Tạo bảng LOAIHANG
create table LOAIHANG
(
MALOAI nchar(10) not null constraint PK_LOAIHANG primary key(MALOAI),
TENLOAI nvarchar(50) not null,
NUOCSX nvarchar(50) not null
)
-- Tạo bảng KHACHHANG
create table KHACHHANG      (
		MAKH nchar(10) not null constraint PK_KHACHHANG primary key(MAKH),
		HOTEN nvarchar(50) not null,
		SODT nchar(20) not null,
		PHAI nvarchar(10),
		NGSINH smalldatetime,
		DCHI nvarchar(50)
)
-- Tạo bảng SANPHAM
Create table SANPHAM(
MASP nchar(10) not null constraint PK_SANPHAM primary key(MASP),
MALOAI nchar(10) not null,
TENSP nvarchar(50) not null,
SOLUONG nchar(10) not null,
GIA money,
THUE money,
KHUYENMAI money,
GIABAN money
)
--TẠo bảng HOADON
Create table HOADON(
SOHD nchar(10) not null CONSTRAINT Pk_HOADON primary key(SOHD),
MAKH nchar(10) not null,
NGAYHD smalldatetime)
--TẠo bảng CTHD
create table CTHD(
SOHD nchar(10) not null ,
MASP nchar(10) not null,
SOLUONG nchar(10),
DONGIA money,
THANHTIEN money,
constraint PK_CTHD primary key(SOHD,MASP)
)
--Tạo ràng buộc SANPHAM:
alter table SANPHAM
add constraint FK_SANPHAM_LOAIHANG foreign key(MALOAI) References LOAIHANG(MALOAI)
--Tạo ràng buộc HOADON
alter table HOADON
add constraint FK_HOADON_KHACHHANG foreign key(MAKH) References KHACHHANG(MAKH)
--Tạo ràng buộc bảng CTHD
alter table CTHD
add 
constraint FK_CTHD_SANPHAM foreign key(MASP) References SANPHAM(MASP),
constraint FK_CTHD_HOADON foreign key(SOHD) references HOADON(SOHD)
-- Nhập dữ liệu bảng LOAIHANG
insert into LOAIHANG(MALOAI,TENLOAI,NUOCSX)
values
('SS','SAMSUNG',N'HÀN QUỐC'),
('XM','XIAOMI',N'TRUNG QUỐC'),
('IP','IPHONE',N'MỸ')
SELECT*FROM LOAIHANG
--Nhâp dữ liệu bảng KHACHHANG
insert into KHACHHANG(MAKH,HOTEN,SODT,PHAI,NGSINH,DCHI)
values
('KH0001',N'Mai Ngọc Thắng','0332921475','Nam','1992-10-22',N'Q1-TPHCM'),
('KH0002',N'Lê Thị Đoan Trang','0911102244','Nữ','1998-08-14',N'Ba Đình-Hà Nội'),
	('KH0003',N'Nguyễn Đình Hưng','0984234325','Nam','1984-12-29',N'Thanh Khê-Đà Nẵng'),
	('KH0004',N'Nguyễn Thị Thùy Dương','0903243253','Nữ','1995-02-03',N'Q7-TPHCM'),
	('KH0005',N'Châu Nhật Bằng','0833905235','Nam','1999-08-09',N'Q4-TPHCM'),
	('KH0006',N'Phạm Văn Bách','0371940324','Nam','2000-12-15',N'Cẩm Lệ-Đà Nẵng'),
	('KH0007',N'Phan Huy Nam','0940478333','Nam','1985-03-16',N'Nam Đàn-Nghệ An'),
	('KH0008',N'Đào Thị Bích Thoa','0998453212','Nữ','1967-12-28',N'Vĩnh Ninh--TT Huế'),
	('KH0009',N'Nguyễn Văn Hoàng','0234832146','Nam','1955-05-31',N'Đông Hà-Quảng Tri'),
	('KH0010',N'Nguyễn Nhật Quang','0933376845','Nam','1991-06-13',N'Tam Kì-Quảng Nam')

--Nhập dữ liệu SANPHAM
insert into SANPHAM(MASP,MALOAI,TENSP,SOLUONG,GIA)
VALUES
('SS0001','SS','Galaxy A02',10,'2590000'),
('SS0002','SS','Galaxy A12',10,'4290000'),
('SS0003','SS','Galaxy A21',12,'20790000'),
('IP0001','IP','IPhone SE',7,'11900000'),
('IP0002','IP','IPhone 12',15,'20490000'),
('XM0001','XM','Redmi 9C',18,'2990000'),
('XM0002','XM','Redmi 9T',9,'4990000')
---- Nhập dữ liệu HOADON
insert into HOADON(SOHD,MAKH,NGAYHD)
values
('HD0001','KH0001','2021-08-20'),
('HD0002','KH0007','2021-10-15'),
('HD0003','KH0009','2021-07-09')
---- Nhap dữ lệu CTHD
insert into CTHD(SOHD,MASP,SOLUONG)
values 
('HD0001','SS0001',1),
('HD0001','SS0002',1),
('HD0001','IP0001',1),
('HD0001','IP0002',1),
('HD0001','XM0001',1),
('HD0001','XM0002',1),
('HD0002','SS0002',1),
('HD0003','IP0001',1)



/*3) Cập nhật thông tin cho bảng SANPHAM như sau:
a. Tính số tiền tại cột THUE, biết rằng: Nếu GIA<5 triệu, THUE là 5%; Nếu 5
triệu=<GIA<=10 triệu, THUE 7%; còn lại là 10%.
b. Tính số tiền được khuyến mãi, biết rằng: Nếu MASP là SS thì khuyến mãi 10%, Nếu MaSP
là XM thì khuyến mãi 20%, các sản phẩm khác không khuyến mãi.
c. GIABAN=GIA+THUE-KHUYENMAI
*/
--Thuế
update SANPHAM
set THUE=
case
	when GIA<5000000 then 0.05
	when GIA<10000000 THEN 0.07
	else 0.1
	end
--Khuyến mãi
update SANPHAM
set KHUYENMAI=
CASE
when MASP LIKE('SS%') Then 0.1
when MASP LIKE('XM%') THEN 0.2
else 0
end
--Giá bán
update SANPHAM
set GIABAN=GIA+THUE-KHUYENMAI
SELECT*from SANPHAM
--4) Cho biết thông tin khách hàng (MAKH, HOTEN) có tuổi > 30 và địa chỉ ở ĐÀ NẴNG.
SELECT MAKH,HOTEN from KHACHHANG
WHERE datediff(Year,NGSINH,getdate())>30 AND DCHI LIKE N'%Đà Nẵng%'
--5) Cho biết sản phẩm (MASP, TENSP) nào được bán ra trong tháng 8 năm 2021.
select SANPHAM.MASP,SANPHAM.TENSP from SANPHAM inner join CTHD on SANPHAM.MASP=CTHD.MASP
inner join HOADON on CTHD.SOHD=HOADON.SOHD
WHERE month(NGAYHD)=08
--6) Cho biết thông tin của sản phẩm (MASP, TENSP, TENLOAI) có nước sản xuất là HÀN QUỐC hoặc MỸ.
select MASP,TENSP,TENLOAI from LOAIHANG inner join SANPHAM on LOAIHANG.MALOAI=SANPHAM.MALOAI
Where NUOCSX =N'HÀN QUỐC' OR NUOCSX=N'MỸ'
--7) Tìm khách hàng (MAKH, HOTEN) chưa mua sản phẩm nào.
select MAKH,HOTEN from KHACHHANG
except
select KHACHHANG.MAKH,HOTEN from KHACHHANG inner join HOADON on KHACHHANG.MAKH=HOADON.MAKH
--8) Tìm khách hàng (MAKH, HOTEN) và số lượng sản phẩm có thể đã mua tại cửa hàng.
SELECT KHACHHANG.MAKH,HOTEN,COUNT(*) as Số_lượng_sản_phẩm FROM KHACHHANG 
INNER join HOADON ON KHACHHANG.MAKH=HOADON.MAKH 
inner join CTHD on HOADON.SOHD=CTHD.SOHD
inner join SANPHAM on CTHD.MASP=SANPHAM.MASP
GROUP BY KHACHHANG.MAKH,HOTEN

--9) (**) Cho biết loại sản phẩm nào (MALOAI, TENLOAI) có giá bán trung bình cao nhất.
SELECT top 1 SANPHAM.MALOAI,TENLOAI,avg(GIA) as Giá_trung_bình
 FROM LOAIHANG inner join SANPHAM on LOAIHANG.MALOAI=SANPHAM.MALOAI
 group by SANPHAM.MALOAI,TENLOAI
 order by Giá_trung_bình DESC
--10) (***) Cho biết khách hàng (MAKH, HOTEN) nào đã mua tất cả các sản phẩm được sản xuất bởi SAMSUNG.
select KHACHHANG.MAKH,HOTEN 
from KHACHHANG inner join HOADON on KHACHHANG.MAKH=HOADON.MAKH inner join CTHD on HOADON.SOHD=CTHD.SOHD
where MASP in(select MASP from SANPHAM where MASP like 'SS%') 
group by KHACHHANG.MAKH,HOTEN 
having count(CTHD.SOHD)>1

