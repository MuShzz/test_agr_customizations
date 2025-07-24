
CREATE VIEW [cus].[v_CC_minOnHand]
AS

	SELECT
		CAST(it.itemNo AS NVARCHAR(255))		AS [ITEM_NO],
		CAST(it.locationNo AS NVARCHAR(255))	AS [LOCATION_NO],
		CAST(cpp.MinimumQty AS INT)				AS minOnHand
	FROM dbo.AGREssentials_items it
	LEFT JOIN cus.PartPlant cpp ON cpp.PartNum=it.itemNo AND cpp.Plant=it.locationNo


