


-- ===============================================================================
-- Author:      José Santos
-- Description: Get order transfer body for epicor
--
-- 2024.10.30.TO   Created
-- ===============================================================================
CREATE PROCEDURE [cus].[get_transfer_header_body]
(
@OrderId INT = NULL
)
AS
BEGIN

	;WITH 
	order_to_transfer AS
	(
	SELECT 
		orderId AS orderId,
		vendorNo AS Plant ,
		locationNo AS ToPlant,
		CAST(GETDATE() AS DATE) AS RequestDate,
		CAST(estimatedDeliveryDate AS DATE) AS NeedByDate,
		itemNo AS PartNum,
		CAST(quantity AS DECIMAL(18,4)) AS SellingQTY
		FROM dbo.order_transfer ot
		WHERE quantity > 0 AND orderId = @OrderId
	)
	SELECT  
	(SELECT 
		ShipViaCode = 'DEF',
		Plant,
		ToPlant,
		RequestDate,
		NeedByDate
	FROM order_to_transfer
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS order_body



END


