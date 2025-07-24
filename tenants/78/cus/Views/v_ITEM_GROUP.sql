


-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Quick Books Desktop
--
--  23.09.2024.TO   Altered
-- ===============================================================================

CREATE VIEW [cus].[v_ITEM_GROUP] AS
   SELECT
        CAST('no_group' AS NVARCHAR(255)) AS [NO],
        CAST(ISNULL('No Group','') AS NVARCHAR(255)) AS [NAME]


