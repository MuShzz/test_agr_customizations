CREATE VIEW [ax_cus].[v_CC_itemGroupLvl3]
AS

SELECT
    CAST(i.NO AS NVARCHAR(255))						AS Item_No,
    CAST(ISNULL(ig3.NAME, '') AS NVARCHAR(255))		AS itemGroupLvl3
FROM
    ax_cus.Item_v i
        INNER JOIN adi.ITEM_GROUP ig3 ON ig3.NO = i.ITEM_GROUP_NO_LVL_3
