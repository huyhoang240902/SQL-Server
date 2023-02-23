--Q1
create database QuanLyKS
use QuanLyKS

create table PHONG(MaPhong nchar(10) not null primary key, LoaiPhong nchar(4) not null,
DonGia money, SucChua nvarchar(10))

create table HOADON(SoHoaDon nchar(10) not null primary key, MaKhach nchar(10) not null,
MaPhong nchar(10) not null, NgayLapHD datetime, NgayDen datetime, NgayDi datetime, 
ThoiGianThue int, TienPhong money, ChietKhau money, TienThanhToan money)

create table KHACHTHUE(MaKhach nchar(10) not null primary key, TenKhach nvarchar(40) not null,
QuocTich nvarchar(30), NgaySinh datetime, GioiTinh nvarchar(3), Email varchar(50))

alter table HOADON add
constraint FK_KHACHTHUE foreign key (MaKhach) references KHACHTHUE(MaKhach),
constraint FK_PHONG foreign key (MaPhong) references PHONG(MaPhong)

--Q2
insert into PHONG(MaPhong,LoaiPhong,SucChua)
values ('L0001','Lux','3 Nguoi'),
('E0001','Eco','2 Nguoi'),
('E0002','Eco','2 Nguoi'),
('L0002','Lux','3 Nguoi'),
('V0001','VIP','5 Nguoi')

insert into HOADON(SoHoaDon,MaKhach,MaPhong,NgayLapHD,NgayDen,NgayDi)
values ('HD0001','KH0001','L0001','2021-01-30','2021-01-31','2021-05-31'),
('HD0002','KH0002','E0001','2021-02-25','2021-02-26','2021-11-26'),
('HD0003','KH0003','E0001','2021-02-26','2021-02-27','2021-04-27'),
('HD0004','KH0004','L0001','2021-03-30','2021-03-31','2021-09-30'),
('HD0005','KH0005','V0001','2021-04-01','2021-04-02','2021-11-02')

insert into KHACHTHUE(MaKhach,TenKhach,QuocTich,GioiTinh,Email)
values ('KH0001','Nguyen Van Q','Viet Nam','Nam','Bigbird@gmail.com'),
('KH0002','Nguyen Quoc M','Han Quoc','Nu','quocm@gmail.com'),
('KH0003','Phan Ngoc T','Viet Nam','Nam','ngoct@gmail.com'),
('KH0004','Nguyen Tuan H','Trung Quoc','Nu','tuanh@gmail.com'),
('KH0005','Dang Van B','Viet Nam','Nam','vanb@gmail.com')

--Q3
update PHONG
set DonGia=
case 
	when LoaiPhong='VIP' then '300'
	when LoaiPhong='Lux' then '150'
	else '100'
end

--Q4
update HOADON
set ThoiGianThue=datediff(day,NgayDen,NgayDi)

--Q5
update HOADON
set TienPhong=ThoiGianThue*DonGia
from HOADON inner join PHONG on HOADON.MaPhong=PHONG.MaPhong

--Q6
update HOADON
set ChietKhau=
case 
	when ThoiGianThue>8 then 0.2*TienPhong
	when ThoiGianThue>=6 then 0.1*TienPhong
	when ThoiGianThue>=3 then 0.05*TienPhong
	else 0
end

--Q7
select LoaiPhong, count(*) as SoPhongThue from PHONG
group by LoaiPhong
order by LoaiPhong, count(*) DESC

--Q8
select LoaiPhong, count(*) as So_Phong_Duoc_Thue 
from PHONG inner join HOADON on PHONG.MaPhong=HOADON.MaPhong
where LoaiPhong='VIP' and month(NgayLapHD) between 4 and 6 and ThoiGianThue>5
group by LoaiPhong
order by LoaiPhong, count(*) DESC

--Q9
select MaPhong, count(*) as SoLanThue, sum(ThoiGianThue) as TongThoiGianThue, 
AVG(ThoiGianThue) as ThoiGianThueTB from HOADON
where month(NgayLapHD)=10 and year(NgayLapHD)=2021
group by MaPhong

--Q10
select TenKhach,QuocTich,NgayDen,NgayDi,LoaiPhong,DonGia
from KHACHTHUE inner join HOADON on KHACHTHUE.MaKhach=HOADON.MaKhach
inner join PHONG on HOADON.MaPhong=PHONG.MaPhong
where QuocTich <> 'Viet Nam' and NgayDen='2021-11-20'
group by TenKhach,QuocTich,NgayDen,NgayDi,LoaiPhong,DonGia
order by NgayDen DESC


