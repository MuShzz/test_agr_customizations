

-- ===============================================================================
-- Author:			Grétar Magnússon
-- Description:		Custom columns item group level 3 and 4
--
-- 15.04.2025.GM	Created
-- ===============================================================================

CREATE VIEW [ax_cus].[v_CC_itemGroupLvl3And4]
AS

    SELECT
       CAST(i.NO AS NVARCHAR(255))						AS Item_No,
	   CAST(ISNULL(ig3.NAME, '') AS NVARCHAR(255))		AS itemGroupLvl3,
	   CAST(ISNULL(ig4.NAME, '') AS NVARCHAR(255))		AS itemGroupLvl4
    FROM
        ax_cus.v_ITEM i
		INNER JOIN adi.ITEM_GROUP ig3 ON ig3.NO = i.ITEM_GROUP_NO_LVL_3
		INNER JOIN adi.ITEM_GROUP ig4 ON ig4.NO = i.ITEM_GROUP_NO_LVL_4


