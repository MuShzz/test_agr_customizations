

-- ===============================================================================
-- Author:      José Sucena
-- Description: Open Sales Order Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ===============================================================================

CREATE VIEW [cus].[v_OPEN_SALES_ORDER] 
AS
   SELECT
         CONCAT(
				CAST(inv.RECID AS NVARCHAR(128)),'-',
				CAST(CAST(it.DATEEXPECTED AS DATE) AS NVARCHAR(255)))
		 AS [SALES_ORDER_NO],
         CAST(it.ITEMID AS NVARCHAR(255)) AS [ITEM_NO],
         CAST(inv.INVENTLOCATIONID AS NVARCHAR(255)) AS [LOCATION_NO],
         SUM(CAST(it.QTY AS DECIMAL(18,4))*(-1)) AS [QUANTITY],
         CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_NO],
         CAST(it.DATEEXPECTED AS DATE) AS [DELIVERY_DATE]
   FROM [cus].INVENTTRANS it
		INNER JOIN [cus].INVENTDIM inv ON 
			(
				inv.INVENTDIMID = it.INVENTDIMID
				AND inv.DATAAREAID = it.DATAAREAID 
			)
		LEFT OUTER JOIN [cus].inventTransOrigin ito ON (ito.recId = it.inventTransOrigin)
	WHERE 
		it.STATUSISSUE IN (4,5,6) 
		--Rosendahl specific AND it.DATAAREAID = 'rdg' 
		AND ito.REFERENCECATEGORY = 0
        AND it.dataareaid = 'rar'
		--AND it.ITEMID = '1091202'
	GROUP BY 
		CONCAT(
			CAST(inv.RECID AS NVARCHAR(128)),'-',
			CAST(CAST(it.DATEEXPECTED AS DATE) AS NVARCHAR(255)))
			--CAST((CASE 
			--	WHEN it.DATEEXPECTED <= CAST(GETDATE() AS DATE) THEN  CAST(GETDATE() AS DATE)
			--	ELSE CAST(it.DATEEXPECTED AS DATE) 
			--	END) AS NVARCHAR(255)))
				, it.ITEMID,
				inv.INVENTLOCATIONID
			,CAST(it.DATEEXPECTED AS DATE)
			--CASE 
			--	WHEN it.DATEEXPECTED <= CAST(GETDATE() AS DATE) THEN  CAST(GETDATE() AS DATE)
			--	ELSE CAST(it.DATEEXPECTED AS DATE)  
			--END

