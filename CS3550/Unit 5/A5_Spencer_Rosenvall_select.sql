/* Spencer Rosenvall
   Assignment 5 DML
   CS 3550, Prof Christi 
   Question 1			*/

-- 1.1.1, 1,1,2
SELECT DISTINCT c.CompanyName, c.ContactName 
FROM Customers c 
JOIN Orders o on c.CustomerID = o.CustomerID 
JOIN [Order Details] d on o.OrderID = d.OrderID 
JOIN Products p on d.ProductID = p.ProductID
WHERE p.ProductName = 'Chai' or p.ProductName = 'Chang'
ORDER BY c.CompanyName;

-- 1.2, 1.2.2
SELECT ShipCountry, COUNT(ShipCountry) AS [Count] 
FROM Orders 
GROUP BY ShipCountry;

-- 1.3, 1.3.2
SELECT DISTINCT ShipCountry 
FROM Orders
GROUP BY ShipCountry 
HAVING COUNT(*) > 5;

-- 1.4.1, 1.4.2
SELECT e.FirstName AS [First Name], e.LastName AS [Last Name], COUNT(o.EmployeeID) AS [Count]
FROM Orders o JOIN Employees e on o.EmployeeID = e.EmployeeID
GROUP BY o.EmployeeID, e.FirstName, e.LastName
HAVING COUNT(*) > 50;

-- 1.5.1, 1.5.2
SELECT DISTINCT e.FirstName, e.LastName, e.Title, e.Address, e.City, e.PostalCode AS [Zip Code] 
FROM Employees e
JOIN EmployeeTerritories et on et.EmployeeID = e.EmployeeID
LEFT OUTER JOIN Territories t on t.TerritoryID = et.TerritoryID
LEFT OUTER JOIN Region r on t.RegionID = r.RegionID
WHERE r.RegionDescription = 'Western'
ORDER BY FirstName;

-- 1.6.1, 1.6.2
SELECT DISTINCT p.ProductName FROM Products p
JOIN [Order Details] d ON p.ProductID = d.ProductID
JOIN Orders o on o.OrderID = d.OrderID
JOIN Shippers s on o.ShipVia = s.ShipperID
JOIN Employees e on o.EmployeeID = e.EmployeeID
WHERE s.CompanyName = 'Federal Shipping'
AND e.LastName LIKE 'L%';

-- 1.7.1, 1.7.2
SELECT p.ProductName, s.CompanyName 
FROM Products p
JOIN Suppliers s on p.SupplierID = s.SupplierID
JOIN Categories c on p.CategoryID= c.CategoryID
WHERE c.CategoryName = 'Beverages';

-- 1.8.1, 1.8.2
SELECT e.LastName, e.FirstName
FROM Employees e
WHERE e.ReportsTo IN (SELECT EmployeeID FROM Employees WHERE Title = 'Vice President, Sales')
ORDER BY e.LastName;
