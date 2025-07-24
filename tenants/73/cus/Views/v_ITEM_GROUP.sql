


-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

CREATE VIEW [cus].[v_ITEM_GROUP] AS
   SELECT
        CAST(ItmsGrpCod AS NVARCHAR(255)) AS [NO],
        CAST(ItmsGrpNam AS NVARCHAR(255)) AS [NAME]
   FROM
        [cus].OITB
	UNION ALL

	SELECT DISTINCT
		CAST(it.U_SanaCategoryLevel2 AS NVARCHAR(255))  AS [NO],
		CAST(it.U_SanaCategoryLevel2 AS NVARCHAR(255))  AS [NAME]
	FROM
        [cus].OITM it
	WHERE CAST(it.U_SanaCategoryLevel2 AS NVARCHAR(255)) IS NOT NULL


