CREATE PROCEDURE [bc_sql_cus].[get_order_transfer_body](
    @OrderId INT = NULL
)
AS
BEGIN

    ;
    WITH order_to_transfer AS
             (SELECT orderId                                                               AS agrOrderId,
                     Case
                         when i.[Replenishment System] = 2 then 'BRIDGWATER' -- Transfer
                         when i.[Replenishment System] = 1 then 'BRIDGWATER' -- Prod. Order
                         else vendorNo
                         end                                                               AS orderFromLocationNo,
                     CASE
                         WHEN i.[Replenishment System] = 0 and orderType = 'purchase' THEN 'BRIDGWATER' -- Purchase
                         WHEN i.[Replenishment System] = 1 THEN 'BRIDGWATER' -- Prod. Order
                         else locationNo
                         END                                                               AS orderToLocationNo,
                     CONCAT(CAST(estimatedDeliveryDate AS NVARCHAR), 'Z')                  AS estDelivDate,
                     IIF(vendorName like '%missing%' and
                         ISNULL(i.[Replenishment System], 0) = 1, 'Production', orderType) AS orderType,
                     i.[No]                                                                AS [itemNo],
                     quantity                                                              AS [qty],
                     ''                                                                    AS [style],
                     ''                                                                    AS [color],
                     ''                                                                    AS [size],
                     i.[Code]                                                              AS [variantCode],
                     i.[Replenishment System]
              FROM dbo.order_transfer ot
                       INNER JOIN (SELECT CAST(i.[No_] +
                                               IIF(iv.[Code] IS NULL OR iv.[Code] = '', '', '-' + iv.[Code]) AS NVARCHAR(255)) AS [itemNo],
                                          i.[No_]                                                                              AS [No],
                                          iv.[Code],
                                          i.[Replenishment System]
                                   FROM [bc_sql].Item i
                                            LEFT JOIN [bc_sql].ItemVariant iv ON iv.[Item No_] = i.[No_]) i
                                  ON ot.itemNo = i.itemNo
              WHERE quantity > 0
                AND orderId = @OrderId),
         order_lines AS
             (SELECT (SELECT [itemNo],
                             [variantCode],
                             [qty],
                             [style],
                             [color],
                             [size],
                             estDelivDate,
                             orderToLocationNo
                      FROM order_to_transfer
                      FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS lines_array),
         order_header AS
             (SELECT agrOrderId,
                     orderFromLocationNo,
                     orderToLocationNo,
                     MIN(estDelivDate) AS estDelivDate,
                     orderType
              FROM order_to_transfer
              GROUP BY agrOrderId, orderFromLocationNo, orderToLocationNo, orderType)
    SELECT (SELECT DISTINCT agrOrderId,
                            orderFromLocationNo,
                            orderToLocationNo,
                            estDelivDate,
                            orderType,
                            agrLines = JSON_QUERY('[' + (SELECT lines_array FROM order_lines) + ']', '$')
            FROM order_header
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS order_body


END
