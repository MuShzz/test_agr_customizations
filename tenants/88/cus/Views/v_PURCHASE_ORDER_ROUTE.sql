



-- ===============================================================================
-- Author:      José Sucena
-- Description: PURCHASE_ORDER_ROUTE mapping from cus
--
--  24.09.2024.TO   Created
-- ===============================================================================

CREATE VIEW [cus].[v_PURCHASE_ORDER_ROUTE] 
AS
       SELECT
            CAST(i.[ITEMNUMBER] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST('' AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(i.[PRIMARYVENDOR] AS NVARCHAR(255)) AS [VENDOR_NO],
            CAST(1 AS BIT) AS [PRIMARY],
            CAST(NULL AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],
            CAST(NULL AS DECIMAL(18, 4)) AS [MIN_ORDER_QTY],
            CAST(i.[COSTPRICE] AS DECIMAL(18, 4)) AS [COST_PRICE],
            CAST(i.[COSTPRICE] AS DECIMAL(18, 4)) AS [PURCHASE_PRICE],
            CAST(1 AS DECIMAL(18, 4)) AS [ORDER_MULTIPLE],
            CAST(NULL AS DECIMAL(18, 4)) AS [QTY_PALLET]
        FROM [cus].[INVENTABLE] i
			LEFT JOIN [cus].[VENDTABLE] v ON v.ACCOUNT = i.PRIMARYVENDOR AND i.DATASET = v.DATASET
		WHERE i.DATASET = 'DAT'


