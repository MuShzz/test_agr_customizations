




    CREATE VIEW [cus].[v_OPEN_SALES_ORDER] AS
       SELECT
            CAST(CONCAT(o.DocEntry,'-',ol.LineNum,'-',ol.WhsCode) AS NVARCHAR(128)) AS [SALES_ORDER_NO],
            CAST(ol.ItemCode AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(ol.WhsCode AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(SUM(ol.OpenInvQty) AS DECIMAL(18, 4)) AS [QUANTITY],
            CAST(o.CardCode AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(ol.ShipDate AS DATE) AS [DELIVERY_DATE]
       FROM
			[cus].RDR1 ol
			JOIN [cus].ORDR o ON o.DocEntry = ol.DocEntry
		WHERE
			ol.LineStatus = 'O' -- 'O' = Open, 'C' = Closed
			--AND CAST(o.DocDueDate AS DATE) >= CAST(GETDATE() AS DATE)
		 
		GROUP BY
			o.DocEntry, ol.ItemCode, IIF(ol.ShipDate < GETDATE(), GETDATE(), ol.ShipDate), ol.WhsCode, ol.LineNum, o.CardCode,ol.ShipDate
		HAVING SUM(ol.OpenInvQty) > 0


