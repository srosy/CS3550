
----------------------------------------------- Q3.2 --------------------------------------------------------
go
create trigger fk_order_customers_on_update_no_action -- no action, customers <-> orders
on orders after update
as
--if update(CustomerID)
begin
	if(select count(*) from customers inner join inserted on customers.CustomerID = inserted.CustomerID) = 0
	begin
	print 'rollback transaction. no rows modified. (fk_order_customers_on_update_no_action)';
	rollback transaction;
	end
	else
		print 'transaction is successfull. rows modified. (fk_order_customers_on_update_no_action)';
end
go
create trigger fk_orders_shippers_on_update_no_action  -- no action, shippers <-> orders
on orders after update
as
--if update(ShipVia)
begin
	if(select count(*) from Shippers inner join inserted on Shippers.ShipperID = inserted.ShipVia) = 0
	begin
	print 'rollback transaction. no rows modified. (fk_orders_shippers_on_update_no_action)';
	rollback transaction;
	end
	else
		print 'transaction is successfull. rows modified. (fk_orders_shippers_on_update_no_action)';
end
------------------------------------------------------------------------------------------------------
go
create trigger fk_orders_customers_on_update_cascade -- cascade, customers <-> orders
on orders
after delete
as
--if update(CustomerID)
begin
	if(select count(*) from Customers inner join deleted on Customers.CustomerID = deleted.CustomerID) <= 0
	begin
		print 'no modification or update on rows. rollback transaction. (fk_orders_customers_on_update_cascade)';
		rollback transaction;
	end
	else
	begin
		delete from Customers where CustomerID in (select CustomerID from deleted);
		print 'rows modified successfully. (fk_orders_customers_on_update_cascade)';
	end
end

go
create trigger fk_orders_shippers_on_update_cascade -- cascade, shippers <-> orders
on orders
after delete
as
--if update(ShipVia)
begin
	if(select count(*) from Shippers inner join deleted on Shippers.ShipperID = deleted.ShipVia) <= 0
	begin
		print 'no modification or update on rows. rollback transaction. (fk_orders_shippers_on_update_cascade)';
		rollback transaction;
	end
	else
	begin
		delete from Shippers where ShipperID in (select shipvia from deleted);
		print 'rows modified successfully. (fk_orders_shippers_on_update_cascade)';
	end
end
-- Q3.3---------------------------------------------------------------------------------------------------------------
go
USE Northwind;  
GO  
ALTER TABLE dbo.Orders DROP CONSTRAINT FK_Orders_Shippers;   
ALTER TABLE dbo.Orders DROP CONSTRAINT FK_Orders_Employees;   
ALTER TABLE dbo.Orders DROP CONSTRAINT FK_Orders_Customers;   
ALTER TABLE dbo.[Order Details] DROP CONSTRAINT FK_Order_Details_Orders;   
GO 

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