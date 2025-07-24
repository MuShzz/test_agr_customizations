




-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

    CREATE VIEW [cus].[v_STOCK_LEVEL] AS

	SELECT
        CAST(ItemCode AS NVARCHAR(255))				AS ITEM_NO,
        CAST(WhsCode AS NVARCHAR(255))				AS LOCATION_NO,
        CAST(DATEFROMPARTS(2100, 1, 1) AS DATE)     AS EXPIRE_DATE,
		SUM(CAST(stock_units AS DECIMAL(18,4)))		AS STOCK_UNITS
    FROM
        (SELECT
			it.ItemCode,
			wh.WhsCode,
			CASE WHEN wh.WhsCode = 'GEN' AND it.U_TRC_COLL_ITM_GROUP IN ('28','29') 
				 THEN 0
				 WHEN wh.WhsCode IN ('NB','NBL','NR','NRL','SPECIALS','WB', 'NSW') 
					  AND it.U_TRC_COLL_ITM_GROUP IN ('1','2','3','4','9','10','11','12','25','28','29','33', '34')
				 THEN 0
				 WHEN wh.WhsCode IN ('Z-CST','CST')
				 THEN 0
				 ELSE wh.OnHand
			 END AS stock_units
		FROM
			[cus].OITM it
			JOIN [cus].OITW wh ON wh.ItemCode = it.ItemCode) t1
	GROUP BY
		ItemCode, WhsCode
	HAVING 
		SUM(CAST(stock_units AS DECIMAL(18,4))) > 0

