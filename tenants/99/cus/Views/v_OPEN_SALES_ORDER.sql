




-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Orderwise
--
--  24.09.2024.TO   Altered
--	30.04.2025.AEK	RFSB-10
-- ===============================================================================

    CREATE     VIEW [cus].[v_OPEN_SALES_ORDER] AS
       SELECT
            CAST(oli.oli_oh_id AS NVARCHAR(128)) AS [SALES_ORDER_NO],
            CAST(oli.oli_vad_id AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(oli.oli_sl_id AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(SUM(oli.oli_qty_tbsent) AS DECIMAL(18, 4)) AS [QUANTITY],
            CAST(oh.oh_cd_id AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(oli.oli_date_promised AS DATE) AS [DELIVERY_DATE]
       FROM cus.order_line_item oli
		INNER JOIN cus.order_header oh ON oh.oh_id = oli.oli_oh_id 
		WHERE oh.oh_sot_id = 1 AND oli.oli_os_id IN (1,2,4) AND oli.oli_direct <> 1 AND oli.oli_back_to_back = 'False'
		GROUP BY oli.oli_oh_id, oli.oli_vad_id, oli.oli_sl_id, oli.oli_date_promised, oh.oh_cd_id
		HAVING SUM(oli.oli_qty_tbsent)  > 0



