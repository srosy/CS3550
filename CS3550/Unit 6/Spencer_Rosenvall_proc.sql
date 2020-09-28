-- first video
select * from Employee;
select * from Employee where dept_no = 'd3'

-- select all props from employee for emp# 2581
declare @emp_no int;
set @emp_no = 2581;
print @emp_no;
select * from employee where emp_no = @emp_no;

-- select all props from employee for ann jones
declare @emp_fname varchar (50);
declare @emp_lname varchar (50);
set @emp_fname = 'Ann';
set @emp_lname = 'Jones';
select * from employee where emp_fname = @emp_fname and emp_lname = @emp_lname;

-- find all departments located in seattle
declare @location varchar (50);
set @location = 'Seattle';
select * from department where location = @location;

-- if/else statement, example 8.1
declare @project_no varchar (10);
set @project_no = 'p1';
select count(*) from works_on where project_no = @project_no
if (select count(*) from works_on where project_no = @project_no) >= 4 print ' the number of employees in the project' + @project_no +' is 4 or more';
else select * from employee inner join works_on on employee.emp_no = works_on.emp_no where project_no = @project_no;

-- while loop, increase budget by 10 percent until n is reached
select sum(budget) from project;
while ((select sum(budget) from project) < 500000)
begin
	print 'here';
	update project set budget = budget * 1.1;
	if ((select max(budget) from project) > 240000)
		break;
	else
		continue;
end;
select sum(budget) from project;

-- try/catch, add three employees in a transactional way
begin try
	insert into employee values (111, 'Ann', 'Smith', 'd2');
	insert into employee values (111, 'Ann', 'Smith', 'd2');
	-- d4 dne, can't reference d4
	insert into employee values (111, 'Ann', 'Smith', 'd2');
	commit transaction -- if all are successfull, they actually get added. Transaction = an attempt to do everying in try block
end try
begin catch
	rollback
	print 'The transaction is rollbacked. None of the employees are added.'
end catch;

-- local temp table
create table #project_temp
(
	project_no varchar(5) not null,
	project_name varchar(50) not null
)
insert into #project_temp (project_no, project_name)(
	select project_no, project_name from project
); select * from #project_temp;

-- global temp table
create table ##project_temp -- ## creates global
(
	project_no varchar(5) not null,
	project_name varchar(50) not null
)
insert into ##project_temp (project_no, project_name)(
	select project_no, project_name from project
); select * from ##project_temp;

