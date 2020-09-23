/* Spencer Rosenvall
   Assignment 5 DML
   CS 3550, Prof Christi 
   Question 2			*/

-- 2.1.1 Add 2 new Products
DECLARE @sid int, @cid int, @qpu nvarchar(20), @up money, @uis smallint, @uoo smallint, @rl smallint,  @d bit
SET @sid = (SELECT TOP 1 SupplierID FROM Suppliers)
SET @cid = (SELECT TOP 1 CategoryID FROM Categories)
SET @qpu = (SELECT TOP 1 QuantityPerUnit FROM Products)
SET @up = (SELECT TOP 1 UnitPrice FROM Products)
SET @uis = (SELECT TOP 1 UnitsInStock FROM Products)
SET @uoo = (SELECT TOP 1 UnitsOnOrder FROM Products)
SET @rl = (SELECT TOP 1 ReorderLevel FROM Products)
SET @d = (SELECT TOP 1 Discontinued FROM Products)

INSERT INTO Products (ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued) 
VALUES ('Test', @sid, @cid, @qpu, @up, @uis, @uoo, @rl, @d), ('Test2', @sid, @cid, @qpu, @up, @uis, @uoo, @rl, @d);

-- 2.1.2 Add 4 Orders
DECLARE @oid1 int, @oid2 int, @oid3 int, @oid4 int

INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipPostalCode, ShipCountry)
SELECT TOP 1 CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipPostalCode, ShipCountry FROM Orders;
SET @oid1 = (SELECT TOP 1 OrderID FROM Orders ORDER BY OrderID DESC);

INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipPostalCode, ShipCountry)
SELECT TOP 1 CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipPostalCode, ShipCountry FROM Orders;
SET @oid2 = (SELECT TOP 1 OrderID FROM Orders ORDER BY OrderID DESC);

INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipPostalCode, ShipCountry)
SELECT TOP 1 CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipPostalCode, ShipCountry FROM Orders;
SET @oid3 = (SELECT TOP 1 OrderID FROM Orders ORDER BY OrderID DESC);

INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipPostalCode, ShipCountry)
SELECT TOP 1 CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipPostalCode, ShipCountry FROM Orders;
SET @oid4 = (SELECT TOP 1 OrderID FROM Orders ORDER BY OrderID DESC);

-- 2.1.3 Add 4 respective OrderDetails, let's add 2 for each Product
INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount) VALUES (@oid1,(SELECT ProductId FROM Products WHERE ProductName = 'Test'), @up, 5, 0);
INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount) VALUES (@oid2,(SELECT ProductId FROM Products WHERE ProductName = 'Test'), @up, 5, 0);
INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount) VALUES (@oid3,(SELECT ProductId FROM Products WHERE ProductName = 'Test2'), @up, 5, 0);
INSERT INTO [Order Details] (OrderID, ProductID, UnitPrice, Quantity, Discount) VALUES (@oid4,(SELECT ProductId FROM Products WHERE ProductName = 'Test2'), @up, 5, 0);

-- 2.2.1 & 2.2.2
UPDATE [Order Details] SET Discount = 0.10 WHERE (UnitPrice * Quantity > 20);

-- 2.3,1 & 2.3.2
DELETE FROM [Order Details] WHERE OrderID IN (SELECT TOP 4 OrderID FROM [Order Details] ORDER BY OrderID DESC);
DELETE FROM Orders WHERE OrderID IN (SELECT TOP 4 OrderID FROM Orders ORDER BY OrderID DESC);
DELETE FROM Products WHERE ProductID IN (SELECT TOP 2 ProductId FROM Products ORDER BY ProductID DESC);

-- 2.4.1
-- I'm really not sure what you meant by use territories and not the ids so I used an [IN + Subquery] instead of simply saying WHERE RegionID = 1
UPDATE Territories SET RegionID = 2 WHERE TerritoryDescription IN (SELECT DISTINCT TerritoryDescription FROM Territories WHERE RegionID = 1) 

-- 2.4.2
DELETE FROM Region WHERE RegionDescription = 'Eastern';