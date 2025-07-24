CREATE VIEW [fo_cus].[v_ITEM_LOCATION]
AS
WITH pos_one AS
(
    SELECT  pos.*,
            ROW_NUMBER() OVER
            (
                PARTITION BY pos.ItemNumber
                ORDER BY
                    CASE
                        WHEN COALESCE(CAST(pos.ProcurementQuantityMultiples AS DECIMAL(18,4)),0)
                             >= COALESCE(CAST(pos.MinimumProcurementOrderQuantity AS DECIMAL(18,4)),0)
                        THEN COALESCE(CAST(pos.ProcurementQuantityMultiples AS DECIMAL(18,4)),0)
                        ELSE COALESCE(CAST(pos.MinimumProcurementOrderQuantity AS DECIMAL(18,4)),0)
                    END DESC
            ) AS rn
    FROM fo.ProductOrderSettings AS pos
)
SELECT CAST(pei.ITEMNUMBER + CASE
                                 WHEN pei.[COVERAGEPRODUCTCONFIGURATIONID] IS NULL OR
                                      pei.[COVERAGEPRODUCTCONFIGURATIONID] = '' THEN ''
                                 ELSE '-' + ISNULL(pei.COVERAGEPRODUCTCONFIGURATIONID, '') END AS NVARCHAR(255)) AS [ITEM_NO]
     , CAST(pei.COVERAGEWAREHOUSEID AS NVARCHAR(255))                                                            AS [LOCATION_NO]
     , CAST(pei.REORDERPOINT AS DECIMAL(18, 4))                                                                  AS [REORDER_POINT]
     , CAST(pei.MINIMUMONHANDINVENTORYQUANTITY AS DECIMAL(18, 4))                                                AS [SAFETY_STOCK_UNITS]
     , CAST(NULL AS DECIMAL(18, 4))                                                                              AS [MIN_DISPLAY_STOCK]
     , CAST(pei.MAXIMUMONHANDINVENTORYQUANTITY AS DECIMAL(18, 4))                                                AS [MAX_STOCK]
     --, CAST(CASE WHEN REPLACE(p.PRODUCTLIFECYCLESTATEID,'none',9999) >= 750 THEN 1 ELSE 0 END AS BIT)			 AS [CLOSED]
	 , CAST(0 AS BIT)																							 AS [CLOSED]
     , CAST(NULL AS BIT)                                                                                         AS [CLOSED_FOR_ORDERING]
     , CAST(NULL AS NVARCHAR(255))                                                                               AS [RESPONSIBLE]
     , CAST(pi.PRODUCTNAME AS NVARCHAR(255))                                                                     AS [NAME]
     , CAST(NULL AS NVARCHAR(1000))                                                                              AS [DESCRIPTION]
     , CAST(p.PrimaryVendorAccountNumber AS NVARCHAR(255))                                                       AS [PRIMARY_VENDOR_NO]
     --,CAST(pos.PROCUREMENTLEADTIMEDAYS AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS]
     , CASE
           WHEN CAST(pos.ISPROCUREMENTUSINGWORKINGDAYS AS NVARCHAR(155)) = 'Yes' THEN dbo.fn_CalculateCalendarDays(
                   GETDATE(), CAST(pos.PROCUREMENTLEADTIMEDAYS AS SMALLINT))
           ELSE pos.PROCUREMENTLEADTIMEDAYS END                                                                  AS [PURCHASE_LEAD_TIME_DAYS]
     , CAST(NULL AS SMALLINT)                                                                                    AS [TRANSFER_LEAD_TIME_DAYS]
     , CAST(NULL AS SMALLINT)                                                                                    AS [ORDER_FREQUENCY_DAYS]
     , CAST(NULL AS SMALLINT)                                                                                    AS [ORDER_COVERAGE_DAYS]
     , CAST(pos.MINIMUMPROCUREMENTORDERQUANTITY AS DECIMAL(18, 4))                                               AS [MIN_ORDER_QTY]
     , CAST(NULL AS NVARCHAR(50))                                                                                AS [ORIGINAL_NO]
     , CAST(p.SALESPRICE AS DECIMAL(18, 4))                                                                      AS [SALE_PRICE]
     , CASE
           WHEN CAST(ISNULL(NULLIF(p.UNITCOSTQUANTITY, ''), p.UNITCOST) AS DECIMAL(18, 4)) = 0 THEN 0
           ELSE
               CAST(ISNULL(NULLIF(p.UNITCOST, ''), '1') AS DECIMAL(18, 4)) /
               CAST(ISNULL(NULLIF(p.UNITCOSTQUANTITY, ''), 1) AS DECIMAL(18, 4))
    END                                                                                                          AS [COST_PRICE]
     , CAST(p.PURCHASEPRICE AS DECIMAL(18, 4))                                                                   AS [PURCHASE_PRICE]
     , CAST(NULL AS DECIMAL(18, 4))                                                                              AS [ORDER_MULTIPLE]
     , CAST(p.PURCHASEPRICEQUANTITY AS DECIMAL(18, 4))                                                           AS [QTY_PALLET]
     , CAST(NULL AS DECIMAL(18, 4))                                                                              AS [VOLUME]
     , CAST(NULL AS DECIMAL(18, 4))                                                                              AS [WEIGHT]
     , CAST(1 AS BIT)                                                                                            AS [INCLUDE_IN_AGR]
     , CAST(NULL AS BIT)                                                                                         AS [SPECIAL_ORDER]
FROM fo_cus.[ProductExtraInfo] pei
         INNER JOIN fo_cus.[Products] p ON p.ITEMNUMBER = pei.ITEMNUMBER
         LEFT JOIN fo_cus.ProductInfo pi ON pei.ITEMNUMBER = pi.PRODUCTNUMBER
         LEFT JOIN pos_one pos ON pos.ItemNumber = pei.ItemNumber AND pos.rn= 1
WHERE pei.COVERAGEWAREHOUSEID IS NOT NULL
AND REPLACE(p.PRODUCTLIFECYCLESTATEID,'none',9999) < 750 AND pei.PRODUCTCOVERAGEGROUPID NOT LIKE '%MTO%'
