
-- reuse some code and change stuff around for a single order
create procedure sp_ExpediteOrdersByOrderId
@orderId varchar (50)
as
begin
	drop table if exists #noUpdates;
	select * into #noUpdates from orders where DATEDIFF(DAY, orderdate, ShippedDate) < 10 and OrderID = @orderId;
	drop table if exists #yesUpdates;
	select * into #yesUpdates from orders where DATEDIFF(DAY, orderdate, ShippedDate) > 10 and OrderID = @orderId;

	update orders set ShippedDate = DATEADD(WEEK, -1, ShippedDate) where OrderID in (select OrderID from #yesUpdates); -- update the shipped date
	update orders set Freight = Freight * 2 where OrderID in (select OrderID from #yesUpdates); -- charge double for the needy orders

	select * from #noUpdates;
end;
execute sp_ExpediteOrdersByOrderId '10253';

-- after fresh db restore
/*

OrderID	CustomerID	EmployeeID	OrderDate	RequiredDate	ShippedDate	ShipVia	Freight	ShipName	ShipAddress	ShipCity	ShipRegion	ShipPostalCode	ShipCountry
10253	HANAR	3	1996-07-10 00:00:00.000	1996-07-24 00:00:00.000	1996-07-16 00:00:00.000	2	58.17	Hanari Carnes	Rua do Paço, 67	Rio de Janeiro	RJ	05454-876	Brazil

*/
