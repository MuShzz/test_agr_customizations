

-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom Column to map for undelivered price - undelivered 
--
--  14.03.2025.BF   Created
-- ===============================================================================

CREATE VIEW [bc_sql_cus].[v_undelivered_price] AS
   
	SELECT
        CAST(i.itemNo AS NVARCHAR(255)) AS [NO],
        CAST(SUM(it.COST_PRICE*un.QUANTITY) AS DECIMAL(18,4)) AS [undeliveredPrice]
	FROM
		dbo.AGREssentials_items i
		inner JOIN adi.ITEM it ON i.itemNo=it.NO
		LEFT JOIN adi.UNDELIVERED_PURCHASE_ORDER un ON un.ITEM_NO=it.NO
	GROUP BY i.itemNo
	HAVING SUM(it.COST_PRICE*un.QUANTITY)>0


