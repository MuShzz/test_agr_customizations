
CREATE VIEW [fo_cus].[v_SALES_HISTORY]
AS

   SELECT
    CAST(it.RECID1 AS NVARCHAR(255)) AS TRANSACTION_ID,
    CAST(it.ITEMID + CASE WHEN id.[CONFIGID] IS NULL OR id.[CONFIGID] = '' THEN '' ELSE '-' + ISNULL(id.CONFIGID, '') END AS NVARCHAR(255)) AS ITEM_NO,
    CAST(ISNULL(id.INVENTLOCATIONID,'') AS NVARCHAR(255)) AS LOCATION_NO,
    CAST(ISNULL(it.DATEINVENT,it.[DATEPHYSICAL]) AS DATE) AS [DATE],
    CAST(SUM(IIF(it.[REFERENCECATEGORY] IN ('Sales','KanbanJobPickingList'), 
                 -CAST(it.QTY AS DECIMAL(18,4)), 
                 0
    )) AS DECIMAL(18,4)) AS SALE,
    CAST(it.REFERENCEID AS NVARCHAR(255)) AS REFERENCE_NO,
    CAST(0 AS BIT) AS IS_EXCLUDED,
    CAST(ISNULL(c.CUSTOMERACCOUNT, '') AS NVARCHAR(255)) AS CUSTOMER_NO
FROM
    fo_cus.[InventTrans] it
LEFT JOIN fo.SalesOrderLines sol
    ON sol.INVENTORYLOTID = it.INVENTTRANSID
LEFT JOIN fo.SalesOrderHeaders soh
    ON soh.SALESORDERNUMBER = it.REFERENCEID
LEFT JOIN fo.Customers c
    ON soh.DELIVERYADDRESSLOCATIONID = c.DELIVERYADDRESSLOCATIONID
LEFT JOIN fo_cus.InventDim id 
    ON id.INVENTDIMID = it.INVENTDIMID
WHERE
    (
        (it.REFERENCECATEGORY = 'Sales' AND it.STATUSISSUE = 'SOLD' AND CAST(it.QTY AS DECIMAL(18,4)) < 0)
        OR
        (it.REFERENCECATEGORY = 'KanbanJobPickingList'
         AND it.STATUSISSUE IN ('Sold', 'Picked', 'Deducted') AND CAST(it.QTY AS DECIMAL(18,4)) < 0)
    )
    --AND CAST(it.QTY AS DECIMAL(18,4)) < 0
GROUP BY
    it.RECID1,
    it.ITEMID,
    CAST(ISNULL(it.DATEINVENT,it.DATEPHYSICAL) AS DATE),
    it.REFERENCECATEGORY,
    id.INVENTLOCATIONID,
    id.CONFIGID,
    sol.SHIPPINGWAREHOUSEID,
    sol.SALESORDERNUMBER,
    it.REFERENCEID,
    c.CUSTOMERACCOUNT

