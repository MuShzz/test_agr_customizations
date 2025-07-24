CREATE VIEW [fo_cus].[v_stock_history]
AS


   SELECT
		CAST(it.RecIdTrans AS BIGINT) AS TRANSACTION_ID,
		CAST(it.ItemId + CASE WHEN id.[CONFIGID] IS NULL OR id.[CONFIGID] = '' THEN '' ELSE '-' + ISNULL(id.CONFIGID, '')END AS NVARCHAR(255)) AS ITEM_NO,
		CAST(id.InventLocationId AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(it.DatePhysical AS DATE) AS [DATE],
        CAST(it.Qty AS DECIMAL(18,4)) AS [stock_move],
        CAST(NULL AS DECIMAL(18,4)) AS [stock_level]
    FROM fo_cus.InventTrans it
	LEFT JOIN fo_cus.InventDim id ON id.INVENTDIMID = it.INVENTDIMID
	WHERE it.DATEPHYSICAL > '1900-02-02'

