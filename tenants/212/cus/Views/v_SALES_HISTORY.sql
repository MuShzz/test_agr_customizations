CREATE VIEW [cus].v_SALES_HISTORY
             AS
            SELECT
               CAST(NULL AS bigint) AS [TRANSACTION_ID],
               CAST(NULL AS nvarchar(255)) AS [ITEM_NO],
               CAST(NULL AS nvarchar(255)) AS [LOCATION_NO],
               CAST(NULL AS date) AS [DATE],
               CAST(NULL AS decimal(18,4)) AS [SALE],
               CAST(NULL AS nvarchar(255)) AS [CUSTOMER_NO],
               CAST(NULL AS nvarchar(255)) AS [REFERENCE_NO],
               CAST(NULL AS bit) AS [IS_EXCLUDED]
                WHERE 1 = 0;
