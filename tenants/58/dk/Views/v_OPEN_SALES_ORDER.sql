
-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Open sales order mapping from dk
--
--  24.10.2024.TO   Created
-- ===============================================================================

CREATE VIEW [dk_cus].[v_OPEN_SALES_ORDER]
AS

    SELECT 
        CAST(sol.[Number] AS NVARCHAR(128))                                                 AS [sales_order_no],
        CAST(sol.[Lines.ItemCode] AS NVARCHAR(255))                                         AS [item_no],
        CAST(so.Warehouse AS NVARCHAR(255))                                                 AS [location_no],
        SUM(CAST((sol.[Lines.Quantity]-sol.[Lines.QuantityDelivered]) AS DECIMAL(18,4)))    AS [quantity],
        CAST(so.[Customer.Number] AS NVARCHAR(255))                                         AS [customer_no],
        MAX(CASE WHEN CAST(so.[Date] AS DATE) < GETDATE() THEN
            CAST(GETDATE() AS DATE)
        ELSE
            CAST(so.[Date] AS DATE)
        END)                                                                                AS [delivery_date]
    FROM [dk].[import_sales_order_lines] sol
    INNER JOIN [dk].[import_sales_order] so 
      ON sol.[Number] = so.[Number]
    WHERE (sol.[Lines.Quantity]-sol.[Lines.QuantityDelivered]) > 0
	--AND sol.[Lines.ItemCode] = 'EH070300'
	AND so.Deleted IS NULL
	AND sol.[Lines.Deleted] IS NULL
    GROUP BY CAST(sol.[Number] AS NVARCHAR(128)),
             sol.[Lines.ItemCode], so.[Customer.Number], so.Warehouse


