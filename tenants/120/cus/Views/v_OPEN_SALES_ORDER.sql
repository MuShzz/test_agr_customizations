




-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

    CREATE VIEW [cus].[v_OPEN_SALES_ORDER] AS
       SELECT
            CAST(CONCAT(o.DocEntry,'-',ol.LineNum,'-',ol.WhsCode) AS NVARCHAR(128)) AS [SALES_ORDER_NO],
            CAST(ol.ItemCode AS NVARCHAR(255)) AS [ITEM_NO],
            CASE WHEN o.U_CXS_TRID LIKE '%-OUT' THEN 'WB'		-- Outlet 
				WHEN o.U_CXS_TRID LIKE '%-SFD' THEN 'NBL'		-- Sandyford
				WHEN o.U_CXS_TRID LIKE '%-AIR' THEN 'NSW'		-- Airside 
				WHEN o.U_CXS_TRID LIKE '%-WX'  THEN 'NRL'		-- Wexford
				WHEN o.U_CXS_TRID LIKE '%-NR'  THEN 'NR'		-- New Ross 
				WHEN o.U_CXS_TRID LIKE '%-NB'  THEN 'NB'		-- Newbridge
				WHEN o.U_CXS_TRID LIKE '%-BL'  THEN 'SPECIALS' -- Blanch
				WHEN o.U_CXS_TRID LIKE '%-CST' THEN 'CST'		-- Customer Service Team                                                                               
				WHEN ISNULL(o.[U_TRC_Ecom_WebId],'') <> '' THEN 'GEN'
				ELSE ''
		END																		AS [LOCATION_NO],
            CAST(SUM(ol.OpenInvQty) AS DECIMAL(18, 4)) AS [QUANTITY],
            CAST(o.CardCode AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(IIF(ol.ShipDate < GETDATE(), GETDATE(), ol.ShipDatE) AS DATE) AS [DELIVERY_DATE]
       FROM
			[cus].RDR1 ol
			JOIN [cus].ORDR o ON o.DocEntry = ol.DocEntry
		WHERE
			ol.LineStatus = 'O' -- 'O' = Open, 'C' = Closed
			--AND CAST(o.DocDueDate AS DATE) >= CAST(GETDATE() AS DATE)
		 
		GROUP BY
			o.DocEntry, o.CardCode, ol.ItemCode, IIF(ol.ShipDate < GETDATE(), GETDATE(), ol.ShipDate), ol.WhsCode, ol.LineNum,
		CASE WHEN o.U_CXS_TRID LIKE '%-OUT' THEN 'WB'		-- Outlet 
				WHEN o.U_CXS_TRID LIKE '%-SFD' THEN 'NBL'		-- Sandyford
				WHEN o.U_CXS_TRID LIKE '%-AIR' THEN 'NSW'		-- Airside 
				WHEN o.U_CXS_TRID LIKE '%-WX'  THEN 'NRL'		-- Wexford
				WHEN o.U_CXS_TRID LIKE '%-NR'  THEN 'NR'		-- New Ross 
				WHEN o.U_CXS_TRID LIKE '%-NB'  THEN 'NB'		-- Newbridge
				WHEN o.U_CXS_TRID LIKE '%-BL'  THEN 'SPECIALS' -- Blanch
				WHEN o.U_CXS_TRID LIKE '%-CST' THEN 'CST'		-- Customer Service Team                                                                               
				WHEN ISNULL(o.[U_TRC_Ecom_WebId],'') <> '' THEN 'GEN'
				ELSE ''
		END
	HAVING SUM(ol.OpenInvQty) > 0

