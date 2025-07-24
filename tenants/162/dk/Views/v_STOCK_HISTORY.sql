
-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Stock history mapping from dk
--
--  24.10.2024.TO   Created
-- ===============================================================================


CREATE VIEW [dk_cus].[v_STOCK_HISTORY]
AS
   
    SELECT
		CAST([ID] AS INT)							AS [TRANSACTION_ID],
        CAST([ItemCode]  AS NVARCHAR(255))			AS [ITEM_NO],
        CAST(CASE 
				WHEN [Warehouse] IS NULL THEN 'tom_stadsetning'
				ELSE [Warehouse]
			END	AS NVARCHAR(255))			AS [LOCATION_NO],
        CAST([JournalDate] AS DATE)					AS [DATE],
        CAST(SUM([Quantity]) AS DECIMAL(18,4))		AS [STOCK_MOVE],
        CAST(NULL AS DECIMAL(18,4))					AS [STOCK_LEVEL]
    FROM
        [dk].import_transactions
    WHERE
        CAST([JournalDate] AS DATE) <= GETDATE()
        AND [ItemCode] IS NOT NULL
		

     GROUP BY
        [ItemCode], [Warehouse], CAST([JournalDate] AS DATE) , CAST([ID] AS INT)

