CREATE VIEW [cus].v_BOM_CONSUMPTION_HISTORY
             AS
            SELECT
               CAST(NULL AS bigint) AS [TRANSACTION_ID],
               CAST(NULL AS nvarchar(255)) AS [ITEM_NO],
               CAST(NULL AS nvarchar(255)) AS [LOCATION_NO],
               CAST(NULL AS date) AS [DATE],
               CAST(NULL AS decimal(18,4)) AS [UNIT_QTY]
                WHERE 1 = 0;
