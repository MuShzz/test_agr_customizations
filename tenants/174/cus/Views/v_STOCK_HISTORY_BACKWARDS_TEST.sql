CREATE VIEW cus.v_STOCK_HISTORY_BACKWARDS_TEST AS
WITH STOCK_MOVE AS (
    SELECT 
        it.ITEMID               AS ITEM_NO,
        trans.DATEPHYSICAL      AS [DATE],
        SUM(trans.Qty / uc.Factor) AS STOCK_MOVE,
        id.INVENTLOCATIONID     AS LOCATION_NO
    FROM cus.INVENTTRANS trans 
    INNER JOIN cus.INVENTDIM id 
        ON trans.INVENTDIMID   = id.INVENTDIMID 
       AND id.DATAAREAID       = trans.DATAAREAID
    INNER JOIN cus.INVENTTABLE it 
        ON it.ITEMID           = trans.ITEMID 
       AND it.DATAAREAID       = id.DATAAREAID 
       AND it.ITEMTYPE       <> 2
    INNER JOIN cus.UNITCONVERT uc 
        ON uc.ITEMID           = trans.ITEMID 
       AND uc.DATAAREAID       = id.DATAAREAID 
       AND uc.TOUNIT          = 'ks' 
       AND uc.FACTOR         <> 0
    INNER JOIN cus.InventTableModule itm 
        ON itm.ITEMID          = trans.ITEMID 
       AND uc.FROMUNIT        = itm.UNITID 
       AND itm.DATAAREAID      = id.DATAAREAID 
       AND itm.MODULETYPE     = 0
    INNER JOIN core.location_mapping_setup lms 
        ON lms.locationNo      = id.INVENTLOCATIONID
    WHERE trans.DATEPHYSICAL > '2007-09-01'
    GROUP BY it.ITEMID, trans.DATEPHYSICAL, id.INVENTLOCATIONID
)
SELECT
    ROW_NUMBER() OVER (
      ORDER BY CAST(sm.ITEM_NO AS NVARCHAR(255)) DESC
    )                                           AS [TRANSACTION_ID],

    CAST(sm.ITEM_NO     AS NVARCHAR(255))       AS [ITEM_NO],
    CAST(sm.LOCATION_NO AS NVARCHAR(255))       AS [LOCATION_NO],
    CAST(sm.[DATE]      AS DATE)                AS [DATE],

    -- just the move itself, one row per item+location+date
    CAST(sm.STOCK_MOVE AS DECIMAL(18,4))        AS [STOCK_MOVE],

    -- backwards‐dated level: snapshot minus all moves after this date
    CAST(
      s.STOCK_UNITS
      - COALESCE(
          SUM(sm.STOCK_MOVE) OVER (
            PARTITION BY sm.ITEM_NO, sm.LOCATION_NO
            ORDER BY sm.[DATE] DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
          )
        , 0)
      AS DECIMAL(18,4)
    )                                           AS [STOCK_LEVEL]

FROM STOCK_MOVE sm
INNER JOIN adi.STOCK_LEVEL s 
    ON sm.ITEM_NO     = s.ITEM_NO
   AND sm.LOCATION_NO = s.LOCATION_NO

WHERE 
    sm.STOCK_MOVE <> 0;

