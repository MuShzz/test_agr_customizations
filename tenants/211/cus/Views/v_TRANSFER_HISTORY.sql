CREATE VIEW [cus].v_TRANSFER_HISTORY
             AS
            SELECT
               CAST(NULL AS bigint) AS [TRANSACTION_ID],
               CAST(NULL AS nvarchar(255)) AS [ITEM_NO],
               CAST(NULL AS nvarchar(255)) AS [FROM_LOCATION_NO],
               CAST(NULL AS nvarchar(255)) AS [TO_LOCATION_NO],
               CAST(NULL AS date) AS [DATE],
               CAST(NULL AS decimal(18,4)) AS [TRANSFER]
                WHERE 1 = 0;
