

    CREATE VIEW [cus].[v_PURCHASE_ORDER_ROUTE] AS
       SELECT
            CAST(NULL AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(NULL AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(NULL AS NVARCHAR(255)) AS [VENDOR_NO],
            CAST(NULL AS BIT) AS [PRIMARY],
            CAST(NULL AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],
            CAST(NULL AS DECIMAL(18, 4)) AS [MIN_ORDER_QTY],
            CAST(NULL AS DECIMAL(18, 4)) AS [COST_PRICE],
            CAST(NULL AS DECIMAL(18, 4)) AS [PURCHASE_PRICE],
            CAST(NULL AS DECIMAL(18, 4)) AS [ORDER_MULTIPLE],
            CAST(NULL AS DECIMAL(18, 4)) AS [QTY_PALLET],
			'' AS company
       WHERE 1 = 0;

