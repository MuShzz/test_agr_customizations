
CREATE VIEW [nav_cus].[v_CC_Division_ItemFamilyCode] AS

	SELECT 
	di.No_ AS ITEM_NO,
	d.Description AS division,
	i.Description AS itemfamilycode
	FROM nav_cus.CC_Division_ItemFamilyCode di
	INNER JOIN nav_cus.Division d ON d.Code=di.[Division Code]
	INNER JOIN nav_cus.ItemFamily i ON i.Code=di.[Item Family Code]


