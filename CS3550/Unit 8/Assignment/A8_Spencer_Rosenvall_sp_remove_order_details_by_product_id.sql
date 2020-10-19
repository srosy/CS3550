-- Create the SP -------------------------------------------------------------------------------------------------------------------------------------------------
USE Northwind;
GO
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[sp_remove_order_details_by_product_id]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
DROP PROCEDURE dbo.sp_remove_order_details_by_product_id;
END
GO
CREATE PROCEDURE sp_remove_order_details_by_product_id
@product_id INT
AS
BEGIN
		-- remove order details with matching productId
		DELETE FROM [Order Details] WHERE ProductID = @product_id;
		PRINT  'Product ID[' + CAST(@product_id AS NVARCHAR(25)) + '] is discontinued.';
		Print 'Deleted all order details with ProductID: ' + CAST(@product_id AS NVARCHAR(25));
END;
------------------------------------------------------------------------------------------------------------------------------------------------------------------