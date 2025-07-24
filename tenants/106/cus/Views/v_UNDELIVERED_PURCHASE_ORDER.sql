

-- ===============================================================================
-- Author:      Jose, Jose e Paulo
-- Description: Undelivered purchase order line mapping
--
--  20.09.2024.TO   Created
-- ===============================================================================

    CREATE VIEW [cus].[v_UNDELIVERED_PURCHASE_ORDER] AS
       SELECT
            CAST(poh_order_number AS NVARCHAR(128)) AS [PURCHASE_ORDER_NO],
            CAST(pol_vad_id AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(pol_sl_id AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(pol_date_promised AS DATE) AS [DELIVERY_DATE],
            SUM(CAST(pol_qty_ordered AS DECIMAL(18,4))) AS [QUANTITY]
       FROM cus.Undelivered
	   GROUP BY CAST(poh_order_number AS NVARCHAR(128)),
        CAST(pol_vad_id AS NVARCHAR(255)),
        CAST(pol_sl_id AS NVARCHAR(255)),
		CAST(pol_date_promised AS DATE)


