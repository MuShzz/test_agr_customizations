CREATE VIEW [cus].[v_UNDELIVERED_TRANSFER_ORDER] AS
       SELECT
    CAST(TRANSFER_ORDER_NO AS NVARCHAR(128)) AS [TRANSFER_ORDER_NO],
    CAST(ITEM_NO AS NVARCHAR(255))           AS [ITEM_NO],
    CAST(LOCATION_NO AS NVARCHAR(255))       AS [LOCATION_NO],
    CAST('' AS NVARCHAR(255))                AS [ORDER_FROM_LOCATION_NO],
    MIN(
        CAST(
            ISNULL(
                TRY_CONVERT(DATE, DELIVERY_DATE, 103),
                GETDATE()
            ) 
            AS DATE
        )
    ) AS [DELIVERY_DATE],
    CAST(
        SUM(
            CASE 
                WHEN ISNUMERIC(QUANTITY) = 1 
                     THEN CAST(QUANTITY AS DECIMAL(18,4))
                ELSE 
                     0
            END
        )
        AS DECIMAL(18,4)
    ) AS [QUANTITY]
FROM [cus].[AGR_UNDELIVERED_TRANSFER_ORDERS]
GROUP BY 
    TRANSFER_ORDER_NO, 
    ITEM_NO, 
    LOCATION_NO, 
    DELIVERY_DATE;
