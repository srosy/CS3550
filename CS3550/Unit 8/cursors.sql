-- cursor example 1 ---------------------------------------------------------------------------------------------------------------------------------------
use sample;

declare @emp_no int;
declare @fname varchar(50);
declare @lname varchar(50);
declare @dept_no varchar(5);

declare employee_cursor cursor -- declare cursor
for select emp_no, emp_fname, emp_lname, dept_no from employee where dept_no in ('d1', 'd2', 'd3'); -- query for cursor to iterate through result set of
open employee_cursor -- open cursor
fetch next from employee_cursor into @emp_no, @fname, @lname, @dept_no; -- set currentRowCount = 0
while @@FETCH_STATUS = 0 -- while currentRowCount > rows.length
	begin
		print @fname + ' ' + @lname + ' ' + @dept_no;
		fetch next from employee_cursor into @emp_no, @fname, @lname, @dept_no; -- currentRowCount++
	end
close employee_cursor; -- close, then deallocate, or open back up to use same cursor for result set to continue doing work
deallocate employee_cursor; -- finally, deallocate. Cursor no longer exists.
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- cursor example 2 + function ---------------------------------------------------------------------------------------------------------------------------------------
use sample;
go
create function count_employee (@project_no varchar(10)) returns int
as
begin
	return (select count(*) from works_on where project_no = @project_no);
end
go
--declare @test_val int = dbo.count_employee('p1'); -- test function
--print @test_val;

go
use sample;
declare @pr_no varchar(20);
declare @pr_name varchar(20);

declare all_projects cursor for (select project_no, project_name from project);

open all_projects
fetch next from all_projects into @pr_no, @pr_name
while @@FETCH_STATUS = 0
begin
	print  @pr_no + ' ' + @pr_name;
	declare @employee_count int = dbo.count_employee(@pr_no);
	if (@pr_no = 'p2')
	begin
		print (@employee_count + 10);
	end
	else
	begin
		print (@employee_count + 5);
	end
	fetch next from all_projects into @pr_no, @pr_name -- i++
end
close all_projects; 
deallocate all_projects; 
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Class Exercise 1 with SP and Trigger  ------------------------------------------------------------------------------------------------------------------
use Northwind;
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
declare @categoryId int;
declare @categoryName nvarchar(15);
declare category_discount cursor for (select CategoryID, CategoryName from Categories);

declare @currentMonth int = month(getdate());
print 'Current month # is: ' + cast(@currentMonth as nvarchar(2));

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
-----------------------------------------------------------------------------------------------------------------------------------------------------------
