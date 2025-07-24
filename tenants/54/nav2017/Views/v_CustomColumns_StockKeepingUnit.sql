


-- ===============================================================================
-- Author:      
-- Description: Customer mapping from COS
--
--  12.03.2023   Created
-- ====================================================================================================
CREATE VIEW [nav2017_cus].[v_CustomColumns_StockKeepingUnit]
AS

    SELECT
       aei.[itemNo]
      ,aei.[locationNo]
	  ,2 AS customColumnId
	  , CASE WHEN cust.[Replenishment System] = 0 THEN 'Purchase'
             WHEN cust.[Replenishment System] = 1 THEN 'Prod. Order'
             WHEN cust.[Replenishment System] = 2 THEN 'Transfer'
             WHEN cust.[Replenishment System] = 3 THEN 'Assembly' END AS columnValue
  FROM [dbo].[AGREssentials_items] aei
    INNER JOIN [nav2017_cus].[CustomColumns_StockKeepingUnit] cust 
            ON aei.[itemNo] = cust.[Item No_]
           AND aei.[locationNo] = cust.[Location Code]
	WHERE cust.[Replenishment System] <> ''

