

-- ===============================================================================
-- Author:     Bárbara Ferreira
-- Description: PURCHASE_ORDER_RECEIVED_HISTORY Data mapping from CUS
--
--  05.06.2025.BF   Created
-- ====================================================================================================

CREATE VIEW [cus].[v_PURCHASE_ORDER_RECEIVED_HISTORY] 
AS
	SELECT 
		CAST(prh.[OrderNo] AS VARCHAR(128))				                       AS [PURCHASE_ORDER_NO],
		CAST(NULL  AS VARCHAR(128))						                       AS [AGR_ORDER_ID],
		CAST(prl.No  AS NVARCHAR(255))					                       AS [ITEM_NO],
		CAST(ISNULL(prl.[LocationCode], ile.[LocationCode]) AS NVARCHAR(255))  AS [LOCATION_NO],
		CAST(prl.BuyfromVendorNo  AS NVARCHAR(255))		                       AS [VENDOR_NO],
		CAST(prh.OrderDate  AS DATE)					                       AS [ORDER_DATE],
		CAST(ile.PostingDate AS DATE)					                       AS [DELIVERY_DATE],
		CAST(SUM(prl.Quantity) AS DECIMAL(18,4))		                       AS [ORDERED_QTY],
		CAST(SUM(ile.Quantity) AS DECIMAL(18,4))		                       AS [DELIVERED_QTY],
		CAST(NULL AS DECIMAL(18, 4))										   AS [PURCHASE_PRICE],
	    CAST(NULL AS INT)													   AS [LEAD_TIME_CALCULATION_DAYS]
	FROM cus.purch_rcpt_header prh	
			 INNER JOIN cus.purch_rcpt_line prl ON prl.DocumentNo = prh.No
			 LEFT JOIN cus.item_ledger_entry ile
                ON ile.DocumentNo = prh.No AND ile.ItemNo = prl.No 
				AND (
                    prl.[LocationCode] =''
                    OR ile.[LocationCode] = prl.[LocationCode]
                    )
			INNER JOIN core.location_mapping_setup lms ON lms.locationNo=ISNULL(prl.[LocationCode], ile.[LocationCode])
	WHERE LEN(prh.OrderNo) > 1 AND ile.PostingDate IS NOT NULL	
	GROUP BY prh.OrderNo, prl.No, prl.LocationCode, prl.BuyfromVendorNo, prh.OrderDate, ile.PostingDate, ile.LocationCode


