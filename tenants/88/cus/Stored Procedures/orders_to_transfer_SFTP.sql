
-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Get erp endpoints
--
-- 2023.07.04.TO   Created
-- ===============================================================================
CREATE PROCEDURE [cus].[orders_to_transfer_SFTP]
(
@orderId INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT orderId, status, locationNo,/* locationName,*/ vendorNo, /*vendorName,*/ orderType, CAST(CAST(estimatedDeliveryDate AS DATE) AS NVARCHAR(10)) as estimatedDeliveryDate, 
	CAST(CAST(createdAt AS DATE) AS NVARCHAR(10)) AS createdAt, itemNo,
	/*itemName,*/ quantity, quantityInPurchaseUnits, CAST(CAST(estimatedDeliveryDateOrderLine AS DATE) AS NVARCHAR(10)) AS estimatedDeliveryDateOrderLine--, userEmail AS owner
	--orderId, ''''+status+'''',''''+locationNo+'''',''''+locationName+'''',''''+vendorNo+'''',''''+vendorName+'''',''''+orderType+'''', CAST(estimatedDeliveryDate as date)
	FROM dbo.order_transfer
	WHERE quantity > 0 AND orderId = @orderId

END

