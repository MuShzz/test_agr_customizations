




CREATE VIEW [ogl_cus].[v_STOCK_HISTORY]
AS

  SELECT
		ROW_NUMBER () OVER (ORDER BY trdate, depot,stcode ASC)					AS TRANSACTION_ID,
        CAST(stcode AS NVARCHAR(255)) 											AS ITEM_NO,
        CAST(depot AS NVARCHAR(255))											AS LOCATION_NO,
        CAST(trdate AS DATE)													AS [DATE],
        CAST(SUM(ISNULL(CAST(amnt AS DECIMAL(18,4)), 0)) AS DECIMAL(18,4))		AS STOCK_MOVE,
        CAST(NULL AS DECIMAL(18,4))												AS STOCK_LEVEL
    FROM [ogl].[STStockMovements]
	WHERE mtype <> 'CST'
	GROUP BY uniqueno, stcode, depot, trdate


