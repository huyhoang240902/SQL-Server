use Bank
--DS KH của VCB
select Cust_name, Cust_id from customer inner join Branch on customer.Br_id=Branch.BR_id 
inner join Bank on Branch.B_id = Bank.b_id
where Bank.b_name like N'%Vietcombank'

--1.KH o NHS-DN
select distinct Cust_ad from customer 
select Cust_name, Cust_id, Cust_ad from customer
where Cust_ad like N'%Ngũ Hành Sơn Đà Nẵng%'

--2. Brand co Br_ad is null
select BR_name from Branch
where BR_ad is null

--3. Liệt kê những giao dịch rút tiền bất thường (<50000)
select distinct t_amount from transactions
select * from transactions 
where t_amount < 50000 and t_type=0;

--4. Hiển thị ds KH có kí tự thứ 3 từ cuối lên là chữ a, u, i
select Cust_id, Cust_name from customer
where Cust_name like N'%[a,u,i]__'

/*5.Hiển thị KH có địa chỉ sống ở vùng nông thôn.
Với quy ước: Noong thôn là vùng mà địa chỉ chứa: thôn, xã, xóm*/
SELECT Cust_id, Cust_name, Cust_ad 
FROM customer 
WHERE (Cust_ad LIKE N'%thôn%' OR Cust_ad LIKE N'%xã%' OR Cust_ad LIKE N'%xóm%') AND Cust_ad NOT LIKE N'%thị xã%';

--6. Trong quý 1 năm 2012, hiển thị DS KH có gd tại Vietcombank
select Customer.Cust_id, Customer.Cust_name, transactions.t_date from customer inner join account on customer.Cust_id=account.cust_id
inner join transactions on account.Ac_no= transactions.ac_no
where (Month(transactions.t_date) between 1 and 3) and year(transactions.t_date) = 2012

--7. Liệt kê những giao dịch thực hiện cùng giờ với giao dịch Lê Nguyễn Hoàng Văn trong năm 2016
SELECT transactions.t_id, transactions.t_time 
FROM customer 
INNER JOIN account ON customer.Cust_id = account.cust_id
INNER JOIN transactions ON account.Ac_no = transactions.ac_no
WHERE DATEPART(HOUR, transactions.t_time) = DATEPART(HOUR, (SELECT MAX(t_time) FROM transactions WHERE account.Ac_no = transactions.ac_no
AND YEAR(t_date)=2016)) 
  AND customer.cust_name LIKE N'%Lê Nguyễn Hoàng Văn%';

--8. Liệt kê các giao dịch của chi nhánh Huế năm 2016
select transactions.t_id from Branch inner join customer on Branch.BR_id= customer.Br_id
inner join account on customer.Cust_id=account.cust_id
inner join transactions on account.Ac_no= transactions.ac_no
where Branch.BR_ad like N'%Huế%' and year(t_date)=2016

--9. Hiển thị tên, họ và tên đệm của các khách hàng (2 cột khác nhau)
select reverse(left(reverse(Cust_name), charindex(' ', reverse(Cust_name), 0)-1)) as Ten,
reverse(substring(reverse(Cust_name), charindex(' ', reverse(Cust_name), 0)+1,100)) as HoTenDem
from customer

--10. Hiển thị tên thành phố/ tỉnh của khách hàng
SELECT Cust_name, SUBSTRING(Cust_ad, 1, CHARINDEX(',', Cust_ad + ',') -2) AS city_province
FROM customer;

select reverse(left(reverse(Cust_ad), charindex(',', reverse(Cust_ad), 0)-1)) as Province_City, Cust_name
from customer

--11. Ai là người thực hiện giao dịch gửi tiền vào ngày 27/09/2013, 
--họ thực hiện giao dịch đó ở chi nhánh nào, với lượng tiền bằng bao nhiêu
SELECT C.Cust_name, BR.BR_name, T.t_amount
FROM transactions T
JOIN account A ON T.ac_no = A.Ac_no
JOIN customer C ON A.cust_id = C.Cust_id
JOIN Branch BR ON C.Br_id = BR.BR_id
WHERE T.t_date = '2013-09-27' and t_type=1;

--12. Ông Nguyễn Lê Minh Quân đã thực hiện những giao dịch nào? 
--Hãy đưa ra tên chi nhánh, thời gian, loại giao dịch và số tiền mỗi lần giao dịch.
SELECT BR.BR_name, T.t_date, T.t_type, T.t_amount
FROM transactions T
JOIN account A ON T.ac_no = A.Ac_no
JOIN customer C ON A.cust_id = C.Cust_id
JOIN Branch BR ON C.Br_id = BR.BR_id
WHERE C.Cust_name like N'%Nguyễn Lê Minh Quân%'

--13. Từ tháng 5 đến tháng 12  năm 2014, chi nhánh Huế có những khách hàng nào tới thực hiện giao dịch,
--loại giao dịch là gì, số tiền là bao nhiêu?.
SELECT C.Cust_name, T.t_type, T.t_amount
FROM transactions T
JOIN account A ON T.ac_no = A.Ac_no
JOIN customer C ON A.cust_id = C.Cust_id
JOIN Branch BR ON C.Br_id = BR.BR_id
WHERE BR.BR_name like N'%Huế%' AND T.t_date BETWEEN '2014-05-01' AND '2014-12-31';

--14.Liệt kê những khách hàng sử dụng số điện thoại của Viettel và chưa thực hiện giao dịch nào
select customer.Cust_id, Cust_name
from transactions
join account on transactions.ac_no = account.Ac_no
join customer on account.cust_id = customer.Cust_id
join Branch on customer.Br_id = Branch.BR_id
where left(Cust_phone,2) in ('03', '05', '07', '08') 
and account.Ac_no not in (select transactions.ac_no from transactions)

