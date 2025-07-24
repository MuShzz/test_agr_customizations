
CREATE VIEW [fo_cus].[v_ITEM]
AS
			SELECT DISTINCT
			CAST(p.ITEMNUMBER + CASE WHEN pei.[COVERAGEPRODUCTCONFIGURATIONID] IS NULL OR pei.[COVERAGEPRODUCTCONFIGURATIONID] = '' 
			THEN CASE WHEN sl.[PRODUCTCONFIGURATIONID] IS NULL OR sl.[PRODUCTCONFIGURATIONID] = '' THEN '' 
            ELSE '-' + sl.PRODUCTCONFIGURATIONID 
            END
			ELSE '-' + ISNULL(pei.COVERAGEPRODUCTCONFIGURATIONID, '')
			END AS NVARCHAR(255)
			)                                                                           AS [NO]
		   --CAST(p.ItemNumber + CASE WHEN pei.[COVERAGEPRODUCTCONFIGURATIONID] IS NULL OR pei.[COVERAGEPRODUCTCONFIGURATIONID] = '' THEN '' ELSE '-' + ISNULL(pei.COVERAGEPRODUCTCONFIGURATIONID, '')END AS NVARCHAR(255)) AS [NO]                        
          ,CAST(pi.PRODUCTNAME AS NVARCHAR(255))                                        AS [NAME]
          ,CAST(p.ITEMNUMBER AS NVARCHAR(255))                                          AS [PRODUCT_NO]
          ,CAST(pi.PRODUCTNAME AS NVARCHAR(255))                                        AS [PRODUCT_NAME]
          ,CAST(NULL AS NVARCHAR(50))                                                   AS [SIZE_NO]
          ,CAST(NULL AS NVARCHAR(50))                                                   AS [COLOUR_NO]
          ,CAST(NULL AS NVARCHAR(50))                                                   AS [STYLE_NO]
          --,CAST(d.productdescription AS NVARCHAR(1000)) AS [DESCRIPTION]
		  ,CAST(pi.PRODUCTDESCRIPTION AS NVARCHAR(255))                                 AS [DESCRIPTION]
          ,CAST(p.PRIMARYVENDORACCOUNTNUMBER AS NVARCHAR(255))                          AS [PRIMARY_VENDOR_NO]
          --,CAST(pos.PROCUREMENTLEADTIMEDAYS AS SMALLINT)                                AS [PURCHASE_LEAD_TIME_DAYS]
          ,CASE WHEN CAST(pos.ISPROCUREMENTUSINGWORKINGDAYS AS NVARCHAR(155)) = 'Yes' THEN dbo.fn_CalculateCalendarDays(GETDATE(), CAST(pos.PROCUREMENTLEADTIMEDAYS AS SMALLINT)) ELSE pos.PROCUREMENTLEADTIMEDAYS END AS [PURCHASE_LEAD_TIME_DAYS]
          ,CAST(NULL AS SMALLINT)                                                       AS [ORDER_FREQUENCY_DAYS]
          ,CAST(NULL AS SMALLINT)                                                       AS [ORDER_COVERAGE_DAYS]
          ,CAST(pos.MINIMUMPROCUREMENTORDERQUANTITY AS DECIMAL(18,4))                   AS [MIN_ORDER_QTY]
          ,CAST(p.ITEMNUMBER AS NVARCHAR(50))                                           AS [ORIGINAL_NO]
          ,CAST(0 AS BIT)                                                               AS [CLOSED]
          ,CAST(p.BUYERGROUPID AS NVARCHAR(255))                                        AS [RESPONSIBLE]
          ,CAST(ISNULL( NULLIF(p.SALESPRICE,''),'0') AS DECIMAL(18,4))                  AS [SALE_PRICE]
		  ,CASE WHEN CAST(ISNULL(NULLIF(p.UNITCOSTQUANTITY, ''), p.UNITCOST) AS DECIMAL(18,4)) = 0 THEN 0 ELSE 
           CAST(ISNULL(NULLIF(p.UNITCOST, ''), '1') AS DECIMAL(18,4)) / CAST(ISNULL(NULLIF(p.UNITCOSTQUANTITY, ''), 1) AS DECIMAL(18,4))
		   END AS [COST_PRICE]          
		  ,CAST(pos.PROCUREMENTQUANTITYMULTIPLES AS DECIMAL(18,4))                      AS [ORDER_MULTIPLE]
		  ,CAST(p.PURCHASEUNITSYMBOL AS NVARCHAR(55))                                   AS [PURCHASE_UNIT_OF_MEASURE]
          --,CAST(p.StandardPalletQty AS INT) AS [QTY_PALLET]
          --,CAST(p.qtyPerLayer AS INT) AS [QTY_PALLET_LAYER]
		  ,CAST(0 AS DECIMAL(18,4))                                                     AS [QTY_PALLET]
          ,CAST(1 AS DECIMAL(18,4))                                                     AS [QTY_PER_PURCHASE_UNIT]
          ,CAST(ISNULL( NULLIF(p.PRODUCTVOLUME,''),'0') AS DECIMAL(18,4))               AS [VOLUME]
          ,CAST(ISNULL( NULLIF(p.NETPRODUCTWEIGHT,''),'0') AS DECIMAL(18,4))            AS [WEIGHT]
          ,CAST(0 AS DECIMAL(18,4))                                                     AS [SAFETY_STOCK_UNITS]
          ,CAST(NULL AS DECIMAL(18,4))                                                  AS [MIN_DISPLAY_STOCK]
          ,CAST(NULL AS DECIMAL(18,4))                                                  AS [MAX_STOCK]
          ,CAST(NULL AS DATE) AS [TERMINAL_DATE]
		  ,CAST(pos.INVENTORYLEADTIMEDAYS AS SMALLINT)                                  AS [TRANSFER_LEAD_TIME_DAYS]
          ,CAST(p.PRODUCTGROUPID AS NVARCHAR(255))                                      AS [ITEM_GROUP_NO_LVL_1]
          ,CAST(p.SEARCHNAME AS NVARCHAR(255))                                          AS [ITEM_GROUP_NO_LVL_2]
          ,CAST(NULL AS NVARCHAR(255))                                                  AS [ITEM_GROUP_NO_LVL_3]
          ,CAST(p.PURCHASEPRICE AS NVARCHAR(255))                                       AS [PURCHASE_PRICE]
          ,CAST(p.PURCHASEUNITSYMBOL AS NVARCHAR(50))                                   AS [BASE_UNIT_OF_MEASURE]
          ,CAST(1 AS BIT)                                                               AS [INCLUDE_IN_AGR]
          ,CAST(0 AS BIT)                                                               AS [CLOSED_FOR_ORDERING]
		  ,CAST(0 AS BIT)                                                               AS [SPECIAL_ORDER]
		  ,CAST(0 AS DECIMAL(18,4))                                                     AS [REORDER_POINT]
       FROM fo_cus.Products p
	   LEFT JOIN fo.ProductOrderSettings pos ON pos.ITEMNUMBER = p.ITEMNUMBER
	   LEFT JOIN fo_cus.ProductInfo pi ON p.ITEMNUMBER = pi.PRODUCTNUMBER
	   LEFT JOIN fo.ProductExtraInfo pei ON pei.ITEMNUMBER = p.ITEMNUMBER
	   LEFT JOIN fo.StockLevel sl ON sl.ITEMNUMBER = p.ITEMNUMBER
	   WHERE pi.PRODUCTNAME IS NOT NULL

