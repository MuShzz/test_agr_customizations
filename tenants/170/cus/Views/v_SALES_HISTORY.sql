CREATE VIEW [cus].[v_SALES_HISTORY]
AS

    SELECT 
        CAST(TRANSACTION_ID AS BIGINT)                      AS [TRANSACTION_ID],
        CAST(ITEM_NO AS NVARCHAR(255))                      AS [ITEM_NO],
        CAST(LOCATION_NO AS NVARCHAR(255))                  AS [LOCATION_NO],
        CAST([DATE] AS DATE)                                AS [DATE],
        CAST(ISNULL(NULLIF(SALE,''), 0) AS DECIMAL(18,4))              AS [SALE],
        CAST(ISNULL(NULLIF(CUSTOMER_NO,''),0) AS NVARCHAR(255))       AS [CUSTOMER_NO],
        CAST(ISNULL(NULLIF(REFERENCE_NO,''),0) AS NVARCHAR(255))      AS [REFERENCE_NO],
        CAST(0 AS BIT)                                      AS [IS_EXCLUDED]
    FROM
        [cus].[SALES_HISTORY]
