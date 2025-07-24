

-- ===============================================================================
-- Author:      JOSE SUCENA
-- Description: Item mapping from sage200 to adi format
--
-- 10.01.2025.TO    Created
-- 10.03.2025.BF	Altered closed definition to defined closed with code GONE - VPG-10
-- 11.03.2025.BF	Reverted back to exclude GONE items it was causing duplications
-- ===============================================================================

CREATE VIEW [sage200_sql_cus].[v_ITEM]
AS


	SELECT
        CAST(pv.[code] AS NVARCHAR(255))                                                                            AS [NO],
        CAST(pv.[name] AS NVARCHAR(255))                                                                            AS [NAME],
        CAST(pv.[description] AS NVARCHAR(1000))                                                                    AS [DESCRIPTION],
        CAST(IIF(sv.[reference] IS NULL,'vendor_missing',sv.[reference]) AS NVARCHAR(255))                          AS [PRIMARY_VENDOR_NO],
        dbo.LeadTimeConvert(ps.[lead_time_unit],ps.lead_time,GETDATE())                                             AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT)                                                                                      AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT)                                                                                      AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT)                                                                                      AS [ORDER_COVERAGE_DAYS],
        CAST(ps.[minimum_order_quantity] AS DECIMAL(18,4))                                                          AS [MIN_ORDER_QTY],
        CAST(ps.[supplier_stock_code] AS NVARCHAR(50))                                                              AS [ORIGINAL_NO],
        CAST(IIF(pv.analysis_code_2 IN ('DISC','GONE'), '1', pv.[status_type]) AS BIT)                                     AS [CLOSED],
        CAST(0 AS BIT)                                                                                              AS [CLOSED_FOR_ORDERING],
        CAST(NULL AS NVARCHAR(255))                                                                                 AS [RESPONSIBLE],
        CAST(ISNULL(ppv.[product_price_price],0) AS DECIMAL(18,4))                                                         AS [SALE_PRICE],
        CAST(ISNULL(IIF(pv.[product_group_costing_method_type] = 2, pv.[standard_cost],pv.[average_buying_price]),0) AS DECIMAL(18,4))  AS [COST_PRICE],
        CAST(ISNULL(IIF([default_pricing_source_type] = 'Last Buying Price', ps.[last_buying_price],ps.[list_price]),0) AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
        CAST(ISNULL(TRY_CAST(pac.[analysis_code_value] AS DECIMAL(18,4)),1) AS DECIMAL(18,4))                       AS [ORDER_MULTIPLE],
        CAST(COALESCE(TRY_CAST(pac_pall.[analysis_code_value] AS DECIMAL(18,4))
            ,(pu.[units-multiple_of_base_unit]/NULLIF(pv.stock_multiple_of_base_unit,0)),1) AS DECIMAL(18,4))       AS [QTY_PALLET],
        CAST(TRY_CAST(pac_vol.[analysis_code_value] AS DECIMAL(18,4)) AS DECIMAL(18,4))                             AS [VOLUME],
        CAST(pv.[weight] AS DECIMAL(18,4))                                                                          AS [WEIGHT],
        CAST(NULL AS DECIMAL(18,4))                                                                                 AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4))                                                                                 AS [MIN_STOCK],
        CAST(NULL AS DECIMAL(18,4))                                                                                 AS [MAX_STOCK],
        CAST(pv.[product_group_code] AS NVARCHAR(255))                                                              AS [ITEM_GROUP_NO_LVL_1],
        CAST(NULL AS NVARCHAR(255))                                                                                 AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255))                                                                                 AS [ITEM_GROUP_NO_LVL_3],
        CAST(pv.[stock_unit_name] AS NVARCHAR(50))                                                                  AS [BASE_UNIT_OF_MEASURE],
        CAST(pv.[stock_unit_name] AS NVARCHAR(50))                                                                  AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(1 AS DECIMAL(18,4))                                                                                    AS [QTY_PER_PURCHASE_UNIT],
        CAST(0 AS BIT)                                                                                              AS [SPECIAL_ORDER],
        CAST(ISNULL(pv.[reorder_level],0) AS DECIMAL(18,4))                                                         AS [REORDER_POINT],
        CAST(0 AS BIT)                                                                                              AS [INCLUDE_IN_AGR],
        CAST(NULL AS DECIMAL(18,4))                                                                                 AS [MIN_DISPLAY_STOCK]

    FROM
        [sage200_sql].[v_product_views] pv
        LEFT JOIN [sage200_sql].[v_product_suppliers] ps ON pv.id = ps.[product_id] AND ps.[is_preferred] = 1
        LEFT JOIN [sage200_sql].[v_supplier_views] sv ON sv.id = ps.supplier_id
        LEFT JOIN [sage200_sql].[v_productsUnits] pu ON pv.id = pu.id AND pu.[units-unit_id] = (SELECT TOP 1 id FROM [sage200_sql].v_units WHERE [name] = sage200_sql.get_setting_value('pallet_UOM_code_override'))
        LEFT JOIN [sage200_sql].[v_product_analysis_code] pac ON pac.id = pv.id AND pac.analysis_code_number = (SELECT sage200_sql.get_setting_value('data_mapping_sage_order_multiple_analysis_code'))
        LEFT JOIN [sage200_sql].[v_product_analysis_code] pac_vol ON pac_vol.id = pv.id AND pac_vol.analysis_code_number = (SELECT sage200_sql.get_setting_value('data_mapping_sage_volume_analysis_code'))
        LEFT JOIN [sage200_sql].[v_product_analysis_code] pac_pall ON pac_pall.id = pv.id AND pac_pall.analysis_code_number = (SELECT sage200_sql.get_setting_value('data_mapping_sage_pallet_qty_analysis_code'))
        LEFT JOIN [sage200_sql].[v_product_price_views] ppv ON pv.id = ppv.[product_id] AND ppv.[price_band_id] = '1083983733'
    WHERE
         pv.[product_group_product_type] = 0  -- Inventory items only
         AND ISNULL(sv.[account_is_on_hold],0) = 0 -- discard not to use supplier
		 AND pv.analysis_code_2 NOT IN ('ASK','E.SOL','ASK.CHG','ASK NEW','DIRECT','C.DIREC','S')
		 AND NOT (
			pv.analysis_code_2 = 'GONE'
			AND TRY_CAST(pv.analysis_code_15 AS DATE) < DATEADD(YEAR, -3, GETDATE())
		)
		 --AND pv.analysis_code_2 NOT IN ('ASK','E.SOL','ASK.CHG','ASK NEW','DIRECT','C.DIREC','S','GONE')


