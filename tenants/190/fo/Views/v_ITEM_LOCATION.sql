CREATE VIEW [fo_cus].[v_ITEM_LOCATION]
AS
SELECT CAST(p.ITEMNUMBER AS NVARCHAR(255))																		AS [ITEM_NO]
     , CAST('01' AS NVARCHAR(255))																				AS [LOCATION_NO]
     , CAST(0 AS DECIMAL(18, 4))																				AS [REORDER_POINT]
     , CAST(p.MINQTY AS DECIMAL(18, 4))																			AS [SAFETY_STOCK_UNITS]
     , CAST(null AS DECIMAL(18, 4))                                                                              AS [MIN_DISPLAY_STOCK]
     , CAST(p.MAXQTY AS DECIMAL(18, 4))																				AS [MAX_STOCK]
     , CAST(0 AS BIT)                                                                                            AS [CLOSED]
     , CAST(NULL AS BIT)                                                                                         AS [CLOSED_FOR_ORDERING]
     , CAST(NULL AS NVARCHAR(255))                                                                               AS [RESPONSIBLE]
     , CAST(pi.PRODUCTNAME AS NVARCHAR(255))                                                                     AS [NAME]
     , CAST(NULL AS NVARCHAR(1000))                                                                              AS [DESCRIPTION]
     , CAST(p.PRIMARYVENDORACCOUNTNUMBER AS NVARCHAR(255))                                                            AS [PRIMARY_VENDOR_NO]
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
FROM fo_cus.[products] p
         LEFT JOIN fo_cus.ProductInfo pi ON p.ITEMNUMBER = pi.PRODUCTNUMBER
         LEFT JOIN fo.ProductOrderSettings pos ON pos.ITEMNUMBER = p.ITEMNUMBER

