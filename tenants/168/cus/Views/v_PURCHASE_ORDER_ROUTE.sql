CREATE VIEW [cus].v_PURCHASE_ORDER_ROUTE
             AS
            SELECT
               CAST(NULL AS nvarchar(255)) AS [ITEM_NO],
               CAST(NULL AS nvarchar(255)) AS [LOCATION_NO],
               CAST(NULL AS nvarchar(255)) AS [VENDOR_NO],
               CAST(NULL AS bit) AS [PRIMARY],
               CAST(NULL AS smallint) AS [LEAD_TIME_DAYS],
               CAST(NULL AS smallint) AS [ORDER_FREQUENCY_DAYS],
               CAST(NULL AS decimal(18,4)) AS [MIN_ORDER_QTY],
               CAST(NULL AS decimal(18,4)) AS [COST_PRICE],
               CAST(NULL AS decimal(18,4)) AS [PURCHASE_PRICE],
               CAST(NULL AS decimal(18,4)) AS [ORDER_MULTIPLE],
               CAST(NULL AS decimal(18,4)) AS [QTY_PALLET]
                WHERE 1 = 0;
