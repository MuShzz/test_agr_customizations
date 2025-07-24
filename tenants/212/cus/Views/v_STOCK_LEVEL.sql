CREATE VIEW [cus].v_STOCK_LEVEL
             AS
            SELECT
               CAST(NULL AS nvarchar(255)) AS [ITEM_NO],
               CAST(NULL AS nvarchar(255)) AS [LOCATION_NO],
               CAST(NULL AS date) AS [EXPIRE_DATE],
               CAST(NULL AS decimal(18,4)) AS [STOCK_UNITS]
                WHERE 1 = 0;
