



-- ===============================================================================
-- Author:      José Sucena
-- Description: open sales order line mapping from cus
--
--  24.09.2024.TO   Created
-- ===============================================================================

CREATE VIEW [cus].[v_OPEN_SALES_ORDER] 
AS
       SELECT
            CAST(TRIM(sl.[NUMBER_]) AS NVARCHAR(128)) AS [SALES_ORDER_NO],
            CAST(sl.[ITEMNUMBER] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(sl.[INVENLOCATION] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(SUM(sl.[QTY]-sl.[DELIVERED]) AS DECIMAL(18, 4)) AS [QUANTITY],
            CAST(v.ACCOUNT AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(sl.[DELIVERY] AS DATE) AS [DELIVERY_DATE]
       FROM [cus].[SALESLINE] sl
	   LEFT JOIN [cus].[VENDTABLE] v ON v.ACCOUNT = sl.ACCOUNT
	   WHERE sl.[DATASET] = 'DAT'
       GROUP BY sl.[NUMBER_], sl.[ITEMNUMBER], sl.[INVENLOCATION], v.ACCOUNT, sl.[DELIVERY]
       HAVING SUM(sl.[QTY]-sl.[DELIVERED])  > 0 


