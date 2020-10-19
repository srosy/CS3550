-- Class Exercise Unsolved Problem (SP + Trigger)  ------------------------------------------------------------------------------------------------------------------
use Northwind;
go

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[sp_discountByCategory]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
DROP PROCEDURE dbo.sp_discountByCategory;
END

go
create procedure sp_discountByCategory
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
go
use Northwind;

select * from [Order Details]; -- show initial table with unchanged resultset 

declare @categoryId int;
declare @categoryName nvarchar(15);
declare category_discount cursor for (select CategoryID, CategoryName from Categories);

declare @currentMonth int = 5;-- month(getdate()); -- override current date since it's currently october and we'd like to update the data
print 'Current month # is: ' + cast(@currentMonth as nvarchar(2)); -- I wish it was june...

open category_discount;
fetch next from category_discount into @categoryId, @categoryName;
while @@FETCH_STATUS = 0
begin
	declare @shouldExecute bit = 0;

	if (@currentMonth in (11, 12)) -- nov & dec all categories get discounts
	begin
		set @shouldExecute = 1;
	end

	else if (@categoryId = 1) -- categoryId 1 gets discounts in jan
	begin
		if (@currentMonth = 1)
		begin
			set @shouldExecute = 1;
		end
	end

	else if (@categoryId = 2) -- categoryId 2 gets discounts feb-aug
	begin
		if (@currentMonth in (2, 3, 4, 5, 6, 7, 8))
		begin
			set @shouldExecute = 1;
		end
	end

	if (@shouldExecute = 1)
	begin
		print 'APPLIED discount to category: ' + @categoryName;
		execute sp_discountByCategory @category_name = @categoryName;
	end
	else
	begin
		print 'NO discount applied to category: ' + @categoryName; -- sept, oct
	end

	fetch next from category_discount into @categoryId, @categoryName;
end
close category_discount; 
deallocate category_discount; 

select * from [Order Details]; -- show final table with updated resultset 
-----------------------------------------------------------------------------------------------------------------------------------------------------------

/*********************** RESULTS ****************************************
OrderID	ProductID	UnitPrice	Quantity	Discount -- BEFORE (First 8)
10248	11			14.00		12			0
10248	42			9.80		10			0
10248	72			34.80		5			0
10249	14			18.60		9			0
10249	51			42.40		40			0
10250	41			7.70		10			0
10250	51			42.40		35			0.15
10250	65			16.80		15			0.15

OrderID	ProductID	UnitPrice	Quantity	Discount -- AFTER (First 8)
10248	11			14.00		12			0
10248	42			9.80		10			0
10248	72			34.80		5			0
10249	14			18.60		9			0
10249	51			42.40		40			0
10250	41			7.70		10			0.1
10250	51			42.40		35			0.3
10250	65			16.80		15			0.3


(2155 rows affected)
Current month # is: 5
NO discount applied to category: Beverages
APPLIED discount to category: Condiments

(216 rows affected)

(39 rows affected)

(52 rows affected)

(516 rows affected)
NO discount applied to category: Confections
NO discount applied to category: Dairy Products
NO discount applied to category: Grains/Cereals
NO discount applied to category: Meat/Poultry
NO discount applied to category: Produce
NO discount applied to category: Seafood

(2155 rows affected)

*************************************************************************/




