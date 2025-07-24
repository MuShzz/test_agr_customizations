CREATE VIEW [cus].v_ITEM
AS

WITH RankedCategories AS (
    SELECT
        p.productId,
        c.categoryId,
        ROW_NUMBER() OVER (PARTITION BY p.productId ORDER BY c.categoryId desc) AS category_rank
    FROM cus.Products p
             LEFT JOIN cus.Categories c ON p.categories_categoryId = c.categoryId
),
-- Select the best packaging per product
     RankedOrders AS (
         SELECT
             purchaseOrderForm_lineItems_code,
             purchaseOrderForm_lineItems_supplierPackagingQuantity,
             ROW_NUMBER() OVER (
                 PARTITION BY purchaseOrderForm_lineItems_code
                 ORDER BY
                     CASE WHEN purchaseOrderForm_lineItems_supplierPackagingQuantity IS NOT NULL THEN 0 ELSE 1 END
                 ) AS rn_po
         FROM cus.PurchaseOrders
     )
SELECT DISTINCT
    CAST(p.productId AS nvarchar(255)) AS [NO],
    CAST(ISNULL(p.name, p.productId) AS nvarchar(255)) AS [NAME],
    CAST(ISNULL(p.name, p.productId)AS nvarchar(1000)) AS [DESCRIPTION],
    CAST((CASE
              WHEN p.supplierId = '' THEN NULL
              WHEN p.supplierId = 'Inaktiv' THEN NULL
              ELSE p.supplierId
        END) AS nvarchar(255)) AS [PRIMARY_VENDOR_NO],
    CAST(NULL AS smallint) AS [PURCHASE_LEAD_TIME_DAYS],
    CAST(NULL AS smallint) AS [TRANSFER_LEAD_TIME_DAYS],
    CAST(NULL AS smallint) AS [ORDER_FREQUENCY_DAYS],
    CAST(NULL AS smallint) AS [ORDER_COVERAGE_DAYS],
    CAST(NULL AS decimal(18,4)) AS [MIN_ORDER_QTY],
    CAST(p.supplierSkuId AS nvarchar(50)) AS [ORIGINAL_NO],
    CAST(IIF(p.isActive = 0, 1, 0) AS bit) AS [CLOSED],
    CAST(0 AS bit) AS [CLOSED_FOR_ORDERING],
    CAST(NULL AS nvarchar(255)) AS [RESPONSIBLE],
    CAST(p.cost AS decimal(18,4)) AS [SALE_PRICE],
    CAST(p.price_unitPrice AS decimal(18,4)) AS [COST_PRICE],
    CAST(p.price_originalUnitPrice AS decimal(18,4)) AS [PURCHASE_PRICE],
    CAST(NULL AS decimal(18,4)) AS [ORDER_MULTIPLE],
    CAST(NULL AS decimal(18,4)) AS [QTY_PALLET],
    CAST(NULL AS decimal(18,4)) AS [VOLUME],
    CAST(p.weight AS decimal(18,4)) AS [WEIGHT],
    CAST(p.minQuantity AS decimal(18,4)) AS [SAFETY_STOCK_UNITS],
    CAST(NULL AS decimal(18,4)) AS [MIN_DISPLAY_STOCK],
    CAST(p.maxQuantity AS decimal(18,4)) AS [MAX_STOCK],
    CAST(MAX(CASE WHEN rc.category_rank = 1 THEN rc.categoryId END) AS nvarchar(255)) AS [ITEM_GROUP_NO_LVL_1],
    CAST(MAX(CASE WHEN rc.category_rank = 2 THEN rc.categoryId END) AS nvarchar(255)) AS [ITEM_GROUP_NO_LVL_2],
    CAST(NULL AS nvarchar(255)) AS [ITEM_GROUP_NO_LVL_3],
    CAST(NULL AS nvarchar(50)) AS [BASE_UNIT_OF_MEASURE],
    CAST(NULL AS nvarchar(50)) AS [PURCHASE_UNIT_OF_MEASURE],
    CAST(po.purchaseOrderForm_lineItems_supplierPackagingQuantity AS decimal(18,4)) AS [QTY_PER_PURCHASE_UNIT],
    CAST(0 AS decimal(18,4)) AS [REORDER_POINT],
    CAST(0 AS bit) AS [SPECIAL_ORDER],
    CAST(1 AS bit) AS [INCLUDE_IN_AGR]
FROM cus.Products p
         LEFT JOIN RankedCategories rc ON p.productId = rc.productId
         LEFT JOIN (
    SELECT purchaseOrderForm_lineItems_code, purchaseOrderForm_lineItems_supplierPackagingQuantity
    FROM RankedOrders
    WHERE rn_po = 1
) po ON p.productId = po.purchaseOrderForm_lineItems_code
GROUP BY
    p.productId, p.name, p.supplierId, p.supplierSkuId, p.cost, p.price_unitPrice, p.price_originalUnitPrice, p.weight, p.minQuantity, p.maxQuantity, po.purchaseOrderForm_lineItems_supplierPackagingQuantity, p.isActive
