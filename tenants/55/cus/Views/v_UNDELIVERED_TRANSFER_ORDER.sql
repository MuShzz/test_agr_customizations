

    CREATE VIEW [cus].[v_UNDELIVERED_TRANSFER_ORDER] AS
       SELECT
            CAST(NULL AS VARCHAR(128)) AS [TRANSFER_ORDER_NO],
            CAST(NULL AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(NULL AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(NULL AS DATE) AS [DELIVERY_DATE],
            CAST(NULL AS DECIMAL(18, 4)) AS [QUANTITY],
            CAST(NULL AS NVARCHAR(255)) AS [ORDER_FROM_LOCATION_NO]
       WHERE 1 = 0;

