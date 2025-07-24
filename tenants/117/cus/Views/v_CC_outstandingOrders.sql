
CREATE VIEW [cus].[v_CC_outstandingOrders]
AS

	WITH PurchaseOrders AS (
		SELECT
			pli.product_item_no,
			pli.location_no,
			'PO: ' + pol.purchase_order_no AS order_reference,
			SUM(pol.quantity) AS total_quantity,
			pol.delivery_date AS est_deliv_date,
			ISNULL(pol.expire_date, DATEFROMPARTS(2100, 1, 1)) AS expire_date
		FROM
			cus_bkp.v_PRODUCT_LOCATION_INFO pli
		LEFT JOIN
			cus_bkp.v_purchase_order_line pol ON pol.location_no = pli.location_no AND pol.product_item_no = pli.product_item_no
		GROUP BY
			pli.product_item_no, pli.location_no, pol.purchase_order_no, pol.delivery_date, pol.expire_date
	),

	TransferOrders AS (
		SELECT
			pli.product_item_no,
			pli.location_no,
			CAST('TO: ' + tol.transfer_order_no AS  NVARCHAR(MAX)) AS order_reference,
			SUM(tol.quantity) AS total_quantity,
			tol.delivery_date AS est_deliv_date,
			ISNULL(tol.expire_date, DATEFROMPARTS(2100, 1, 1)) AS expire_date
		FROM
			cus_bkp.v_PRODUCT_LOCATION_INFO pli
		LEFT JOIN
			cus_bkp.v_transfer_order_line tol ON tol.location_no = pli.location_no AND tol.product_item_no = pli.product_item_no
		GROUP BY
			pli.product_item_no, pli.location_no, tol.transfer_order_no, tol.delivery_date, tol.expire_date
	)

	SELECT
		pli.product_item_no,
		pli.location_no,
		CASE 
			WHEN STRING_AGG(po.order_reference, ', ') IS NULL OR STRING_AGG(po.order_reference, ', ') = '' 
				 THEN STRING_AGG(too.order_reference, ', ')
			WHEN STRING_AGG(too.order_reference, ', ') IS NULL OR STRING_AGG(too.order_reference, ', ') = '' 
				 THEN STRING_AGG(po.order_reference, ', ')
			ELSE CONCAT(STRING_AGG(po.order_reference, ', '), ', ', STRING_AGG(too.order_reference, ', '))
		END AS outstandingOrdersNo
	FROM
		cus_bkp.v_PRODUCT_LOCATION_INFO pli
	LEFT JOIN
		PurchaseOrders po ON pli.product_item_no = po.product_item_no AND pli.location_no = po.location_no
	LEFT JOIN
		TransferOrders too ON pli.product_item_no = too.product_item_no AND pli.location_no = too.location_no
	--WHERE 
	--	pli.product_item_no = '17150V-B'
	GROUP BY
		pli.product_item_no, pli.location_no;



