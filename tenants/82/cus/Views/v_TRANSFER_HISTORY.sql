


-- ===============================================================================
-- Author:      José Sucena
-- Description: Transfer History Data mapping from CUS
--
--  23.09.2024.JM   Created - Transfers added for RAR-10
-- ===============================================================================

CREATE VIEW [cus].[v_TRANSFER_HISTORY] 
AS
       
	SELECT
        CAST(CONCAT(CONVERT(VARCHAR, CAST([DATE] AS DATE), 112),100000000+(ROW_NUMBER() OVER (PARTITION BY [DATE] ORDER BY MODIFIEDDATETIME))) AS BIGINT)	AS TRANSACTION_ID,
        CAST(t.ITEM_NO AS NVARCHAR(255))																													AS [ITEM_NO],
        CAST(t.FROM_LOCATION_NO AS NVARCHAR(255)) 																											AS [FROM_LOCATION_NO],
        CAST('' AS NVARCHAR(255)) 																															AS [TO_LOCATION_NO],
        CAST(t.DATE AS DATE) 																																AS [DATE],
        CAST(t.TRANSFER AS DECIMAL(18, 4)) 																													AS [TRANSFER]
	FROM (
			SELECT CAST(it.ITEMID AS NVARCHAR(255))			AS [ITEM_NO],
					loc.NO 									AS [FROM_LOCATION_NO],
					it.DATEPHYSICAL 						AS [DATE],
					SUM(-CAST(it.QTY AS DECIMAL(18,4)))		AS [TRANSFER],
					COUNT(it.INVOICEID)						AS TRANSFER_TRANSACTION_COUNT,
					MAX(MODIFIEDDATETIME)					AS MODIFIEDDATETIME
			FROM 
				[cus].INVENTTRANS it 
				INNER JOIN [cus].INVENTTRANSORIGIN ito ON it.INVENTTRANSORIGIN = ito.RECID AND  it.PARTITION = ito.PARTITION
				INNER JOIN [cus].inventdim id ON id.inventdimid = it.inventdimid AND id.DATAAREAID = it.DATAAREAID AND id.PARTITION = ito.PARTITION --Rosendahl specific AND id.INVENTLOCATIONID = 'ROSNAKSKOV' 
				INNER JOIN cus.v_LOCATION loc ON loc.[no] = id.inventlocationid
			WHERE 
				it.DATEPHYSICAL > '1/1/1900'
				AND it.dataareaid = 'rar'
				AND ito.REFERENCECATEGORY = 6
				AND CAST(it.QTY AS DECIMAL(18,4)) < 0
				AND it.STATUSISSUE IN (0,1)
				AND it.PROJID <> 'I3080324 '
			GROUP BY 
				it.RECID,
				it.ITEMID ,
				loc.NO,
				it.DATEPHYSICAL
		) t
	


