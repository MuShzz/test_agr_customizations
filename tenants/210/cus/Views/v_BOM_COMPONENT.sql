CREATE VIEW [cus].v_BOM_COMPONENT AS
    
	SELECT
        CAST(ikd.ItemKitCode AS nvarchar(255))  AS [ITEM_NO],
        CAST(ikd.ItemCode AS nvarchar(255))     AS [COMPONENT_ITEM_NO],
        CAST(ikd.Quantity AS decimal(18,4))     AS [QUANTITY]
	FROM cus.InventoryKitDetail ikd
