CREATE VIEW [ax_cus].[v_STOCK_HISTORY]
AS
SELECT NULL                                       AS [TRANSACTION_ID],
       CAST(it.ITEMID AS NVARCHAR(255))           AS [ITEM_NO],
       CAST(id.INVENTLOCATIONID AS NVARCHAR(255)) AS [LOCATION_NO],
       CAST(it.DATEPHYSICAL AS DATE)              AS [DATE],
       CAST(it.QTY AS DECIMAL(18, 4))             AS [STOCK_MOVE],
       NULL                                       AS [STOCK_LEVEL]
FROM [ax].INVENTTRANS it
         INNER JOIN [ax_cus].INVENTDIM id ON id.INVENTDIMID = it.INVENTDIMID AND id.DATAAREAID = it.DATAAREAID AND
                                         id.PARTITION = it.PARTITION
WHERE it.DATEPHYSICAL > CAST('1900-01-01' AS DATE)