--15. Hiển thị danh sách khách hàng đăng kí sử dụng dịch vụ của ngân hàng ở chi nhánh khác nơi ở của họ 
--(chỉ tính khác ở mức thành phố).
SELECT C.Cust_name, C.Cust_ad, BR.BR_ad
FROM customer C
JOIN Branch BR ON C.Br_id = BR.BR_id
WHERE CHARINDEX(',', C.Cust_ad) > 0 AND CHARINDEX(',', BR.BR_ad) > 0 AND 
LEFT(C.Cust_ad, CHARINDEX(',', C.Cust_ad) - 1) != LEFT(BR.BR_ad, CHARINDEX(',', BR.BR_ad) - 1);

--16. Hiển thị danh sách khách hàng chưa cập nhật số điện thoại theo quy định mới của chính phủ 
--(những số điện thoại có 11 số)
SELECT *
FROM customer
WHERE LEN(Cust_phone)=11 

--17. Mùa xuân năm 2013, có những khách hàng nào thực hiện giao dịch, 
--hiển thị loại giao dịch, lượng tiền giao dịch và chi nhánh giao dịch của họ
SELECT C.Cust_name, T.t_type, T.t_amount, BR.BR_name
FROM transactions T
JOIN account A ON T.ac_no = A.Ac_no
JOIN customer C ON A.cust_id = C.Cust_id
JOIN Branch BR ON C.Br_id = BR.BR_id
WHERE T.t_date BETWEEN '2013-01-01' AND '2013-03-31' 
AND A.Ac_no in (select transactions.ac_no from transactions)

--18. Hiển thị những giao dịch gửi tiền thực hiện vào ngày thứ 7 hoặc chủ nhật (giao dịch bất thường)
SELECT t_id, t_type, DATENAME(dw, t_date) as Date_Name
FROM transactions
WHERE DATENAME(dw, t_date) IN ('Saturday', 'Sunday') and t_type=1
--where t_type=1 and (datepart(dw, t_date) in (1,7)

--19. Chi nhánh nào không có khách hàng?
SELECT Branch.BR_id, Branch.BR_name
FROM Branch
WHERE BR_id NOT IN (
    SELECT DISTINCT Br_id
    FROM customer
);

--20. Tài khoản nào chưa từng thực hiện giao dịch
SELECT A.Ac_no, T.t_id
FROM account A
LEFT JOIN transactions T ON A.Ac_no = T.ac_no
WHERE T.t_id IS NULL

--Ai la ng cung chi nhanh voi Nguyễn Lê Minh Quân
select cust_name, br_id
from customer
where Br_id = (select Br_id from customer
				where cust_name like N'%Trần Văn Thiện Thanh%')
				and cust_name not like N'%Trần Văn Thiện Thanh%'

--Chi nhánh nào không có KH
select br_name from Branch
where BR_id not in ( select BR_id from customer)

--1.Thống kê số lượng giao dịch, tổng tiền giao dịch từng tháng của năm 2014
select Month(t_date) as Month_2014, count(t_id) as SLGD, sum(t_amount) as Amount from transactions
where Year(t_date) = 2014
group by MONTH(t_date)

--2. Thống kê tổng tiền khách hàng gửi của mỗi chi nhánh, sắp xếp theo thứ tự giảm dần của tổng tiền
select BR.BR_name, sum(t_amount) as SumAmount
from transactions T
JOIN account A ON T.ac_no = A.Ac_no
JOIN customer C ON A.cust_id = C.Cust_id
JOIN Branch BR ON C.Br_id = BR.BR_id
where T.t_type=1
group by BR.BR_name
Order by SumAmount DESC

--3.Những chi nhánh nào thực hiện nhiều giao dịch gửi tiền trong tháng 12/2015 hơn chi nhánh ĐN
select BR.BR_name, count(t_id) as SLGD
from transactions T
JOIN account A ON T.ac_no = A.Ac_no
JOIN customer C ON A.cust_id = C.Cust_id
JOIN Branch BR ON C.Br_id = BR.BR_id
WHERE  T.t_type =1 and Month(T.t_date)=12  and Year(T.t_date)=2015 
Group by BR.BR_name
Having count(T.t_id) > 
					(select count(T.t_id)
					from transactions T
					JOIN account A ON T.ac_no = A.Ac_no
					JOIN customer C ON A.cust_id = C.Cust_id
					JOIN Branch BR ON C.Br_id = BR.BR_id
					where BR.BR_name like N'%Đà Nẵng%' and T.t_type =1 
					and Month(T.t_date)=12 and Year(T.t_date)=2015)

--4. Hiển thị DSKH chưa thực hiện giao dịch trong năm 2017
select C.Cust_name  from transactions T
					JOIN account A ON T.ac_no = A.Ac_no
					JOIN customer C ON A.cust_id = C.Cust_id
where YEAR(T.t_date) = 2017 and A.Ac_no not in 
									(select Ac_no from transactions)

--5. Tìm giao dịch gửi tiền nhiều nhất trong mùa đông. 
--Nếu có thể, hãy đưa ra tên của người thực hiện giao dịch và chi nhánh
select TOP 1 T.t_id, T.t_amount, C.Cust_name, BR.BR_name from transactions T
					JOIN account A ON T.ac_no = A.Ac_no
					JOIN customer C ON A.cust_id = C.Cust_id
					JOIN Branch BR ON C.Br_id = BR.BR_id
where MONTH(T.t_date) between 10 and 12