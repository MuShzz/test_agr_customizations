CREATE VIEW [ax_cus].[v_OPEN_SALES_ORDER] 
AS
   SELECT
         CONCAT(
				CAST(inv.RECID AS NVARCHAR(128)),'-',
				CAST(CAST(it.DATEEXPECTED AS DATE) AS NVARCHAR(255)))
		                                                                AS [SALES_ORDER_NO],
         CAST(iv.NO AS NVARCHAR(255)) 									AS [ITEM_NO],
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
		INNER JOIN ax_cus.Item_v iv ON iv.No_TO_JOIN_IL = it.ITEMID
	WHERE 
		it.STATUSISSUE IN (4,5,6) 
	GROUP BY 
		CONCAT(
			CAST(inv.RECID AS NVARCHAR(128)),'-',
			CAST(CAST(it.DATEEXPECTED AS DATE) AS NVARCHAR(255)))
				, iv.NO,
				inv.INVENTLOCATIONID
			,CAST(it.DATEEXPECTED AS DATE)
			,CAST(it.DATAAREAID AS NVARCHAR(4))

