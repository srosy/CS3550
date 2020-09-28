create function num_employees_by_region
(@region nvarchar(50))
returns decimal -- return type
as
begin
	return(select count(et.EmployeeID) from EmployeeTerritories et 
		join Territories t on et.TerritoryID = t.TerritoryID 
			join Region r on r.RegionID = t.RegionID
				where r.RegionDescription = @region)
end;

print dbo.num_employees_by_region('eastern');

-- after fresh db restore
/*

	19

*/