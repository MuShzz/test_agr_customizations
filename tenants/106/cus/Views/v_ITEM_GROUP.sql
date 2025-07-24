

-- ===============================================================================
-- Author:      Jose, Jose e Paulo
-- Description: Item Group mapping
--
--  20.09.2024.TO   Created
-- ===============================================================================

CREATE VIEW [cus].[v_ITEM_GROUP] AS
   SELECT
        CAST(ctn_id AS NVARCHAR(255)) AS [NO],
        CAST(ctn_description AS NVARCHAR(255)) AS [NAME]
   FROM cus.Item_Group


