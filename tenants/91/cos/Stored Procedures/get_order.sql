CREATE PROCEDURE [cos_cus].[get_order]
(
	@orderId INT = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	SELECT orderId AS ORDER_ID,
	itemNo AS ITEM_NO,
	locationNo AS LOCATION_NO,
	vendorNo AS ORDERFROM_LOCATION_NO,
	'' AS COLOR,
	'' AS SIZE,
	'' AS STYLE,
	1 AS USER_ID,
	quantity AS UNIT_QTY_CHG,
	estimatedDeliveryDateOrderLine AS EST_DELIVERY_DATE,
	orderType AS ORDER_TYPE
	FROM dbo.order_transfer
	WHERE orderId = @orderId
 

END

