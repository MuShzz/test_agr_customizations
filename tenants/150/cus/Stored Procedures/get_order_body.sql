CREATE PROCEDURE [cus].[get_order_body]
(
    @OrderId INT = 1001,
	@OrderType NVARCHAR(50) = purchase
)
AS
	
WITH order_to_transfer AS (
    SELECT 
        orderId,
        vendorNo,
        estimatedDeliveryDate AS DueDate,
        orderType AS OrderType,
        itemNo AS ProductCode,
        quantity AS Quantity,
		estimatedDeliveryDateOrderLine
    FROM dbo.order_transfer ot
    WHERE quantity > 0 AND orderId = @OrderId
)
SELECT (
    SELECT DISTINCT
		'AGR-'+CAST(ott.orderId AS NVARCHAR(255)) AS AlternateReference,
		DueDate = ott.DueDate,
        Supplier =  ott.vendorNo, 
        Branch = (
            SELECT 
                b.Code
            FROM cus.Branch b
            
        ),
        Items = (
            SELECT 
                ott.ProductCode AS Product,
                ott.Quantity,
				p.Description,
				p.[P_BranchInfo_STS.Costings.AverageCost] AS NetPrice,
                TaxRate = '01',
				ott.estimatedDeliveryDateOrderLine AS DueDate
            FROM order_to_transfer ott
            JOIN cus.ProductDetails p ON ott.ProductCode = p.[Code]
            FOR JSON PATH
        )
    FROM order_to_transfer ott
    JOIN cus.Vendor v ON v.Code = ott.vendorNo
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
) AS order_body;

