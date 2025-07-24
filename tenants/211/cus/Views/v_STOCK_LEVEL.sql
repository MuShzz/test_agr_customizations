CREATE view [cus].v_STOCK_LEVEL
as
SELECT DISTINCT
    CAST(p.productId AS nvarchar(255)) AS [ITEM_NO],
    CAST(i.warehouseCode AS nvarchar(255)) AS [LOCATION_NO],
    CAST('2100-01-01' AS date) AS [EXPIRE_DATE],
    CAST(p.availableInventory AS decimal(18,4)) AS [STOCK_UNITS]
from  cus.Products p
    INNER JOIN cus.Inventory i ON p.productId = i.sku
