
-- ===============================================================================
-- Author:      José Sucena
-- Description: Sales History Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ===============================================================================

CREATE VIEW [cus].[v_SALES_HISTORY]
AS

	SELECT
			CAST(CONCAT(CONVERT(VARCHAR, CAST([DATE] AS DATE), 112),100000000+(ROW_NUMBER() OVER (PARTITION BY [DATE] ORDER BY MODIFIEDDATETIME))) AS BIGINT)	AS TRANSACTION_ID,
			CAST(t.ITEM_NO AS NVARCHAR(255))																													AS [ITEM_NO],
			CAST(t.LOCATION_NO AS NVARCHAR(255))																												AS LOCATION_NO,
			CAST(t.DATE AS DATE) 																																AS [DATE],
			CAST(t.SALE AS DECIMAL(18, 4))																														AS SALE,
			CAST('' AS NVARCHAR(255))																															AS [CUSTOMER_NO],
            CAST('' AS NVARCHAR(255))																															AS [REFERENCE_NO],
            CAST(0 AS BIT)																																		AS [IS_EXCLUDED]
			
	FROM (
			SELECT 
				CAST(it.ITEMID AS NVARCHAR(255))		AS [ITEM_NO],
				loc.NO 									AS LOCATION_NO,
				it.DATEPHYSICAL 						AS [DATE],
				SUM(-CAST(it.QTY AS DECIMAL(18,4)))		AS SALE,
				MAX(MODIFIEDDATETIME)					AS MODIFIEDDATETIME
			FROM 
				[cus].INVENTTRANS it 
				INNER JOIN [cus].INVENTTRANSORIGIN ito ON it.INVENTTRANSORIGIN = ito.RECID AND  it.PARTITION = ito.PARTITION
				INNER JOIN [cus].inventdim id ON id.inventdimid = it.inventdimid AND id.DATAAREAID = it.DATAAREAID AND id.PARTITION = ito.PARTITION --Rosendahl specific AND id.INVENTLOCATIONID = 'ROSNAKSKOV' 
				INNER JOIN cus.v_LOCATION loc ON loc.[no] = id.inventlocationid
			WHERE 
				it.DATEPHYSICAL > '1/1/1900'
				AND it.dataareaid = 'rar'
				AND ito.REFERENCECATEGORY IN (0,12) 
				AND it.STATUSISSUE IN (0,1)
				AND it.PROJID <> 'I3080324 '
			GROUP BY 
				it.RECID,
				it.ITEMID ,
				loc.NO,
				it.DATEPHYSICAL
			) t


