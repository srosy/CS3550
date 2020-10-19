-- 3.1
use Northwind;
select * from
(
	select c.CategoryName, d.UnitPrice FROM Categories c 
	JOIN Products p on p.CategoryID = c.CategoryID
	JOIN [Order Details] d on d.ProductID = p.ProductID
	WHERE c.CategoryName IN ('Beverages', 'Condiments', 'Produce')  -- base query
) as CategoryPrice
pivot
(
	avg(UnitPrice) for CategoryName in ([Beverages], [Condiments], [Produce])
) as CategoryPricePivot;

-- 3.2
SELECT c.CategoryName AS [Category Name], 
AVG(d.UnitPrice) AS [Avg Unit Price] 
FROM Categories c 
JOIN Products p on p.CategoryID = c.CategoryID
JOIN [Order Details] d on d.ProductID = p.ProductID
WHERE c.CategoryName IN ('Beverages', 'Condiments', 'Produce')
GROUP BY c.CategoryName;
