



-- ===============================================================================
-- Author:      Paulo Marques
-- Description: undelivered purchase order mapping from raw to adi, Orderwise
--
--  24.09.2024.TO   Altered
-- 02.05.2025.AEK	RFSB-10
-- ===============================================================================


    CREATE   VIEW [cus].[v_UNDELIVERED_PURCHASE_ORDER] AS
       SELECT
            CAST(poh.poh_order_number AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
            CAST(pol.pol_vad_id AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(pol.pol_sl_id AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(pol.pol_date_promised AS DATE) AS [DELIVERY_DATE],
            CAST(SUM(pol.pol_qty_ordered-pol.pol_qty_received) AS DECIMAL(18, 4)) AS [QUANTITY]
       FROM  cus.purchase_order_line pol  
	   INNER JOIN cus.purchase_order_header poh ON poh.poh_id = pol.pol_poh_id 
	   WHERE poh.poh_pos_id NOT IN (4,5) AND pol.pol_pos_id IN (1,2) and pol.pol_direct <> 1
	   AND pol.pol_back_to_back_oli_id = 0
	   GROUP BY poh.poh_order_number, pol.pol_vad_id, pol.pol_sl_id, CAST(pol.pol_date_promised AS DATE)
	   HAVING SUM(pol.pol_qty_ordered-pol.pol_qty_received) > 0


