
CREATE VIEW [fo_cus].[v_ITEM_LOCATION]
AS
SELECT CAST(pei.ITEMNUMBER + CASE
                                 WHEN pei.[COVERAGEPRODUCTCONFIGURATIONID] IS NULL OR
                                      pei.[COVERAGEPRODUCTCONFIGURATIONID] = '' THEN ''
                                 ELSE '-' + ISNULL(pei.COVERAGEPRODUCTCONFIGURATIONID, '') END AS NVARCHAR(255)) AS [ITEM_NO]
     , CAST(pei.COVERAGEWAREHOUSEID AS NVARCHAR(255))                                                            AS [LOCATION_NO]
     , CAST(pei.REORDERPOINT AS DECIMAL(18, 4))                                                                  AS [REORDER_POINT]
     , CAST(pei.MINIMUMONHANDINVENTORYQUANTITY AS DECIMAL(18, 4))                                                AS [SAFETY_STOCK_UNITS]
     , CAST(NULL AS DECIMAL(18, 4))                                                                              AS [MIN_DISPLAY_STOCK]
     , CAST(pei.MAXIMUMONHANDINVENTORYQUANTITY AS DECIMAL(18, 4))                                                AS [MAX_STOCK]
     , CAST(0 AS BIT)                                                                                            AS [CLOSED]
     , CAST(NULL AS BIT)                                                                                         AS [CLOSED_FOR_ORDERING]
     , CAST(NULL AS NVARCHAR(255))                                                                               AS [RESPONSIBLE]
     , CAST(pi.PRODUCTNAME AS NVARCHAR(255))                                                                     AS [NAME]
     , CAST(NULL AS NVARCHAR(1000))                                                                              AS [DESCRIPTION]
     , CAST(pei.VENDORACCOUNTNUMBER AS NVARCHAR(255))                                                            AS [PRIMARY_VENDOR_NO]
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
FROM fo.[ProductExtraInfo] pei
         INNER JOIN fo.[Products] p ON p.ITEMNUMBER = pei.ITEMNUMBER
         LEFT JOIN fo_cus.ProductInfo pi ON pei.ITEMNUMBER = pi.PRODUCTNUMBER
         LEFT JOIN fo.ProductOrderSettings pos ON pos.ITEMNUMBER = pei.ITEMNUMBER
WHERE pei.COVERAGEWAREHOUSEID IS NOT NULL

