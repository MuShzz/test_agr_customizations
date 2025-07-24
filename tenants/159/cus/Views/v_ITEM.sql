CREATE VIEW [cus].[v_ITEM] AS
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
),
AllRows AS
(
    SELECT
        si.pkStockItemID,
        si.ItemNumber,
        si.ItemTitle,
        si.ItemDescription,
        si.bLogicalDelete,
        si.IsArchived,
        si.RetailPrice,
        si.PurchasePrice,
        si.Weight,
        si.CategoryId,
		si.DimHeight,
		si.DimWidth,
		si.DimDepth,

        ds.fkSupplierId  AS DefaultSupplierId,
        ds.LeadTime      AS DefaultLeadTime,
        ds.MinOrder      AS DefaultMinOrder,

        ROW_NUMBER() OVER (
            PARTITION BY si.ItemNumber
            ORDER BY 
                CASE 
                    WHEN si.bLogicalDelete = 'False' AND si.IsArchived = 'False' THEN 0 
                    ELSE 1 
                END,
                si.pkStockItemID  -- Tiebreaker if needed
        ) AS rn
    FROM cus.StockItem si
    LEFT JOIN DefaultSupplier ds 
        ON ds.fkStockItemId = si.pkStockItemID
       AND ds.rn = 1
)
SELECT
    CAST(ar.ItemNumber      AS NVARCHAR(255))            AS [NO],
    CAST(ar.ItemTitle       AS NVARCHAR(255))            AS [NAME],
    CAST(ar.ItemDescription AS NVARCHAR(1000))           AS [DESCRIPTION],

    CAST(s.SupplierName AS NVARCHAR(255))          AS [PRIMARY_VENDOR_NO],
    CAST(ar.DefaultLeadTime   AS SMALLINT)               AS [PURCHASE_LEAD_TIME_DAYS],

    CAST(NULL AS SMALLINT)                            AS [TRANSFER_LEAD_TIME_DAYS],
    CAST(NULL AS SMALLINT )                           AS [ORDER_FREQUENCY_DAYS],
    CAST(NULL AS SMALLINT )                           AS [ORDER_COVERAGE_DAYS],
    CAST(ar.DefaultMinOrder AS DECIMAL(18,4))            AS [MIN_ORDER_QTY],

    CAST(NULL AS NVARCHAR(50))                        AS [ORIGINAL_NO],
    CAST(ar.bLogicalDelete AS BIT)                       AS [CLOSED],
    CAST(ar.IsArchived     AS BIT)                       AS [CLOSED_FOR_ORDERING],
    CAST(NULL AS NVARCHAR(255))                       AS [RESPONSIBLE],
    CAST(ar.RetailPrice   AS DECIMAL(18,4))              AS [SALE_PRICE],
    CAST(ar.PurchasePrice         AS DECIMAL(18,4))               AS [COST_PRICE],
    CAST(NULL AS DECIMAL(18,4))              AS [PURCHASE_PRICE],
    CAST(1 AS DECIMAL(18,4))                          AS [ORDER_MULTIPLE],
    CAST(NULL AS DECIMAL(18,4))                       AS [QTY_PALLET],
    CAST(CAST(CAST(ar.DimHeight AS DECIMAL(18,6)) * CAST(ar.DimWidth AS DECIMAL(18,6)) * CAST(ar.DimDepth AS DECIMAL(18,6)) AS DECIMAL(18,6)) / 1000000 AS DECIMAL(18,6))                      AS [VOLUME],
    CAST(ar.Weight AS DECIMAL(18,6))                     AS [WEIGHT],
    CAST(NULL AS DECIMAL(18,4))                       AS [SAFETY_STOCK_UNITS],
    CAST(NULL AS DECIMAL(18,4))                       AS [MIN_DISPLAY_STOCK],
    CAST(NULL AS DECIMAL(18,4))                       AS [MAX_STOCK],
    CAST(pc.CategoryName AS NVARCHAR(255))                 AS [ITEM_GROUP_NO_LVL_1],
    CAST(NULL AS NVARCHAR(255))                       AS [ITEM_GROUP_NO_LVL_2],
    CAST(NULL AS NVARCHAR(255))                       AS [ITEM_GROUP_NO_LVL_3],
    CAST(NULL AS NVARCHAR(50))                        AS [BASE_UNIT_OF_MEASURE],
    CAST(NULL AS NVARCHAR(50))                        AS [PURCHASE_UNIT_OF_MEASURE],
    CAST(1 AS DECIMAL(18,4))                          AS [QTY_PER_PURCHASE_UNIT],
    CAST(0 AS BIT)                                    AS [SPECIAL_ORDER],
    CAST(0 AS DECIMAL(18,4))                          AS [REORDER_POINT],
    CAST(1 AS BIT)                                    AS [INCLUDE_IN_AGR]
FROM AllRows ar
LEFT JOIN cus.Supplier s
ON ar.DefaultSupplierId = s.pkSupplierID
LEFT JOIN cus.ProductCategories pc ON pc.CategoryId = ar.CategoryId
WHERE ar.rn = 1

