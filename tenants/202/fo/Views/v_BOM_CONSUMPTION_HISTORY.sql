CREATE VIEW [fo_cus].[v_BOM_CONSUMPTION_HISTORY]
AS

    SELECT
		CAST(it.RECID1 AS BIGINT) AS TRANSACTION_ID,
        CAST(it.ITEMID + CASE WHEN id.[CONFIGID] IS NULL OR id.[CONFIGID] = '' THEN '' ELSE '-' + ISNULL(id.CONFIGID, '')END AS NVARCHAR(255)) AS [item_no],
        CAST(id.INVENTLOCATIONID AS NVARCHAR(255)) AS [location_no],
        CAST(it.DATEPHYSICAL AS DATE) AS [date],
		CAST(SUM(-CAST(it.QTY AS DECIMAL(18,4))) AS DECIMAL(18,4)) AS [UNIT_QTY]
    FROM fo.InventTrans it
	LEFT JOIN fo.InventDim id ON it.INVENTDIMID = id.INVENTDIMID
	WHERE it.REFERENCECATEGORY LIKE '%Kanban%' AND 1=0
    GROUP BY it.RECID1, it.ITEMID, id.CONFIGID, id.INVENTLOCATIONID, it.DATEPHYSICAL, it.QTY

