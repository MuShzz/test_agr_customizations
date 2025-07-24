
CREATE VIEW [bc_rest_cus].[v_PURCHASE_ORDER_RECEIVED_HISTORY] AS
	SELECT
		CAST(prh.[OrderNo] AS VARCHAR(128))				AS [PURCHASE_ORDER_NO],
		CAST(NULL  AS VARCHAR(128))						AS [AGR_ORDER_ID],
		CAST(prl.No  AS NVARCHAR(255))					AS [ITEM_NO],
		CAST(IIF(prh.[LocationCode]='','WEB','')  AS NVARCHAR(255))		AS [LOCATION_NO], -- Always empty in this tenant_225_stg?
		CAST(prl.BuyfromVendorNo  AS NVARCHAR(255))		AS [VENDOR_NO],
		CAST(prh.OrderDate  AS DATE)					AS [ORDER_DATE],
		CAST(ile.PostingDate AS DATE)					AS [DELIVERY_DATE],
		CAST(SUM(prl.Quantity) AS DECIMAL(18,4))		AS [ORDERED_QTY],
		CAST(SUM(ile.Quantity) AS DECIMAL(18,4))		AS [DELIVERED_QTY],
		CAST(NULL AS DECIMAL(18, 4))					AS [PURCHASE_PRICE],
	    CAST(NULL AS INT)								AS [LEAD_TIME_CALCULATION_DAYS]
	FROM bc_rest_cus.purch_rcpt_header prh	
			 INNER JOIN bc_rest.purch_rcpt_line prl ON prl.DocumentNo = prh.No
			 LEFT JOIN bc_rest.item_ledger_entry ile
					   ON ile.DocumentNo = prh.No  AND ile.ItemNo = prl.No --AND ile.LocationCode = prh.LocationCode
	WHERE LEN(prh.OrderNo) > 1 AND ile.PostingDate IS NOT NULL -- Remove empty lines	
	GROUP BY prh.OrderNo, prl.No, prh.LocationCode, prl.BuyfromVendorNo, prh.OrderDate, ile.PostingDate


