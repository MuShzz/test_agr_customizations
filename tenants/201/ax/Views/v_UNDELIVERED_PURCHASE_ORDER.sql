
CREATE VIEW [ax_cus].[v_UNDELIVERED_PURCHASE_ORDER] 
AS

       SELECT
            CAST(p.PURCHID AS VARCHAR(128))                                                                                  AS [PURCHASE_ORDER_NO],
            CAST(p.ITEMID AS NVARCHAR(255))                                                                                  AS [ITEM_NO],
            CAST(id.INVENTLOCATIONID AS NVARCHAR(255))                                                                       AS [LOCATION_NO],
            CAST(CASE p.CONFIRMEDDLV WHEN '1900-01-01 00:00:00.000' THEN p.DELIVERYDATE ELSE p.CONFIRMEDDLV END AS DATE) AS [DELIVERY_DATE],
            SUM(CAST(p.REMAINPURCHPHYSICAL AS DECIMAL(18,4)))                                                                AS [QUANTITY],
            CAST(p.DATAAREAID AS NVARCHAR(4))                                                                               AS [COMPANY]
       FROM [ax].PURCHLINE p
		INNER JOIN [ax].INVENTDIM id ON id.INVENTDIMID = p.INVENTDIMID AND id.DATAAREAID = p.DATAAREAID AND id.PARTITION = p.PARTITION
	   WHERE	
		CAST(p.REMAINPURCHPHYSICAL AS DECIMAL(18,4)) > 0
	   GROUP BY p.PURCHID, p.ITEMID, id.INVENTLOCATIONID, 
       CASE p.CONFIRMEDDLV WHEN '1900-01-01 00:00:00.000' THEN p.DELIVERYDATE ELSE p.CONFIRMEDDLV END, 
       CAST(p.DATAAREAID AS NVARCHAR(4))

