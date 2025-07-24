



-- ===============================================================================
-- Author:      José Sucena
-- Description: STOCK_HISTORY mapping from cus
--
--  24.09.2024.TO   Created
-- ===============================================================================

    CREATE VIEW [cus].[v_STOCK_HISTORY] AS
       SELECT
            CAST([ROWNUMBER] AS NVARCHAR(255)) AS [TRANSACTION_ID],
            CAST([ITEMNUMBER] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST([INVENLOCATION] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(DATE_ AS DATE) AS [DATE],
            CAST(SUM(QTY) AS DECIMAL(18, 4)) AS [STOCK_MOVE],
            CAST(NULL AS DECIMAL(18, 4)) AS [STOCK_LEVEL]
       FROM [cus].[INVENTRANS]
	   WHERE [DATASET] = 'DAT'
	   GROUP BY [ROWNUMBER], [ITEMNUMBER], [INVENLOCATION], [DATE_]


