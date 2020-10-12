------------------------------------------------------ Q1 --------------------------------------------------------
use Northwind;
go
select distinct p.* from [Product Sales for 1997] p 
join [Order Details Extended] d on p.ProductName = d.ProductName
join [Summary of Sales by Quarter] s on s.OrderID = d.OrderID
where d.Discount = 0 and s.ShippedDate between '1997/01/01' and '1997/03/31'
order by p.CategoryName;
------------------------------------------------------- Q2 -------------------------------------------------------
use Northwind;
go
create view [Order Details Extended Above Average] 
as
with temp as (
SELECT o.OrderID, o.ProductID, p.ProductName, o.UnitPrice, o.Quantity, o.Discount,
CONVERT(money, (o.UnitPrice * o.Quantity) * (1 - o.Discount) / 100) * 100 AS [ExtendedPrice]
FROM [Order Details] o join Products p on o.ProductID = p.ProductID
),
AverageExtendedPrice([average]) as (
select AVG(CONVERT(money, (UnitPrice * Quantity) * (1 - Discount) / 100) * 100) from [Order Details]
)
select * from temp where [ExtendedPrice] > (select average from AverageExtendedPrice);
go
select * from [Order Details Extended Above Average] -- Q2


































