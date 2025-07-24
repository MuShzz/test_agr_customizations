


-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Customer mapping from COS
--
--  12.03.2023.HMH   Created
-- ===============================================================================
CREATE VIEW [cos_cus].[v_STOCK_HISTORY]
AS

   SELECT
        CAST(TRANSACTION_ID AS BIGINT)      AS [TRANSACTION_ID],
        CAST(ITEM_NO AS NVARCHAR(255))      AS [ITEM_NO],
        CAST(LOCATION_NO AS NVARCHAR(255))  AS [LOCATION_NO],
        CAST(DATE AS DATE)                  AS [DATE],
        CAST(STOCK_MOVE AS DECIMAL(18,4))   AS [STOCK_MOVE],
        CAST(STOCK_LEVEL AS DECIMAL(18,4))  AS [STOCK_LEVEL]
    FROM
        [cos_cus].[AGR_STOCK_HISTORY]

