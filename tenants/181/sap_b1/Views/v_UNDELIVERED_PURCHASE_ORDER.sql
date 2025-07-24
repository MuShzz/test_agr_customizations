CREATE VIEW [sap_b1_cus].[v_UNDELIVERED_PURCHASE_ORDER] AS
       SELECT
            CAST(p.DocNum AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
            CAST(pl.ItemCode AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(pl.WhsCode AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(pl.ShipDate AS DATE) AS [DELIVERY_DATE],
            CAST(SUM(pl.OpenInvQty) AS DECIMAL(18, 4)) AS [QUANTITY]
       FROM
			[sap_b1].POR1 pl
			INNER JOIN [sap_b1].OPOR p ON p.DocEntry = pl.DocEntry
		WHERE
			pl.LineStatus = 'O' AND pl.ItemCode IS NOT NULL AND pl.WhsCode IS NOT NULL
		GROUP BY
			p.DocNum, pl.ItemCode, pl.ShipDate, pl.WhsCode

			UNION ALL
			
		SELECT
			CAST(opch.DocNum AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
			CAST(pch.ItemCode AS NVARCHAR(255)) AS [ITEM_NO],
			CAST(pch.WhsCode AS NVARCHAR(255)) AS [LOCATION_NO],
			CAST(pch.[ShipDate] AS DATE) AS [DELIVERY_DATE],
			CAST(SUM(pch.[OpenQty]) AS DECIMAL(18, 4)) AS [QUANTITY]
		FROM
			[sap_b1_cus].OPCH opch  
		INNER JOIN 
			[sap_b1_cus].PCH1 pch ON opch.[DocEntry] = pch.[DocEntry]
		WHERE
			opch.[CANCELED] ='N' and  opch.[isIns] = 'Y'  and  opch.[InvntSttus] ='O'
		GROUP BY 
			opch.DocNum, pch.ItemCode, pch.WhsCode, pch.[ShipDate]

