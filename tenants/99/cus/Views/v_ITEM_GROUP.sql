

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Orderwise
--
--  24.09.2024.TO   Altered
-- ===============================================================================

CREATE VIEW [cus].[v_ITEM_GROUP] AS
   SELECT
        CAST(ctn_id AS NVARCHAR(255)) AS [NO],
        CAST(ctn_description AS NVARCHAR(255)) AS [NAME]
   FROM cus.category_treeview_node


