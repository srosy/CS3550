-- stored procedure for Q1
create procedure sp_MonthlyCategoryDiscount
@category_name varchar (50)
as
begin
	-- get the orderids by matching category;
	drop table if exists #orderIdsByCategory;
	select d.OrderId into #orderIdsByCategory from [Order Details] d join Products p on d.ProductID = p.ProductID where p.CategoryID = (select top 1 CategoryID from Categories where CategoryName = @category_name);

	-- update discount according to rules;
	update [Order Details] set Discount = discount + 0.05 where OrderID in (select * from #orderIdsByCategory) and UnitPrice * Quantity < 50;

	update [Order Details] set Discount = discount + 0.10 where OrderID in (select * from #orderIdsByCategory) and UnitPrice * Quantity >= 50 and UnitPrice * Quantity <= 100;

	update [Order Details] set Discount = discount + 0.15 where OrderID in (select * from #orderIdsByCategory) and UnitPrice * Quantity > 100;
end;
execute sp_MonthlyCategoryDiscount @category_name = 'beverages';

-- after fresh db restore
/*

(79 rows affected)

(102 rows affected)

(874 rows affected)

*/