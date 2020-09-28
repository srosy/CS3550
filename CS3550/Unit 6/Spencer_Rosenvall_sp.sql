
-- create stored procedure
create procedure sp_GetAllEmployeeList
as
begin
	select * from employee -- take care of business
end;
execute sp_GetAllEmployeeList;

-- create stored procedure with a parameter
create procedure sp_EmployeeByLocation
@location varchar (50) -- @name, type
as
begin
	select emp_fname, emp_lname from employee inner join department on employee.dept_no = department.dept_no
	where location = @location
end;
execute sp_EmployeeByLocation;

-- stored procedure with multiple parameters
create procedure sp_EmployeeByLocationAndJob
	@location varchar (50)
	@jobtitle varchar (50)
as
being
	select * from employee 
	join works_on on employee.emp_no = works_on.emp_no
	join department on department.dept_no = employee.dept_no
	where location = @location and job = @jobtitle
end

declare @location1 varchar (50);
declare @jobtitle1 varchar (50);
set @location1 = 'Seattle'
set @jobtitle1 = 'Analyst'
execute sp_EmployeeByLocationAndJob @location=@location1, @jobtitle1=@jobtitle1;

-- modify stored procedure
alter procedure sp_EmployeeByLocation
@location varchar (50) = 'Seattle' -- default if no param value is provided
as 
begin
	select emp_fname, emp_lname from employee inner join department on employee.dept_no = department.dept_no
	where location = @location
end;
execute sp_EmployeeByLocation;

-- stored procedure with output parameter
alter procedure sp_employeebyLocation
@location varchar (50) = 'Seattle',
@totalemp int OUTPUT -- output parameter
begin
	select emp_fname, emp_lname from employee inner join department on employee.dept_no = department.dept_no
	where location = @location

	-- set the output param
	select @totalemp = count (*) from employee inner join department on employee.dept_no = department.dept_no
	where location = 'Seattle'
end

declare @location1 varchar (50);
declare @totalemp1 int;
set @location1 = 'Seattle'
set @totalemp1 = 0
execute sp_EmployeeByLocation @location=@location1, @totalemp=@totalemp1 OUTPUT
print 'total employee: ' + STR(@totalemp1, 3);

-- example 8.7, stored procedure to increase budget
create procedure sp_IncreaseBudget
@percent int = 5
as
begin
	update project set budget = budget + budget * @percent / 100
end
execute sp_IncreaseBudget 6; -- increase the budget by 6%

-- example 8.8, stored procedure to update multiple tables
create procedure sp_ModifyEmpNo
@oldNo int, @newNo int
as
begin
	update employee set emp_no = @newNo where emp_no = @oldNo
	update works_on set emp_no = @newNo where emp_no = @oldNo
end
execute sp_ModifyEmpNo 9031, 8031;

-- stored procedure to delete from multiple tables
create procedure sp_DeleteEmp
@empNo int, @numProjects int output
as
begin
	select @numProjects = count(*) from works_on where emp_no = @empNo
	select works_on.project_no from works_on where emp_no = @empNo
	delete from works_on where emp_no = @empNo
	delete from employee where emp_no = @empNo
end
declare @noProjs int
set @noProjs = 0
execute sp_DeleteEmp 9031 @noProjs = @numProjects output
print @noProjs;