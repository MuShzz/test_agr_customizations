



    CREATE VIEW [cus].[v_TRANSFER_HISTORY] AS
       SELECT
            CAST(NULL AS BIGINT) AS [TRANSACTION_ID],
            CAST(NULL AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(NULL AS NVARCHAR(255)) AS [FROM_LOCATION_NO],
            CAST(NULL AS NVARCHAR(255)) AS [TO_LOCATION_NO],
            CAST(NULL AS DATE) AS [DATE],
            CAST(NULL AS DECIMAL(18, 4)) AS [TRANSFER]
       WHERE 1 = 0;


