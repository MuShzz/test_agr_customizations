


-- ===============================================================================
-- Author:      Grétar Magnússon
-- Description: Mapping Shelf Position from NAV into custom column
--
-- 30.05.2025.GM    Created
-- ===============================================================================

CREATE VIEW [nav_cus].[v_ITEM_SHELF_POSITION]
AS

	SELECT
        CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255))		AS [No_],
        CAST(i.[Shelf No_] AS NVARCHAR(50))																					AS [ShelfPosition]
    FROM
        nav_cus.Item_Extra_Info i
        LEFT JOIN nav.ItemVariant iv				ON iv.[Item No_] = i.No_



