




-- ===============================================================================
-- Author:      Paulo Marques
-- Description: Item group mapping from raw to adi
--
--  24.09.2024.TO   Updated
-- ===============================================================================

CREATE VIEW [cus].[v_ITEM_GROUP] AS

   SELECT CAST([ProdCode] AS NVARCHAR(255))	AS [no]
          ,CAST([Description] AS NVARCHAR(255)) AS [name]
    FROM cus.ProdGrup

	UNION

    SELECT CAST([ClassID] AS NVARCHAR(255))		AS [no]
          ,CAST([Description] AS NVARCHAR(255)) AS [name]
    FROM cus.PartClass


