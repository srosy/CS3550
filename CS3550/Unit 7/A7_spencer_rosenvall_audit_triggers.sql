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
go
update [Order Details] set UnitPrice = 25.00 where orderId = (select top 1 OrderID from [Order Details] 
group by OrderID having COUNT(OrderID) = 1 order by NEWID());
go
select * from [Order Details Audit Trail];