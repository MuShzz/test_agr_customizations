
-- ===============================================================================
-- Author:      José Santos and a touch of José Mendes
-- Description: Get order transfer body for epicor
--
-- 2024.10.30.TO   Created
-- ===============================================================================

CREATE PROCEDURE [cus].[get_transfer_lines_body]
(
@OrderId INT = NULL,
@TFOrdNum NVARCHAR(50) = NULL,
@OrderType NVARCHAR(50) = NULL
)
AS

IF @OrderType = 'transfer'
BEGIN
	WITH 
	order_to_transfer AS
	(
	SELECT 
		TFOrdNum = @TFOrdNum,
		orderId AS orderId,
		vendorNo AS Plant ,
		locationNo AS ToPlant,
		CAST(ROW_NUMBER() OVER (ORDER BY ot.itemNo) AS INT) AS TFOrdLine,
		CAST(GETDATE() AS DATE) AS RequestDate,
		CAST(estimatedDeliveryDate AS DATE) AS NeedByDate,
		itemNo AS PartNum,
		CAST(quantity AS DECIMAL(18,4)) AS SellingQTY
		FROM dbo.order_transfer ot
		WHERE quantity > 0 AND orderId = @OrderId
	)
	SELECT  ot.TFOrdLine,
	(SELECT 
		CAST( ot.TFOrdNum AS NVARCHAR(50)) AS TFOrdNum,
		TFOrdLine,
		ot.PartNum,
		ot.Plant,
		ot.ToPlant,
		ot.NeedByDate,
		p.PUM AS SellingQtyUOM,
		p.IUM AS OurStockQtyUOM,
		ot.SellingQTY
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS  order_lines_body FROM order_to_transfer ot JOIN cus.Part p ON ot.PartNum = p.PartNum
END

ELSE IF @OrderType = 'purchase'

BEGIN
	 
	SELECT 
		CAST(NULL AS NVARCHAR(50)) AS order_lines_body,
		CAST(NULL AS NVARCHAR(50)) AS TFOrdLine
		WHERE 1 = 0
END

