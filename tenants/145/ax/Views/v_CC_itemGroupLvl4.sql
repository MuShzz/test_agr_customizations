CREATE VIEW [ax_cus].[v_CC_itemGroupLvl4]
AS

SELECT
    CAST(i.NO AS NVARCHAR(255))						AS Item_No,
    CAST(ISNULL(ig4.NAME, '') AS NVARCHAR(255))		AS itemGroupLvl4
FROM
    ax_cus.Item_v i
        INNER JOIN adi.ITEM_GROUP ig4 ON ig4.NO = i.ITEM_GROUP_NO_LVL_4
