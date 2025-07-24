




-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Customer mapping from COS
--
--  12.03.2023.HMH   Created
-- ====================================================================================================
CREATE VIEW [cos_cus].[v_orders_to_transfer]
AS


	SELECT
		ot.orderId AS order_id,
		ot.itemNo AS item_no,
		ot.locationNo AS location_no,
		ot.vendorNo AS order_from_location_no,
		CASE
			WHEN ot.orderType = 'transfer' THEN (
				SELECT TOP 1 l2.NO
				FROM cos_cus.AGR_LOCATION l2
				INNER JOIN cos.AGR_STOCK_LEVEL sl2 
					ON l2.NO = sl2.LOCATION_NO
				WHERE sl2.ITEM_NO = ot.itemNo
				AND l2.STOCK_LOCATION_NO = '0259'
				ORDER BY sl2.STOCK_UNITS DESC
			)
			ELSE NULL
		END AS hilla_no,
		NULL AS user_id,
		quantity AS unit_qty_chg,
		CAST(estimatedDeliveryDateOrderLine AS DATE) AS est_delivery_date,
		orderType AS order_type
	FROM dbo.order_transfer ot
	WHERE ot.quantity > 0
	--WHERE status = 'unconfirmed';



	--SELECT
	--	orderId as order_id,
	--	itemNo as item_no,
	--	locationNo as location_no,
	--	vendorNo as order_from_location_no,
	--	CASE
	--		WHEN orderType = 'transfer' THEN (SELECT l.NO WHERE MAX(sl.STOCK_UNITS)
	--		ELSE NULL 
	--	END AS hilla_no
	--FROM dbo.order_transfer ot
	--LEFT JOIN cos_cus.AGR_LOCATION l on l.STOCK_LOCATION_NO = ot.locationNo
	--LEFT JOIN cos.AGR_STOCK_LEVEL sl on ot.itemNo = sl.ITEM_NO and l.NO = sl.LOCATION_NO
	



