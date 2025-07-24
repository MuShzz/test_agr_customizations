

-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom Column to map stock units for 0680
--
--  14.03.2025.BF   Created
-- ===============================================================================

CREATE VIEW [bc_sql_cus].[v_CC_stock0680] AS
   
	WITH stock0680 AS (
		SELECT
			CAST(ile.[Item No_] + CASE WHEN ISNULL([Variant Code], '') = '' THEN '' ELSE '-' + [Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO],
			CAST(SUM(ile.[Quantity]) AS DECIMAL(18,4)) AS [STOCK_UNITS]
		FROM
			[bc_sql].ItemLedgerEntry ile
		WHERE ile.[Location Code]='0680'
		GROUP BY
			ile.[Item No_], ile.[Variant Code]
	)
	
	SELECT
        CAST(i.itemNo AS NVARCHAR(255)) AS [NO],
        CAST(stock0680.STOCK_UNITS AS DECIMAL(18,4)) AS [stock0680]
	FROM
		dbo.AGREssentials_items i
		inner JOIN stock0680 ON stock0680.ITEM_NO=i.itemNo
	GROUP BY i.itemNo, stock0680.STOCK_UNITS



