
-- function
create function compute_cost
(@percent int = 10) -- param
returns decimal -- return type
as
begin
	declare @additional_cost decimal
	declare @sum_budget decimal
	select @sum_budget = sum(budget) from project
	set @additional_cost = @sum_budget * @percent / 100
	return @additional_cost; -- return
end;
declare @additonal_cost1 decimal
@additonal_cost1 = 0
set @additonal_cost1 = dbo.compute_cost(6)
print @additional_cost1;

-- function to return list of employees working on a project
create function employee_in_project
(@prno varchar(5))
return @tab1 table (fname varchar(50), lname varchar(50))
as
begin
	insert into @tab1
	selectemp_fname, emp_lname from employee
	join works_on on employee.emp_no = works_on.emp_no
	where project_no = @prno
	
	return
end;
select * from dbo.employee_in_project('p2') where fname like '%a%';

print datediff(month, '2019-05-12', '2020-09-27');




