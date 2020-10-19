-- Create & Execute the Cursor -----------------------------------------------------------------------------------------------------------------------------------
GO
DROP TABLE IF EXISTS #temp;
SELECT d.orderId INTO #temp FROM [Order Details] d WHERE d.ProductID IN (SELECT ProductID FROM Products WHERE Discontinued = 1) 
AND (SELECT Count(OrderID) FROM [Order Details] WHERE OrderID = d.OrderID ) = 1; -- only get the order ids for orders that only have order details for the single product ids

DECLARE @pid INT;
DECLARE discontinued_products CURSOR FOR (SELECT DISTINCT ProductID FROM [Order Details] WHERE ProductID IN (SELECT ProductID FROM Products WHERE Discontinued = 1));

OPEN discontinued_products
FETCH NEXT FROM discontinued_products INTO @pid
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC dbo.sp_remove_order_details_by_product_id @product_id = @pid
	FETCH NEXT FROM discontinued_products INTO @pid
END
CLOSE discontinued_products; 
DEALLOCATE discontinued_products; 
GO
--ALTER TABLE dbo.[Order Details] DROP CONSTRAINT FK_Order_Details_Orders;   
DELETE FROM Orders WHERE OrderID IN (SELECT distinct OrderID FROM #temp);
PRINT  'Deleted orders with matching orderIds from temp table.';
------------------------------------------------------------------------------------------------------------------------------------------------------------------
