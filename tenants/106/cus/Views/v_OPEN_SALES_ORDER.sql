

-- ===============================================================================
-- Author:      Jose, Jose e Paulo
-- Description: open sales order mapping
--
--  20.09.2024.TO   Created
-- ===============================================================================

    CREATE VIEW [cus].[v_OPEN_SALES_ORDER] AS
       SELECT
            CAST(oli_oh_id AS NVARCHAR(128)) AS [SALES_ORDER_NO],
            CAST(oli_vad_id AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(oli_sl_id AS NVARCHAR(255)) AS [LOCATION_NO],
            SUM(CAST(oli_qty_required AS DECIMAL(18,4))) AS [QUANTITY],
            CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(oli_date_promised AS DATE) AS [DELIVERY_DATE]
       FROM cus.Open_Sales_Order
	GROUP BY CAST(oli_oh_id			AS NVARCHAR(128)),
        CAST(oli_vad_id				AS NVARCHAR(255)),
        CAST(oli_sl_id				AS NVARCHAR(255)),
		CAST(oli_date_promised		AS DATE)


