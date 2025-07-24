


-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================
CREATE VIEW [cus].[v_ITEM_GROUP] AS
	SELECT [NO], ISNULL([NAME],'') AS [NAME],Company
    FROM
     (   SELECT
            CAST([Code] AS NVARCHAR(255)) AS [NO],
            CAST([Description] AS NVARCHAR(255)) AS [NAME],
			Company
        FROM
            cus.ItemCategory
            UNION ALL
        SELECT
            cus.ProductGroupCode([Item Category Code], [Code],Company) AS [NO],
            cus.ProductGroupDescription([Item Category Code], [Code], [Description],Company) AS [NAME],
			Company
        FROM
            cus.ProductGroup 
       ) nav

