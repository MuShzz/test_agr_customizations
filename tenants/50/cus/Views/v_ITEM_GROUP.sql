

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Netsuite
--
--  29.09.2024.TO   Altered
-- ===============================================================================

CREATE VIEW [cus].[v_ITEM_GROUP] AS
   SELECT DISTINCT
        CAST([custitemcustitem_horwood_item_category_id] AS NVARCHAR(255))+'_category' AS [NO],
        CAST([custitemcustitem_horwood_item_category] AS NVARCHAR(255)) AS [NAME]
     FROM [cus].[Item]
	 WHERE [custitemcustitem_horwood_item_category] IS NOT NULL   
	 UNION ALL
   SELECT DISTINCT 
        CAST([custitem_horwood_item_type_id] AS NVARCHAR(255))+'_type' AS [NO],
        CAST([custitem_horwood_item_type]  AS NVARCHAR(255)) AS [NAME]
	 FROM [cus].[Item]
	 WHERE [custitem_horwood_item_type] IS NOT NULL   

