




-- ===============================================================================
-- Author:      José Sucena
-- Description: STOCK_LEVEL mapping from cus
--
--  24.09.2024.TO   Created
-- ===============================================================================

CREATE VIEW [cus].[v_STOCK_LEVEL] 
AS
       SELECT
            CAST([ITEMNUMBER] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST([INVENLOCATION] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(DATEFROMPARTS(2100, 1, 1) AS DATE) AS EXPIRE_DATE,
            CAST(SUM([INVENTORY]) AS DECIMAL(18, 4)) AS [STOCK_UNITS]
       FROM [cus].[INVENTORYSUM]
	   WHERE [DATASET] = 'DAT'
	   GROUP BY [INVENLOCATION], [ITEMNUMBER]


