CREATE VIEW [cus].[v_ITEM_LOCATION]
AS

WITH DefaultSupplier AS
(
    SELECT
        s.fkStockItemId,
        s.fkSupplierId,
        s.LeadTime,
        s.MinOrder,
        ROW_NUMBER() OVER (
            PARTITION BY s.fkStockItemId
            ORDER BY s.fkSupplierId
        ) AS rn
    FROM cus.ItemSupplier s
    WHERE s.IsDefault = 'True'
)
SELECT 
    CAST(si.ItemNumber AS NVARCHAR(255))      AS [ITEM_NO],
    CAST(ISNULL(sl.Location, '')  AS NVARCHAR(255))      AS [LOCATION_NO],
    CAST(NULL AS DECIMAL(18,4))                  AS [SAFETY_STOCK_UNITS],
    CAST(NULL AS DECIMAL(18,4))                  AS [MIN_DISPLAY_STOCK],
    CAST(NULL AS DECIMAL(18,4))                  AS [MAX_STOCK],
    CAST(si.bLogicalDelete AS BIT)                   AS [CLOSED],
    CAST(si.IsArchived AS BIT)                   AS [CLOSED_FOR_ORDERING],
    CAST(NULL        AS NVARCHAR(255))           AS [RESPONSIBLE],
    CAST(si.ItemTitle AS NVARCHAR(255))         AS [NAME],
    CAST(LEFT(si.ItemDescription, 255)  AS NVARCHAR(255))        AS [DESCRIPTION],
    

    CAST(sp.SupplierName AS NVARCHAR(255))       AS [PRIMARY_VENDOR_NO],
    CAST(ds.LeadTime     AS SMALLINT)            AS [PURCHASE_LEAD_TIME_DAYS],

    CAST(NULL AS SMALLINT)                       AS [TRANSFER_LEAD_TIME_DAYS],
    CAST(NULL AS SMALLINT)                       AS [ORDER_FREQUENCY_DAYS],
    CAST(NULL AS SMALLINT)                       AS [ORDER_COVERAGE_DAYS],
    CAST(ds.MinOrder     AS DECIMAL(18,4))       AS [MIN_ORDER_QTY],

    CAST(NULL AS NVARCHAR(50))                   AS [ORIGINAL_NO],
    CAST(si.RetailPrice   AS DECIMAL(18,4))      AS [SALE_PRICE],
    CAST(ISNULL(sie.ProperyValue, 0)  AS DECIMAL(18,4))      AS [COST_PRICE],
    CAST(si.PurchasePrice AS DECIMAL(18,4))					 AS [PURCHASE_PRICE],
    CAST(NULL             AS DECIMAL(18,4))      AS [ORDER_MULTIPLE],
    CAST(NULL             AS DECIMAL(18,4))      AS [QTY_PALLET],
    CAST(CAST(si.DimDepth AS DECIMAL(18,4))
	* CAST(si.DimWidth AS DECIMAL(18,4))
	* CAST(si.DimHeight AS DECIMAL(18,4)) AS DECIMAL(18,4))      AS [VOLUME],
    CAST(si.Weight        AS DECIMAL(18,4))      AS [WEIGHT],
    CAST(0 AS DECIMAL(18,4))                     AS [REORDER_POINT],
    CAST(1 AS BIT)                               AS [INCLUDE_IN_AGR],
	CAST(NULL AS BIT)							 AS [SPECIAL_ORDER]
FROM cus.StockItem si
INNER JOIN cus.ItemLocation il
       ON si.pkStockItemID = il.fkStockItemId
INNER JOIN cus.StockLocation sl 
		ON il.fkLocationId = sl.pkStockLocationId
LEFT JOIN DefaultSupplier ds
       ON ds.fkStockItemId = si.pkStockItemID
      AND ds.rn = 1
LEFT JOIN cus.Supplier sp 
		ON ds.fkSupplierId = sp.pkSupplierID
LEFT JOIN cus.StockItem_ExtendedProperties sie
		ON sie.fkStockItemId = si.pkStockItemID AND sie.ProperyName = 'landed_cost'

