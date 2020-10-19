-- cursor example 1 --------------------------------------------------------------------------------------------------------------------------------------------------
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
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------------------------------------------------