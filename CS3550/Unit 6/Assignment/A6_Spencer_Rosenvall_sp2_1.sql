create procedure sp_ExpediteOrdersByCustomerId
@customerid varchar (50)
as
begin
	drop table if exists #noUpdates;
	select * into #noUpdates from orders where DATEDIFF(DAY, orderdate, ShippedDate) < 10 and CustomerID = @customerid;
	drop table if exists #yesUpdates;
	select * into #yesUpdates from orders where DATEDIFF(DAY, orderdate, ShippedDate) > 10 and CustomerID = @customerid;

	update orders set ShippedDate = DATEADD(WEEK, -1, ShippedDate) where OrderID in (select OrderID from #yesUpdates); -- update the shipped date
	update orders set Freight = Freight * 2 where OrderID in (select OrderID from #yesUpdates); -- charge double for the needy orders

	select * from #noUpdates;
end;
execute sp_ExpediteOrdersByCustomerId 'HANAR';

-- after fresh db restore
/*

OrderID	CustomerID	EmployeeID	OrderDate	RequiredDate	ShippedDate	ShipVia	Freight	ShipName	ShipAddress	ShipCity	ShipRegion	ShipPostalCode	ShipCountry
10250	HANAR	4	1996-07-08 00:00:00.000	1996-08-05 00:00:00.000	1996-07-12 00:00:00.000	2	65.83	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10253	HANAR	3	1996-07-10 00:00:00.000	1996-07-24 00:00:00.000	1996-07-16 00:00:00.000	2	58.17	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10645	HANAR	4	1997-08-26 00:00:00.000	1997-09-23 00:00:00.000	1997-09-02 00:00:00.000	1	12.41	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10690	HANAR	1	1997-10-02 00:00:00.000	1997-10-30 00:00:00.000	1997-10-03 00:00:00.000	1	15.80	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10770	HANAR	8	1997-12-09 00:00:00.000	1998-01-06 00:00:00.000	1997-12-17 00:00:00.000	3	5.32	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10783	HANAR	4	1997-12-18 00:00:00.000	1998-01-15 00:00:00.000	1997-12-19 00:00:00.000	2	124.98	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10903	HANAR	3	1998-02-24 00:00:00.000	1998-03-24 00:00:00.000	1998-03-04 00:00:00.000	3	36.71	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10922	HANAR	5	1998-03-03 00:00:00.000	1998-03-31 00:00:00.000	1998-03-05 00:00:00.000	3	62.74	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10925	HANAR	3	1998-03-04 00:00:00.000	1998-04-01 00:00:00.000	1998-03-13 00:00:00.000	1	2.27	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
10981	HANAR	1	1998-03-27 00:00:00.000	1998-04-24 00:00:00.000	1998-04-02 00:00:00.000	2	193.37	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil
11052	HANAR	3	1998-04-27 00:00:00.000	1998-05-25 00:00:00.000	1998-05-01 00:00:00.000	1	67.26	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil

*/