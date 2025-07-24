CREATE VIEW [cus].v_SALES_HISTORY
AS
WITH mi_split AS
         (SELECT mi.itemId             as [mysis_itemId],
                 LTRIM(RTRIM(s.value)) AS sage_itemId -- remove stray spaces
          FROM cus.MIITEM AS mi
                   CROSS APPLY STRING_SPLIT(mi.sales, '|') AS s
          where mi.sales is not null
            and mi.sales <> '')
SELECT CAST(NULL AS bigint)                           AS [TRANSACTION_ID],
       CAST(mi_split.mysis_itemId AS nvarchar(255))   AS [ITEM_NO],
       CAST(oh.LOCATION AS nvarchar(255))             AS [LOCATION_NO],
       CAST(CAST(oh.INVDATE as NVARCHAR(22)) AS date) AS [DATE],
       CAST(od.QTYSHIPPED AS decimal(18, 4))          AS [SALE],
       CAST(oh.CUSTOMER AS nvarchar(255))             AS [CUSTOMER_NO],
       CAST(oh.REFERENCE AS nvarchar(255))            AS [REFERENCE_NO],
       CAST(0 AS bit)                                 AS [IS_EXCLUDED]
from cus.OEINVH oh
         inner join cus.OEINVD od on oh.INVUNIQ = od.INVUNIQ
         INNER JOIN mi_split ON mi_split.sage_itemId = od.ITEM -- the actual mapping
where od.ITEM is not null
  and ISNULL(oh.LOCATION,'') <> ''
