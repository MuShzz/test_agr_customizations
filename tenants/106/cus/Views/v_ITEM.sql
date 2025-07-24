

-- ===============================================================================
-- Author:      Jose, Jose e Paulo
-- Description: Item mapping 
--
--  20.09.2024.TO   Created
-- ===============================================================================

CREATE VIEW [cus].[v_ITEM] AS

WITH RankedSales AS (
		SELECT 
			sh.oli_vad_id,
			sh.oli_item_price/sh.oli_price_per AS [sale_price],
			ROW_NUMBER() OVER (PARTITION BY sh.oli_vad_id ORDER BY sh.dh_datetime DESC) AS rn
		FROM cus.Sales_History sh
	),
	Top10Sales AS (
		SELECT 
			oli_vad_id,
			AVG([sale_price]) AS avg_last_10_sales
		FROM RankedSales
		WHERE rn <= 10
		GROUP BY oli_vad_id
	)
	   SELECT
        CAST(vad_id AS NVARCHAR(255)) AS [NO],
        CAST(vad_variant_code AS NVARCHAR(255)) AS [NAME],
        CAST(vad_description AS NVARCHAR(1000)) AS [DESCRIPTION],
        CAST(vasd_sd_id AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
        CAST(vasd_guide_lead_time AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],  
        CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS],  
        CAST(NULL AS SMALLINT ) AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT ) AS [ORDER_COVERAGE_DAYS],
        CAST(vasd_minimum_order_qty AS DECIMAL(18,4)) AS [MIN_ORDER_QTY],
        CAST(vasd_supplier_part_number AS NVARCHAR(50)) AS [ORIGINAL_NO],
        CAST(0 AS BIT) AS [CLOSED_FOR_ORDERING],
        CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE],
        ts.avg_last_10_sales AS [SALE_PRICE],
        CAST(CAST(cost_price AS FLOAT) AS DECIMAL(18,4)) AS [COST_PRICE],
        CAST(CAST(vasd_standard_cost AS FLOAT) AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
        CAST(vasd_multiplier_qty AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
        CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET],
        CAST(vad_volume AS DECIMAL(18,6)) AS [VOLUME],
        CAST(vad_weight AS DECIMAL(18,6)) AS [WEIGHT],

        CAST(NULL AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],

        CAST(NULL AS DECIMAL(18,4)) AS [MAX_STOCK],
        CAST(ctn_parent_id AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_1],
        CAST(vac_ctn_id AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_3],
        CAST(vaea_c_14 AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE],
        CAST(vaea_c_14 AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(1 AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
        CAST(special_order AS BIT) AS [SPECIAL_ORDER],
        CAST(0 AS DECIMAL(18,4)) AS [REORDER_POINT],
		CAST(1 AS DECIMAL(18,4)) AS [INCLUDE_IN_AGR],
		CAST(closed AS DECIMAL(18,4)) AS [CLOSED]
    FROM cus.Item i
	LEFT JOIN Top10Sales ts ON i.vad_id = ts.oli_vad_id


