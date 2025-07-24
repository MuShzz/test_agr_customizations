CREATE VIEW [cus].v_OPEN_SALES_ORDER
AS
WITH mi_split AS
         (SELECT mi.itemId             as [mysis_itemId],
                 LTRIM(RTRIM(s.value)) AS sage_itemId -- remove stray spaces
          FROM cus.MIITEM AS mi
                   CROSS APPLY STRING_SPLIT(mi.sales, '|') AS s
          where mi.sales is not null
            and mi.sales <> '')
SELECT CAST(oh.ORDNUMBER AS nvarchar(128))                          AS [SALES_ORDER_NO],
       CAST(mi_split.mysis_itemId AS nvarchar(255))                               AS [ITEM_NO],
       CAST(od.LOCATION AS nvarchar(255))                           AS [LOCATION_NO],
       SUM(CAST(od.QTYORDERED AS decimal(18, 4)))                   AS [QUANTITY],
       CAST(oh.CUSTOMER AS nvarchar(255))                           AS [CUSTOMER_NO],
       CAST(CAST(CAST(oh.SHIPDATE AS int) as nvarchar(10)) AS date) AS [DELIVERY_DATE]
FROM cus.OEORDH oh
         inner join cus.OEORDD od
                    on oh.ORDUNIQ = od.ORDUNIQ
         INNER JOIN mi_split ON mi_split.sage_itemId = od.ITEM -- the actual mapping
where CAST(oh.SHIPDATE AS int) > 0
  and od.ITEM is not null
  and ISNULL(od.LOCATION,'') <> ''
  and oh.ONHOLD = 0
  and oh.COMPLETE in (1,2)
group by oh.ORDNUMBER, mi_split.mysis_itemId, od.LOCATION, oh.CUSTOMER, CAST(CAST(CAST(oh.SHIPDATE AS int) as nvarchar(10)) AS date)
