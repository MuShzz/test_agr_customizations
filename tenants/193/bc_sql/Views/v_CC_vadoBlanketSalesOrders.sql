create VIEW [bc_sql_cus].[v_CC_vadoBlanketSalesOrders] AS

SELECT
       CAST(sl.[No_] + CASE WHEN ISNULL(sl.[Variant Code], '') = '' THEN '' ELSE '-' + sl.[Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO],
       CAST(ISNULL(sl.[Location Code], sh.[Location Code]) AS NVARCHAR(255)) AS [LOCATION_NO],
       SUM(CAST(sl.[Outstanding Qty_ (Base)] AS INT))             AS [vadoBlanketSalesOrders]
FROM [bc_sql].SalesLine sl
         INNER JOIN bc_sql.SalesHeader sh
                    ON sl.[Document No_] = sh.[No_] AND sl.[Document Type] = sh.[Document Type] and
                       sl.[company] = sh.[company]
WHERE sh.[Document Type] = 4
  AND sl.[Drop Shipment] = 0
GROUP BY sl.[No_], sl.[Variant Code], ISNULL(sl.[Location Code], sh.[Location Code]),
        sl.[company]
having SUM(CAST(sl.[Outstanding Qty_ (Base)] AS INT)) <> 0


