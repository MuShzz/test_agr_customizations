
-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Product group mapping from erp to adi format
--
--  10.09.2019.TO   Created
--  12.03.2025.BF   Adding extra product groups same mapping as Plus setup
-- ===============================================================================

CREATE VIEW [bc_sql_cus].[v_ITEM_GROUP] AS
   
	SELECT
        CAST([Code] AS NVARCHAR(255)) AS [NO],
        CAST([Description] AS NVARCHAR(255)) AS [NAME]
	FROM
     [bc_sql].ItemCategory


	UNION ALL

	SELECT
        CAST([Code] AS NVARCHAR(255)) AS [NO],
        CAST([Description] AS NVARCHAR(255)) AS [NAME]
	FROM
     [bc_sql_cus].LSCDivision

	UNION ALL

	SELECT
        CAST([Code] AS NVARCHAR(255)) AS [NO],
        CAST([Description] AS NVARCHAR(255)) AS [NAME]
	FROM
     [bc_sql_cus].LSCRetailProductGroup



