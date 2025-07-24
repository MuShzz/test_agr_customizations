





-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

CREATE VIEW [cus].[v_SALES_HISTORY] AS
WITH sales_union AS (
			
			-- pay and take (Invoice) sales
			SELECT
				CAST(ol.ItemCode AS NVARCHAR(255))										AS ITEM_NO,
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
				END AS [LOCATION_NO], -- [iVend ID]
				CAST(o.DocDate AS DATE)												AS [DATE],
				CONVERT(VARCHAR, CAST(o.DocDate AS DATE), 112)							AS [DATE_INT],
				SUM(CAST(ol.Quantity AS DECIMAL(18,4)))									AS SALE
			FROM
				[cus].INV1 ol
			JOIN [cus].OINV o ON o.DocEntry = ol.DocEntry
			WHERE o.DocDate IS NOT NULL
			  AND ol.BaseType NOT IN (15,17)
			  -- AND o.CardCode IN ('BL-C00000018' ,'PAY0001', 'PAY0002', 'PAY0009', 'PAY0011', 'PAY0014', 'PAY0023')
			  
			
			GROUP BY
				ol.ItemCode, ol.WhsCode, o.DocDate,
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
			HAVING SUM(ol.Quantity) > 0

			UNION ALL

			-- Special Order (Closed and Open Sales Orders)
			SELECT 
				CAST(ol.ItemCode AS NVARCHAR(255))										AS ITEM_NO,
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
				END AS [LOCATION_NO], -- [iVend ID]
				CAST(o.DocDate AS DATE)												AS [DATE],
				CONVERT(VARCHAR, CAST(o.DocDate AS DATE), 112)							AS [DATE_INT],
				SUM(CAST(ol.Quantity AS DECIMAL(18,4)))									AS SALE
			FROM
				[cus].RDR1 ol
				JOIN [cus].ORDR o ON o.DocEntry = ol.DocEntry
			WHERE
				--ol.LineStatus = 'C'AND 
			 ISNULL(o.Canceled,'N') <> 'Y'
			 AND o.DocDate IS NOT NULL
			GROUP BY
				ol.ItemCode, ol.WhsCode, o.DocDate,
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
				END -- [iVend ID]
			HAVING SUM(ol.Quantity) > 0
			)
	 SELECT CAST(CONCAT(sh.[DATE_INT], 100000000 + (ROW_NUMBER() OVER (PARTITION BY [DATE] ORDER BY [DATE]))) AS BIGINT) AS [TRANSACTION_ID],
		    sh.[ITEM_NO],
			sh.[LOCATION_NO],
			sh.[DATE],
			sh.[SALE],
			CAST('' AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST('' AS NVARCHAR(255)) AS [REFERENCE_NO],
            CAST(0 AS BIT) AS [IS_EXCLUDED]
	   FROM sales_union sh
	   WHERE sh.[LOCATION_NO] IS NOT NULL


