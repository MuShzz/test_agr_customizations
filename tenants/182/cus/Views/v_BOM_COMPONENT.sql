CREATE VIEW [cus].[v_bom_component] AS
	
	SELECT
		CAST(si1.ItemNumber AS NVARCHAR(255)) AS ITEM_NO,
		CAST(si2.ItemNumber AS NVARCHAR(255)) AS COMPONENT_ITEM_NO,
		CAST(sic.Quantity AS DECIMAL(18,4)) AS QUANTITY
	FROM cus.Stock_ItemComposition sic
	INNER JOIN cus.StockItem si1
	ON si1.pkStockItemID = sic.pkStockItemId
	INNER JOIN cus.StockItem si2
	ON si2.pkStockItemID = sic.pkLinkStockItemId
