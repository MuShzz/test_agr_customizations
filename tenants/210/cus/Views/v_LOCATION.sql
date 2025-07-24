CREATE VIEW [cus].v_LOCATION AS
	SELECT
		CAST(iw.WarehouseCode AS nvarchar(255))         AS [NO],
		CAST(iw.WarehouseDescription AS nvarchar(255))  AS [NAME]
	FROM cus.InventoryWarehouse iw
