CREATE PROCEDURE [cus].[get_order_transfer_body]
(
@OrderId INT = NULL
)
AS
BEGIN
	;WITH
	order_to_transfer AS
	(
	SELECT 
		ot.orderId					AS ID ,
		ot.vendorNo					AS Supplier,
		ot.locationNo				AS Branch,
		ot.estimatedDeliveryDate	AS DueDate,
		ot.itemNo					AS Code_Product,
		ot.itemName					AS Description_Product,
		ot.quantity					AS Quantity,
		b.Description				AS BranchDescription,
		v.Name						AS SupplierName,
		'true'						AS CALC_AGRClosed
	FROM dbo.order_transfer ot
	INNER JOIN cus.Branch b ON ot.locationNo = b.Code
	INNER JOIN	cus.ProductDetails pd ON ot.itemNo = pd.Code
	INNER JOIN cus.Vendor v ON ot.vendorNo = v.Code
	),
	Product AS
	(
		SELECT 
		(
			SELECT 
				Code_Product AS Code,
				Description_Product AS Description
			FROM order_to_transfer
		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
		) AS Product
	),
	Items AS
	(
		SELECT 
		(
			SELECT 
				Product = JSON_QUERY((SELECT Product FROM Product),'$'),
				Quantity
			FROM order_to_transfer
			FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
		) AS Items
	),
	Supplier AS
	(
		SELECT 
		(
			SELECT 
				Supplier AS [Code],
				SupplierName AS [Name] 
			FROM order_to_transfer
			FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
		) AS Supplier
	),
	Branch AS
	(
		SELECT
		(
			SELECT 
				Branch AS [Code],
				BranchDescription AS [Description] 
			FROM order_to_transfer
			FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
		) AS Branch
	)
	SELECT  
	(
		SELECT DISTINCT
			DueDate,
			Supplier = JSON_QUERY((SELECT Supplier FROM	Supplier),'$'),
			Branch = JSON_QUERY((SELECT Branch FROM	Branch),'$'),
			Items = JSON_QUERY('[' + (SELECT Items FROM Items) + ']','$'),
			CALC_AGRClosed
		FROM order_to_transfer
		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
	) AS order_body


END

