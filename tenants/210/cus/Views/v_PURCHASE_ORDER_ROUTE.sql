CREATE VIEW [cus].v_PURCHASE_ORDER_ROUTE AS
    SELECT
       CAST(isp.ItemCode AS nvarchar(255))                          AS [ITEM_NO],
       CAST(isp.WarehouseCode AS nvarchar(255))                     AS [LOCATION_NO],
       CAST(isp.SupplierCode AS nvarchar(255))                      AS [VENDOR_NO],
       CAST(iif(ispl.IsPriority=1,1,0) AS bit)                      AS [PRIMARY],
       CAST(iif(isp.LeadTime=0,NULL,isp.LeadTime) AS smallint)      AS [LEAD_TIME_DAYS],
       CAST(s_ord_freq.settingValue AS smallint)                    AS [ORDER_FREQUENCY_DAYS],
       CAST(ISNULL(isp.MOQ_C,0) AS decimal(18,4))                   AS [MIN_ORDER_QTY],
       CAST(NULL AS decimal(18,4))                                  AS [COST_PRICE],
       CAST(ispl.BaseCost AS decimal(18,4))                         AS [PURCHASE_PRICE],
       CAST(isp.UsualQtyOrder AS decimal(18,4))                     AS [ORDER_MULTIPLE],
       CAST(NULL AS decimal(18,4))                                  AS [QTY_PALLET]
    from cus.InventorySupplier isp
        LEFT JOIN cus.InventoryUnitMeasure ium              ON ium.ItemCode=isp.ItemCode AND ium.IsDefault=1
        OUTER APPLY (
                SELECT TOP 1 *
                FROM cus.InventorySupplierPricingLevel ispl_sub
                WHERE ispl_sub.ItemCode = isp.ItemCode AND ispl_sub.SupplierCode=isp.SupplierCode and ispl_sub.UnitMeasureCode=ium.UnitMeasureCode
                ORDER BY ispl_sub.LineNum desc
            ) ispl
        INNER JOIN core.setting s_ord_freq                  ON s_ord_freq.settingKey='inventory_order_frequency_days_default'
        inner join core.location_mapping_setup lms          on lms.locationNo=isp.WarehouseCode
