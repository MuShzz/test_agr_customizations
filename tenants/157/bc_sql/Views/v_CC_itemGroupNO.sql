

-- ===============================================================================
-- Author:			Grétar Magnússon
-- Description:		Custom columns 
--
-- 16.05.2025.GM	Created
-- ===============================================================================


CREATE VIEW [bc_sql_cus].[v_CC_itemGroupNO]
AS

    SELECT
		CAST(i.[No_] AS NVARCHAR(255))																		AS ITEM_NO,
		CAST(IIF(c.[Parent Category] <> '', c.[Parent Category], i.[Item Category Code]) AS NVARCHAR(255))	AS itemGroupLvl1No,
		CAST(ix.[LSC Retail Product Code$5ecfc871-5d82-43f1-9c54-59685e82318d] AS NVARCHAR(255))			AS itemGroupLvl2No
	FROM
		bc_sql.Item i
		LEFT JOIN bc_sql.ItemCategory c		ON c.Code = i.[Item Category Code] AND i.company = c.company
		LEFT JOIN bc_sql_cus.ItemExt ix		ON ix.No_ = i.No_


