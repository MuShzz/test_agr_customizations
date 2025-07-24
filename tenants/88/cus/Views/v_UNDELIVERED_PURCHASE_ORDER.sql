




-- ===============================================================================
-- Author:      José Sucena
-- Description: UNDELIVERED_PURCHASE_ORDER mapping from cus
--
--  24.09.2024.TO   Created
-- ===============================================================================

CREATE VIEW [cus].[v_UNDELIVERED_PURCHASE_ORDER] 
AS
       SELECT
            CAST(TRIM([NUMBER_]) AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
            CAST([ITEMNUMBER] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST([INVENLOCATION] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST([DELIVERY] AS DATE) AS [DELIVERY_DATE],
            CAST(SUM([QTY]-[RECEIVED]) AS DECIMAL(18, 4)) AS [QUANTITY]
       FROM [cus].[PURCHLINE]
	   WHERE [DATASET] = 'DAT'
	   GROUP BY [NUMBER_], [ITEMNUMBER], [INVENLOCATION], [DELIVERY]
	   HAVING SUM([QTY]-[RECEIVED]) > 0


