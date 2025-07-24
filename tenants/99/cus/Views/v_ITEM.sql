





-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Orderwise
--
--  23.09.2024.TO   Altered
-- ===============================================================================


CREATE    VIEW [cus].[v_ITEM] AS
	   SELECT
        CAST(vd.vad_id AS NVARCHAR(255)) AS [NO],
        CAST(vd.vad_variant_code AS NVARCHAR(255)) AS [NAME],
        CAST(vd.vad_description AS NVARCHAR(1000)) AS [DESCRIPTION],
        CAST(sd.sd_id  AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
        CAST(vsd.vasd_guide_lead_time AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS], --null
        CAST(NULL AS SMALLINT ) AS [ORDER_FREQUENCY_DAYS], --null
        CAST(NULL AS SMALLINT ) AS [ORDER_COVERAGE_DAYS], --null
        CAST(NULL AS DECIMAL(18,4)) AS [MIN_ORDER_QTY], --null
        CAST(vsd.vasd_supplier_part_number AS NVARCHAR(50)) AS [ORIGINAL_NO],
		CAST(0 AS BIT) AS [CLOSED],
        CASE WHEN vd.vad_purchase_variant = 1 THEN CAST(0 AS BIT)
		ELSE CAST(1 AS BIT) END AS [CLOSED_FOR_ORDERING],
        CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE], --null
        CAST(vfp.vafp_rsp_exc_vat AS DECIMAL(18,4)) AS [SALE_PRICE],
        CAST(vpi.vapi_estimated_cost AS DECIMAL(18,4)) AS [COST_PRICE],
        CAST(vsd.vasd_standard_cost AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
        CAST(vd.vad_case_quantity  AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
        CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET], --null
        CAST(va.vaa_n_5/NULLIF(vd.vad_case_quantity,0) AS DECIMAL(18,6)) AS [VOLUME],
        CAST(vd.vad_weight AS DECIMAL(18,6)) AS [WEIGHT],

        CAST(NULL AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],

        CAST(NULL AS DECIMAL(18,4)) AS [MAX_STOCK], --null
        CAST(ctn2.ctn_id AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_1],
        CAST(ctn.ctn_id  AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_3], --null
        CAST(vd.vad_uom AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE],
        CAST(vd.vad_uom AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(1 AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
        CAST(0 AS BIT) AS [SPECIAL_ORDER],
        CAST(0 AS DECIMAL(18,4)) AS [REORDER_POINT],
		CAST(1 AS BIT) AS [INCLUDE_IN_AGR]
		

    FROM cus.variant_detail vd
	INNER JOIN cus.variant_analysis va ON va.vaa_vad_id = vd.vad_id
	INNER JOIN cus.variant_supplier_detail vsd ON vsd.vasd_vad_id = vd.vad_id
	INNER JOIN cus.supplier_detail sd ON sd.sd_id = vsd.vasd_sd_id
	INNER JOIN [cus].[variant_foreign_price] vfp ON vfp.vafp_vad_id = vd.vad_id AND vfp.vafp_c_id = 1 --currency set to pound
	INNER JOIN cus.variant_purchase_info vpi ON vpi.vapi_vad_id = vd.vad_id
	INNER JOIN cus.variant_category vc ON vc.vac_vad_id = vd.vad_id
	LEFT JOIN cus.category_treeview_node ctn ON ctn.ctn_id = vc.vac_ctn_id
	LEFT JOIN cus.category_treeview_node ctn2 ON ctn2.ctn_id = ctn.ctn_parent_id
	WHERE vsd.vasd_is_main_supplier = 1


