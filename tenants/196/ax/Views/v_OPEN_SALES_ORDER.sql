CREATE VIEW [ax_cus].[v_OPEN_SALES_ORDER] 
AS
   SELECT
         CONCAT(
				CAST(inv.RECID AS NVARCHAR(128)),'-',
				CAST(CAST(it.DATEEXPECTED AS DATE) AS NVARCHAR(255)))
		                                                                AS [SALES_ORDER_NO],
         CAST(it.ITEMID AS NVARCHAR(255)) 								AS [ITEM_NO],
         CAST(inv.INVENTLOCATIONID AS NVARCHAR(255))                    AS [LOCATION_NO],
         SUM(CAST(it.QTY AS DECIMAL(18,4))*(-1))                        AS [QUANTITY],
         CAST(NULL AS NVARCHAR(255))                                    AS [CUSTOMER_NO],
         CAST(it.DATEEXPECTED AS DATE)                                  AS [DELIVERY_DATE],
		 CAST(it.DATAAREAID AS NVARCHAR(4))               				AS [COMPANY]
   FROM [ax].INVENTTRANS it
		INNER JOIN [ax].INVENTDIM inv ON 
			(
				inv.INVENTDIMID = it.INVENTDIMID
				AND inv.DATAAREAID = it.DATAAREAID
				AND inv.PARTITION = it.PARTITION
			)
	WHERE 
		it.STATUSISSUE IN (4,5,6) 
		AND 1=0 -- shut off view since client doesnt want open sales orders mapped
	GROUP BY 
		CONCAT(
			CAST(inv.RECID AS NVARCHAR(128)),'-',
			CAST(CAST(it.DATEEXPECTED AS DATE) AS NVARCHAR(255)))
				, it.ITEMID,
				inv.INVENTLOCATIONID
			,CAST(it.DATEEXPECTED AS DATE)
			,CAST(it.DATAAREAID AS NVARCHAR(4))

