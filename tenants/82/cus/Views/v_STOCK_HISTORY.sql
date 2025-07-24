

-- ===============================================================================
-- Author:      José Sucena
-- Description: Stock History Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ===============================================================================

CREATE VIEW [cus].[v_STOCK_HISTORY] 
AS
       SELECT
            CAST(CONCAT(CONVERT(VARCHAR, CAST(DATEPHYSICAL AS DATE), 112),100000000+(ROW_NUMBER() OVER (PARTITION BY it.DATEPHYSICAL ORDER BY MAX(it.MODIFIEDDATETIME)))) AS BIGINT) AS [TRANSACTION_ID],
            CAST(it.ITEMID AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(id.INVENTLOCATIONID AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(it.DATEPHYSICAL AS DATE) AS [DATE],
            SUM(CAST(it.QTY AS DECIMAL(18,4))) AS [STOCK_MOVE],
            CAST(NULL AS DECIMAL(18, 4)) AS [STOCK_LEVEL]
      FROM 
		[cus].INVENTTRANS it 
		INNER JOIN [cus].INVENTTRANSORIGIN ito ON it.INVENTTRANSORIGIN = ito.RECID AND  it.partition = ito.partition
		INNER JOIN [cus].inventdim id ON id.inventdimid = it.inventdimid AND id.DATAAREAID = it.DATAAREAID AND id.partition = ito.partition --Rosendahl specific AND id.INVENTLOCATIONID = 'ROSNAKSKOV' 
		WHERE it.DATEPHYSICAL > CAST('1900-01-01' AS DATE)
          AND it.dataareaid = 'rar'
		    GROUP BY it.RECID,
            it.ITEMID ,
            id.INVENTLOCATIONID ,
            it.DATEPHYSICAL


