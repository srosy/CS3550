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
--select * from [Order Details Extended Above Average]

------------------------------------------------------- Q3.1 ----------------------------------------------------
use Northwind;
go
create table [Order Details Audit Trail]
(
OrderID int not null,
ProductID int not null,
user_name char(20) null,
[Timestamp] datetime null,
OldUnitPrice float null,
NewUnitPrice float null
);
go
create trigger InsertIntoAudit
on [Order Details] 
after update 
as 
if update(UnitPrice) begin
	declare @order_Id int = (select OrderID from deleted);
	declare @old_price float = (select UnitPrice from deleted);
	declare @new_price float = (select UnitPrice from inserted);
	declare @productId char(4) = (select ProductID from inserted);

	insert into [Order Details Audit Trail] values (
	@order_Id,
	@productId, 
	USER_NAME(), 
	GETDATE(), 
	@old_price, 
	@new_price);
end;
update [Order Details] set UnitPrice = 25.00 where orderId = (select top 1 OrderID from [Order Details] 
group by OrderID having COUNT(OrderID) = 1 order by NEWID());
select * from [Order Details Audit Trail]
----------------------------------------------- Q3.2 --------------------------------------------------------
go
create trigger fk_order_customers_on_update_no_action -- no action, customers <-> orders
on orders after update
as
if update(CustomerID)
begin
	if(select count(*) from customers inner join inserted on customers.CustomerID = inserted.CustomerID) = 0
	begin
	print 'rollback transaction. no rows modified. ';
	rollback transaction;
	end
	else
		print 'transaction is successfull. rows modified.;'
end
go
create trigger fk_orders_shippers_on_update_no_action  -- no action, shippers <-> orders
on orders after update
as
if update(ShipVia)
begin
	if(select count(*) from Shippers inner join inserted on Shippers.ShipperID = inserted.ShipVia) = 0
	begin
	print 'rollback transaction. no rows modified. ';
	rollback transaction;
	end
	else
		print 'transaction is successfull. rows modified.;'
end
------------------------------------------------------------------------------------------------------
go
create trigger fk_orders_customers_on_update_cascade -- cascade, customers <-> orders
on orders
after update
as
if update(CustomerID)
begin
	if(select count(*) from Customers inner join deleted on Customers.CustomerID = deleted.CustomerID) > 0
	begin
		print 'no modification or update on rows. rollback transaction';
		rollback transaction;
	end
	else
		print 'rows modified successfully.';
end

go
create trigger fk_orders_shippers_on_update_cascade -- cascade, shippers <-> orders
on orders
after update
as
if update(ShipVia)
begin
	if(select count(*) from Shippers inner join deleted on Shippers.ShipperID = deleted.ShipVia) > 0
	begin
		print 'no modification or update on rows. rollback transaction';
		rollback transaction;
	end
	else
		print 'rows modified successfully.';
end

-- Q3.3
--USE AdventureWorks2012;  
--GO  
--ALTER TABLE dbo.DocExe   
--DROP CONSTRAINT FK_Column_B;   
--GO 

declare @orderId int = (select top 1 OrderID from Orders group by OrderID having COUNT(OrderID) = 1 order by NEWID());
declare @shipperId int = (select top 1 shipvia from orders where OrderID = @orderId);
declare @customerId nchar(5) = (select top 1 CustomerID from orders where OrderID = @orderId);
select * from orders where orderId = @orderId;

-- no actions
update orders set ShippedDate = GETDATE() where OrderID = @orderId;
select * from orders where orderId = @orderId;
select * from shippers where ShipperID = @shipperId;
select * from Customers where CustomerID = @customerId;

-- cascades
delete from orders where OrderID = @orderId;
select * from orders where orderId = @orderId;
select * from shippers where ShipperID = @shipperId;
select * from Customers where CustomerID = @customerId;

































