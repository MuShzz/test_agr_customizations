CREATE VIEW [cus].v_SALES_HISTORY_LEGACY
             AS
            SELECT
               CAST(NULL AS nvarchar(255)) AS [ITEM_NO],
               CAST(NULL AS nvarchar(255)) AS [LOCATION_NO],
               CAST(NULL AS date) AS [DATE],
               CAST(NULL AS nvarchar(255)) AS [CUSTOMER_NO],
               CAST(NULL AS nvarchar(255)) AS [REFERENCE_NO],
               CAST(NULL AS decimal(18,4)) AS [SALE]
                WHERE 1 = 0;
