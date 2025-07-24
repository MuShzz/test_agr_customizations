CREATE VIEW [sage200_sql_cus].[v_SALES_HISTORY]
AS
     SELECT
        CAST(ptv.[id] AS BIGINT)                    AS [TRANSACTION_ID],
        CAST(ptv.[product_code] AS NVARCHAR(255))   AS [ITEM_NO],
        CAST(ptv.[warehouse_name] AS NVARCHAR(255)) AS [LOCATION_NO],
        CAST(ptv.[transaction_date] AS DATE)        AS [DATE],
        CAST(SUM(IIF(ptv.[transaction_type_id] <> 9 AND ptv.[transaction_type_id] IN (7,15,6) , ptv.[quantity], -ptv.[quantity])) AS DECIMAL(18,4)) AS [SALE],
        CAST(ISNULL(c.[reference], 'agr_no_customer') AS NVARCHAR(255)) AS [CUSTOMER_NO],
        CAST(ptv.[reference] AS NVARCHAR(255))      AS [REFERENCE_NO],
        CAST(0 AS BIT)                              AS [IS_EXCLUDED]
    FROM [sage200_sql].[v_product_transaction_views] ptv  
        LEFT JOIN [sage200_sql].[v_customer_views] c ON c.reference = ptv.[source_area_reference]
        JOIN core.setting s ON s.settingKey = 'sale_history_retention_years'
    WHERE ptv.[transaction_type_id] IN (7,15,6,16)
        AND CAST(ptv.[transaction_date] AS DATE) > DATEADD(YEAR,-CAST(s.settingValue AS INT),CAST(GETDATE() AS DATE)) 
    GROUP BY ptv.[id], ptv.[product_code], ptv.[warehouse_name], ptv.[transaction_date], c.[reference], ptv.[reference]

