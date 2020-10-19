-- pivot example 1 ---------------------------------------------------------------------------------------------------------------------------------------
use Northwind;
select * from  -- select
(
	select o.ShipVia, c.CompanyName from Customers c join Orders o on o.CustomerID = c.CustomerID -- base query
) as ShipViaTable -- into someTable
pivot -- pivot
(
	count(CompanyName) for ShipVia in ([1], [2], [3])
) as ShipViaPivotTable;
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- pivot example 2 ----------------------------------------------------------------------------------------------------------------------------------------
use Northwind;
select * from
(
	select o.ShipVia, c.City, c.CustomerID from Customers c join Orders o on o.CustomerID = c.CustomerID -- base query
) as ShipViaTable
pivot
(
	count(CustomerID) for ShipVia in ([1], [2], [3])
) as ShipViaPivotTable order by City;
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- pivot example 3 ----------------------------------------------------------------------------------------------------------------------------------------
use Northwind;
select * from
(
	select ShipCity, s.CompanyName as [ShipperName], o.Freight from Customers c 
	join Orders o on c.CustomerID = o.CustomerID
	join Shippers s on s.ShipperID = o.ShipVia  -- base query
) as ShipperTable
pivot
(
	avg(Freight) for ShipperName in ([Federal Shipping], [Speedy Express], [United Package])
) as ShipperPivotTable order by ShipCity;
-----------------------------------------------------------------------------------------------------------------------------------------------------------
