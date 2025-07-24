






-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales history mapping from raw to adi, Orderwise
--
--  24.09.2024.TO   Altered
-- ===============================================================================


    CREATE    VIEW [cus].[v_SALES_HISTORY] AS
       
	  SELECT 
				CAST(vts.vts_id AS BIGINT) AS [TRANSACTION_ID],
				CAST(vad.vad_id AS NVARCHAR(255)) AS [ITEM_NO], 
				CAST(vth.vth_sl_id AS NVARCHAR(255)) AS [LOCATION_NO], 
				CAST(vts.vts_datetime AS DATE) AS [DATE], 
				CAST(vts.vts_quantity AS DECIMAL(18,4)) AS [SALE],
				CAST(oh.oh_cd_id AS NVARCHAR(255)) AS [CUSTOMER_NO],
				CAST(oh.oh_order_number AS NVARCHAR(255)) AS [REFERENCE_NO],
				CAST(0 AS BIT) AS [IS_EXCLUDED]
			FROM 
				cus.variant_detail vad
			LEFT JOIN 
				cus.variant_transaction_header vth ON vth.vth_vad_id = vad.vad_id
			LEFT JOIN 
				cus.variant_transaction_split vts ON vts.vts_vth_id = vth.vth_id
			LEFT JOIN 
				cus.transaction_type tt ON tt.tt_id = vts.vts_tt_id
			LEFT JOIN
				cus.order_line_item oli on oli.oli_id = vts.vts_oli_id
			LEFT JOIN
				cus.order_header oh ON oh.oh_id = oli.oli_oh_id
			WHERE 
				tt.tt_id = 8 AND oli.oli_direct <> 1


		/* customer sale transaction view before switch
		SELECT
            CAST(oli.oli_id AS BIGINT) AS [TRANSACTION_ID],
            CAST(vd.vad_id AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(sl.sl_id  AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(oh.oh_datetime AS DATE) AS [DATE],
            CAST(SUM(oli.oli_qty_required) AS DECIMAL(18, 4)) AS [SALE],
            CAST(cd.cd_id AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(oh.oh_order_number AS NVARCHAR(255)) AS [REFERENCE_NO],
            CAST(0 AS BIT) AS [IS_EXCLUDED]
       FROM cus.order_line_item oli 
	   INNER JOIN cus.order_header oh ON oh.oh_id = oli.oli_oh_id
	   INNER JOIN cus.variant_detail vd ON vd.vad_id = oli.oli_vad_id
	   INNER JOIN cus.stock_location sl ON sl.sl_id = oli.oli_sl_id
	   INNER JOIN cus.customer_detail cd ON cd.cd_id = oh.oh_cd_id
	   WHERE oh.oh_sot_id = 1 AND oh.oh_os_id IN (4,5,6)
	   GROUP BY oli.oli_id, vd.vad_id, sl.sl_id, oh.oh_datetime, cd.cd_id,oh.oh_order_number
		*/


