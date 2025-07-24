CREATE VIEW [cus].[v_stock_history] AS

	SELECT
		ROW_NUMBER() OVER (ORDER BY rcptnmbr ASC) AS [TRANSACTION_ID],
        CONCAT(RTRIM(itemnmbr), ' - ', [Company]) AS [ITEM_NO],
		[TRXLOCTN] AS [LOCATION_NO],
		DATERECD AS [DATE],
		SUM([QTYRECVD] - [QTYSOLD]) AS [STOCK_MOVE],
		NULL AS [STOCK_LEVEL]
	FROM [cus].[IV10200]
	GROUP BY rcptnmbr, itemnmbr, [TRXLOCTN], DATERECD, [Company]

