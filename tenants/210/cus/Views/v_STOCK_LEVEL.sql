CREATE VIEW [cus].v_STOCK_LEVEL AS
    SELECT
        CAST(ist.ItemCode AS nvarchar(255))             AS [ITEM_NO],
        CAST(ist.WarehouseCode AS nvarchar(255))        AS [LOCATION_NO],
        CAST(DATEFROMPARTS(2100, 1, 1) AS date)         AS [EXPIRE_DATE],
        CAST(SUM(ist.UnitsInStock) AS decimal(18,4))    AS [STOCK_UNITS]
	FROM cus.InventoryStockTotal ist
	INNER JOIN core.location_mapping_setup lms ON lms.locationNo=ist.WarehouseCode
	GROUP BY ist.ItemCode,
		ist.WarehouseCode
	HAVING SUM(ist.UnitsInStock)<>0
