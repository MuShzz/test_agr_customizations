
CREATE VIEW [ogl_cus].[v_stock_history]
AS
	WITH ItemLocationDates AS (
		SELECT 
			sm.stcode,
			sm.depot,
			dt.[date],
			MAX(sm.enttime) AS [enttime],
			0 AS stock_move
	FROM [ogl].[STStockMovements] sm
	CROSS JOIN ogl_cus.datetable dt
	GROUP BY sm.stcode,sm.depot,dt.[date]
	), 
	stock_levels AS (
		-- Final Query to carry forward stock_move and stock_level for missing days
		SELECT 
			ild.stcode AS [item_no],
			ild.depot AS [location_no],
			ild.[date] AS [date],
			0 AS [stock_move],
			-- Carry forward stock_level if there's no data for that date
			sm.lev AS [stock_level],
			LAG(sm.lev, 1, 0) IGNORE NULLS OVER (PARTITION BY ild.stcode, ild.depot ORDER BY ild.[date] ASC) AS [stock_level_lag],
			--RANK() OVER (PARTITION BY ild.stcode, ild.depot, ild.[date] ORDER BY ild.[date] desc, sm.[enttime] desc) AS [rnk],
			ROW_NUMBER() OVER (PARTITION BY ild.stcode, ild.depot, ild.[date] ORDER BY ild.[date] desc, sm.[enttime] DESC) AS [rnk]
		FROM ItemLocationDates ild
		LEFT JOIN ogl.[STStockMovements] sm 
			   ON ild.date = sm.trdate 
			  AND ild.stcode = sm.stcode 
			  AND ild.depot = sm.depot)
	SELECT 
		ROW_NUMBER() OVER (ORDER BY [date], [item_no], [location_no]) AS [transaction_id],
		[item_no],
		[location_no],
		[date],
		[stock_move],
		COALESCE([stock_level],[stock_level_lag]) AS [stock_level]
	FROM stock_levels
	WHERE [rnk] = 1
	  AND ([stock_level] IS NOT NULL OR [stock_level_lag] <> 0)

