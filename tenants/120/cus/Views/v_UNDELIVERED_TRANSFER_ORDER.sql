




    CREATE VIEW [cus].[v_UNDELIVERED_TRANSFER_ORDER] AS
	   SELECT
		CAST(CONCAT(o.[DocEntry],'-',ol.[LineNum],'-',ol.[WhsCode]) AS NVARCHAR(128))		AS [TRANSFER_ORDER_NO],
		CAST(ol.[ItemCode] AS NVARCHAR(255))												AS [ITEM_NO],
		CAST(ol.[WhsCode] AS NVARCHAR(255))													AS [LOCATION_NO],
		CAST(ol.[FromWhsCod] AS NVARCHAR(255))												AS [ORDER_FROM_LOCATION_NO],
		CAST(SUM(ol.OpenInvQty) AS DECIMAL(18,4))											AS [QUANTITY],
		CAST(IIF(ol.ShipDate < GETDATE(), GETDATE(), ol.ShipDate) AS DATE)					AS [DELIVERY_DATE]
	FROM
		[cus].WTQ1 ol
		JOIN [cus].OWTQ o ON o.DocEntry = ol.DocEntry
	WHERE
		ol.LineStatus = 'O' -- 'O' = Open, 'C' = Closed
		--AND CAST(o.DocDueDate AS DATE) >= CAST(GETDATE() AS DATE)
		 
	GROUP BY
		o.DocEntry, ol.ItemCode, IIF(ol.ShipDate < GETDATE(), GETDATE(), ol.ShipDate), ol.WhsCode, ol.[FromWhsCod], ol.LineNum
	HAVING SUM(ol.OpenInvQty) > 0

