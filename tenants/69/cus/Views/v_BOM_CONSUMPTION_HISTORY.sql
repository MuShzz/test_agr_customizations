CREATE VIEW [cus].v_BOM_CONSUMPTION_HISTORY
AS
SELECT CAST(NULL AS bigint)                   AS [TRANSACTION_ID],
       CAST(product_item_no AS nvarchar(255)) AS [ITEM_NO],
       CAST(location_no AS nvarchar(255))     AS [LOCATION_NO],
       CAST(date AS date)                     AS [DATE],
       CAST(value AS decimal(18, 4))          AS [UNIT_QTY]
from [cus].bom_consumption
