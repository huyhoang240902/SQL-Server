use SALES

select [Row ID], [Order ID], [Order Date], [Ship Date], [Ship Mode], [Customer ID], [Customer Name],
[Product ID], [Product Name], Sales, Quantity, [Shipping Cost], [Order Priority]
into HOADON from Orders

alter table HOADON
alter column [Row ID] float not null
alter table HOADON
add constraint PK_RowID primary key ([Row ID])


select [Row ID], [Customer ID], [Customer Name], City, State, Country, Region, Market 
into KHACHHANG from Orders 

alter table KHACHHANG
alter column [Row ID] float not null
alter table KHACHHANG
add constraint PK_RowID2 primary key ([Row ID])


select  distinct [Product ID], [Product Name],[Sub-Category], Category
into HANGHOA from Orders

alter table HANGHOA
alter column [Product ID] nvarchar(255) not null
alter table HANGHOA 
add constraint PK_ProductID primary key ([Product ID] )

alter table HOADON
add constraint FK_RowID2 foreign key ([Row ID]) References KHACHHANG([Row ID])
alter table HOADON
add constraint FK_ProductID foreign key ([Product ID]) References HANGHOA([Product ID])


--Truy van 1: Cho biết có bao nhiêu khách hàng ở Peru
select Country, count(distinct [Customer ID]) as so_noi_o
from KHACHHANG
where Country='Peru'
group by Country

--Truy van 2: Cho biết số khách hàng theo từng quốc gia
select Country, count(distinct [Customer ID]) as So_khach_hang
from KHACHHANG
group by Country
order by So_khach_hang DESC

--Truy van 3: Cho biết những loại hàng hóa được mua nhiều hơn 1000
select Category, sum(Quantity) as So_luong
from HANGHOA inner join HOADON on HANGHOA.[Product ID]=HOADON.[Product ID]
group by Category
having count(*)>1000

--Truy van 4: Cho biết số loại hình ship và tính tổng số lần của tất cả loại hình
select [Ship Mode], count(distinct [Order ID]) as So_lan from HOADON
group by [Ship Mode] 
union
select 'Total', count(distinct [Order ID]) from HOADON

--Truy van 5: Cho biết các sản phẩm thuộc loại hình công nghệ có giá bán nằm trong khoảng 400-500.
select HANGHOA.*, Sales from HANGHOA inner join HOADON on HANGHOA.[Product ID]=HOADON.[Product ID]
where Category = 'Technology' and Sales between 400 and 500
order by Sales ASC

--Truy van 6: Liệt kê ra 3 món hàng được mua nhiều nhất ở khu vực Central America
select top 3 [Product Name], sum(quantity) So_lan_mua
from KHACHHANG inner join HOADON on KHACHHANG.[Customer ID]=HOADON.[Customer ID]
where KHACHHANG.Region like 'Central America'  
group by [Product Name] 
order by So_lan_mua Desc

--Truy van 7: Cho biết có bao nhiêu nước tham gia mua hàng
select Country into NUOC  from KHACHHANG
group by Country
select count(*) as SoNuoc from NUOC

--Truy van 8: Cho biết thể loại vận chuyển nào được ưa chuộng nhất
select top 1 [Ship Mode], count(distinct [Order ID]) as LanVanChuyen from HOADON
group by [Ship Mode]
order by LanVanChuyen DESC

--Truy van 9: Cho biết 5 hàng hóa nào được bán nhiều nhất
select top 5 [Product Name], sum(Quantity) as SoLuong from HOADON
group by [Product Name]
order by SoLuong DESC

--Truy van 10: Tính số hàng được đặt trong tháng 6/2016
select sum(Quantity) as SoHang from HOADON
where month([Order Date]) = 6 and year([Order Date]) = 2016

--Truy van 11: Trung bình số sản phẩm được đặt mỗi tháng trong năm 2016
select  month([Order Date]) as Thang, year([Order Date]) as Nam, sum(Quantity) as SoLuongdathang 
into bangtinhtoan1 from HOADON
where YEAR([Order Date]) = 2016
group by MONTH([Order Date]),YEAR([Order Date])

select 'trung binh' as thang,'2016'as nam ,AVG(SoLuongDatHang) as SoLuongDatHang from bangtinhtoan1



