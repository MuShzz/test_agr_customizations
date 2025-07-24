-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Transfer transactions from sage200 to adi format
--
-- 10.01.2025.TO    Created
-- ===============================================================================
CREATE VIEW [sage200_sql_cus].[v_TRANSFER_HISTORY]
AS

    SELECT
        CAST(ptv.[id] AS BIGINT) AS [TRANSACTION_ID],
        CAST(ptv.[product_code] AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(ptv.[warehouse_name] AS NVARCHAR(255)) AS [FROM_LOCATION_NO],
        CAST(NULL AS NVARCHAR(255)) AS [TO_LOCATION_NO],
        CAST(ptv.[transaction_date] AS DATE) AS [DATE],
        CAST(SUM(IIF(ptv.[transaction_type_id] = 9, ptv.[quantity], 0)) AS DECIMAL(18,4)) AS [TRANSFER]
    FROM
        [sage200_sql].[v_product_transaction_views] ptv
        JOIN core.setting s ON s.settingKey = 'sale_history_retention_years'
    WHERE
        ptv.[transaction_type_id] = 9
        AND CAST(ptv.[transaction_date] AS DATE) > DATEADD(YEAR,-CAST(s.settingValue AS INT),CAST(GETDATE() AS DATE))
    GROUP BY
       ptv.id, ptv.[product_code], ptv.[warehouse_name], CAST(ptv.[transaction_date] AS DATE)

