CREATE VIEW [ax_cus].[v_PRODUCT_PURCHASE_INFO_UNIT_CONVERSION]
AS
    
SELECT DISTINCT pinf.NO                     AS [NO],
                pinf.No_TO_JOIN_IL          AS [PRODUCT_NO],
                pinf.NAME                   AS [NAME],
                itm_purch.UNITID            AS purch_unit,
                itm_invent.UNITID           AS invent_unit,
                uom_con_invent.FACTOR       AS FACTOR,
                NULL                        AS FACTOR2,
                CASE
                    WHEN uom_con_invent.FACTOR IS NOT NULL THEN uom_con_invent.FACTOR
                    WHEN itm_purch.UNITID = 'stk' AND itm_invent.UNITID = 'stk' AND LEN(itm_purch.CESECONDARYUNITID) < 1
                        THEN 1
                    WHEN itm_purch.UNITID = itm_invent.UNITID AND itm_purch.CESECONDARYUNITID = itm_purch.UNITID THEN 1
                    ELSE 1
                    END                     AS ORDER_MULTIPLE,
                itm_purch.CESECONDARYUNITID AS [purch_CESECONDARYUNITID]
        ,
                1                           AS condition
FROM ax_cus.INVENTTABLE it
         INNER JOIN ax_cus.Item_v pinf ON pinf.No_TO_JOIN_IL = it.ITEMID
         LEFT JOIN ax_cus.INVENTTABLEMODULE itm_purch
                   ON itm_purch.ITEMID = it.ITEMID AND itm_purch.MODULETYPE = 1 -- Purch er gildið 1
         LEFT JOIN ax_cus.INVENTTABLEMODULE itm_invent
                   ON itm_invent.ITEMID = it.ITEMID AND itm_invent.MODULETYPE = 0 -- Invent er gildið 0
         LEFT JOIN ax_cus.UNITOFMEASURE uom_purch ON uom_purch.SYMBOL = itm_purch.UNITID
         LEFT JOIN ax_cus.UNITOFMEASURE uom_invent ON uom_invent.SYMBOL = itm_invent.UNITID
         LEFT JOIN ax_cus.UNITOFMEASURECONVERSION uom_con_purch ON uom_con_purch.PRODUCT = it.PRODUCT
    AND uom_con_purch.FROMUNITOFMEASURE = uom_purch.RECID
    AND uom_con_purch.PARTITION = it.PARTITION
         LEFT JOIN ax_cus.UNITOFMEASURECONVERSION uom_con_invent ON uom_con_invent.PRODUCT = it.PRODUCT
    AND uom_con_invent.TOUNITOFMEASURE = uom_invent.RECID
    AND uom_con_invent.FROMUNITOFMEASURE = uom_purch.RECID --- 23.03.2022.GH 
    AND uom_con_invent.PARTITION = it.PARTITION

WHERE NOT (itm_purch.UNITID = itm_invent.UNITID
    AND itm_purch.UNITID != itm_purch.CESECONDARYUNITID
    )

UNION ALL

-- 23.03.2022.GH		To handle secondary units (itm_purch.CESECONDARYUNITID)
-- 24.03.2022.ÞG		Forcing duplicate lines to take the higher value (MAX)
SELECT [NO],
       [PRODUCT_NO],
       [NAME],
       purch_unit,
       invent_unit,
       FACTOR,
       MAX(Factor2)        AS Factor2,
       MAX(ORDER_MULTIPLE) AS ORDER_MULTIPLE,
       [purch_CESECONDARYUNITID],
       condition
FROM (SELECT DISTINCT pinf.NO                     AS [NO],
                      pinf.No_TO_JOIN_IL          AS [PRODUCT_NO],
                      pinf.NAME                   AS [NAME],
                      itm_purch.UNITID            AS purch_unit,
                      itm_invent.UNITID           AS invent_unit,
                      uom_con_invent.FACTOR       AS FACTOR,
                      uom_con_invent2.FACTOR      AS Factor2,
                      CASE
                          WHEN itm_purch.UNITID = 'stk' AND itm_invent.UNITID = 'stk' AND
                               LEN(itm_purch.CESECONDARYUNITID) < 1 THEN 1
                          WHEN itm_purch.UNITID = itm_invent.UNITID AND itm_purch.CESECONDARYUNITID = itm_purch.UNITID
                              THEN 1
                          WHEN uom_con_invent2.FACTOR IS NOT NULL THEN uom_con_invent2.FACTOR
                          ELSE NULL
                          END                     AS ORDER_MULTIPLE,
                      itm_purch.CESECONDARYUNITID AS [purch_CESECONDARYUNITID]
              ,
                      2                           AS condition
      FROM ax_cus.INVENTTABLE it
               INNER JOIN ax_cus.Item_v pinf ON pinf.No_TO_JOIN_IL = it.ITEMID
               LEFT JOIN ax_cus.INVENTTABLEMODULE itm_purch
                         ON itm_purch.ITEMID = it.ITEMID AND itm_purch.MODULETYPE = 1 -- Purch er gildið 1
               LEFT JOIN ax_cus.INVENTTABLEMODULE itm_invent
                         ON itm_invent.ITEMID = it.ITEMID AND itm_invent.MODULETYPE = 0 -- Invent er gildið 0
               LEFT JOIN ax_cus.UNITOFMEASURE uom_purch ON uom_purch.SYMBOL = itm_purch.UNITID
               LEFT JOIN ax_cus.UNITOFMEASURE uom_invent ON uom_invent.SYMBOL = itm_invent.UNITID
               LEFT JOIN ax_cus.UNITOFMEASURE uom_invent_secondary
                         ON uom_invent_secondary.SYMBOL = itm_purch.CESECONDARYUNITID
               LEFT JOIN ax_cus.UNITOFMEASURECONVERSION uom_con_purch ON uom_con_purch.PRODUCT = it.PRODUCT
          AND uom_con_purch.FROMUNITOFMEASURE = uom_purch.RECID
          AND uom_con_purch.PARTITION = it.PARTITION
               LEFT JOIN ax_cus.UNITOFMEASURECONVERSION uom_con_invent ON uom_con_invent.PRODUCT = it.PRODUCT
          AND uom_con_invent.TOUNITOFMEASURE = uom_invent.RECID
          AND uom_con_invent.FROMUNITOFMEASURE = uom_purch.RECID --- 23.03.2022.GH 
          AND uom_con_invent.PARTITION = it.PARTITION
               LEFT JOIN ax_cus.UNITOFMEASURECONVERSION uom_con_invent2 ON uom_con_invent2.PRODUCT = it.PRODUCT
          AND uom_con_invent2.TOUNITOFMEASURE = uom_invent.RECID

      WHERE 1 = 1
        AND itm_purch.UNITID = itm_invent.UNITID
        AND itm_purch.UNITID != itm_purch.CESECONDARYUNITID) [secondary]
GROUP BY [NO], [PRODUCT_NO], [NAME],
         purch_unit, invent_unit, FACTOR,
         [purch_CESECONDARYUNITID], condition
