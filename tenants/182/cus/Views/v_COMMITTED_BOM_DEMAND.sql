CREATE VIEW [cus].v_COMMITTED_BOM_DEMAND
             AS
            SELECT
               CAST(NULL AS nvarchar(128)) AS [BOM_ORDER_NO],
               CAST(NULL AS nvarchar(255)) AS [ITEM_NO],
               CAST(NULL AS nvarchar(255)) AS [LOCATION_NO],
               CAST(NULL AS decimal(18,4)) AS [QUANTITY],
               CAST(NULL AS date) AS [DEMAND_DATE]
                WHERE 1 = 0;
