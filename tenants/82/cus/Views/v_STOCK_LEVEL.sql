


-- ===============================================================================
-- Author:      José Sucena
-- Description: Stock Level Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ===============================================================================

CREATE VIEW [cus].[v_STOCK_LEVEL] 
AS

       SELECT
            CAST(ins.ITEMID AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(iv.INVENTLOCATIONID AS NVARCHAR(255)) AS [LOCATION_NO],
			CAST(DATEFROMPARTS(2100, 1, 1) AS DATE)     AS EXPIRE_DATE,
            SUM(CAST(ins.PHYSICALINVENT AS DECIMAL(18,4))) AS [STOCK_UNITS]
       FROM	
			[cus].INVENTSUM ins
	INNER JOIN
			[cus].INVENTDIM iv 
				ON	iv.InventDimId		= ins.InventDimId
				AND iv.DATAAREAID		= ins.DATAAREAID 
				AND iv.PARTITION		= ins.PARTITION
		WHERE	
		--ins.Closed = 0 AND
	    CAST(ins.PHYSICALINVENT AS DECIMAL(18,4)) > 0
		AND iv.InventLocationID <> ''
        AND ins.dataareaid = 'rar'
		--Rosendahl specific AND il.INVENTLOCATIONID <> 'ROSNAKSKOV'
		GROUP BY 
			 ins.[ITEMID], iv.INVENTLOCATIONID


