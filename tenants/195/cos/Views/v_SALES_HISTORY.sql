





-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Customer mapping from COS
--
--  12.03.2023.HMH   Created
-- ===============================================================================
CREATE VIEW [cos_cus].[v_SALES_HISTORY]
AS

    SELECT 
        CAST(TRANSACTION_ID AS BIGINT)                      AS [TRANSACTION_ID],
        CAST(ITEM_NO AS NVARCHAR(255))                      AS [ITEM_NO],
        CAST(LOCATION_NO AS NVARCHAR(255))                  AS [LOCATION_NO],
        CAST([DATE] AS DATE)                                AS [DATE],
        CAST(ISNULL(SALE, 0) AS DECIMAL(18,4))              AS [SALE],
        CAST(ISNULL(CUSTOMER_NO,'') AS NVARCHAR(255))       AS [CUSTOMER_NO],
        CAST(ISNULL(REFERENCE_NO,'') AS NVARCHAR(255))      AS [REFERENCE_NO],
        CAST(0 AS BIT)                                      AS [IS_EXCLUDED]
    FROM
        [cos_cus].[AGR_SALES_HISTORY]

