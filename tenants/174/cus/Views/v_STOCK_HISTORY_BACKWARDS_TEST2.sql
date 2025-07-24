CREATE VIEW cus.v_STOCK_HISTORY_BACKWARDS_TEST2
AS

WITH STOCK_MOVE AS (
    SELECT 
        it.ITEMID               AS ITEM_NO,
        trans.DATEPHYSICAL      AS TXN_DATE,
        SUM(trans.Qty / uc.Factor) AS STOCK_MOVE,
        id.INVENTLOCATIONID     AS LOCATION_NO
    FROM cus.INVENTTRANS       trans 
    JOIN cus.INVENTDIM         id  
      ON trans.INVENTDIMID = id.INVENTDIMID
     AND trans.DATAAREAID  = id.DATAAREAID
    JOIN cus.INVENTTABLE      it  
      ON it.ITEMID      = trans.ITEMID
     AND it.DATAAREAID  = id.DATAAREAID
     AND it.ITEMTYPE   <> 2
    JOIN cus.UNITCONVERT     uc  
      ON uc.ITEMID      = trans.ITEMID
     AND uc.DATAAREAID  = id.DATAAREAID
     AND uc.TOUNIT     = 'ks'
     AND uc.FACTOR    <> 0
    JOIN cus.InventTableModule itm  
      ON itm.ITEMID      = trans.ITEMID
     AND uc.FROMUNIT    = itm.UNITID
     AND itm.DATAAREAID = id.DATAAREAID
     AND itm.MODULETYPE = 0
    JOIN core.location_mapping_setup lms
      ON lms.locationNo = id.INVENTLOCATIONID
    WHERE trans.DATEPHYSICAL > DATEADD(DAY, -100001, GETDATE())
    GROUP BY it.ITEMID, trans.DATEPHYSICAL, id.INVENTLOCATIONID
)

SELECT
    -- just a sequential key
    ROW_NUMBER() 
      OVER (ORDER BY sm.ITEM_NO, sm.TXN_DATE DESC)
      AS TRANSACTION_ID,

    CAST(sm.ITEM_NO   AS NVARCHAR(255)) AS ITEM_NO,
    CAST(sm.LOCATION_NO AS NVARCHAR(255)) AS LOCATION_NO,
    CAST(sm.TXN_DATE   AS DATE)           AS [DATE],

    -- the move itself, already aggregated in the CTE
    CAST(sm.STOCK_MOVE AS DECIMAL(18,4)) AS STOCK_MOVE,

    -- backwards‐dated stock level:
    --   current snapshot minus all moves that happened *after* this date
    CAST(
      s.STOCK_UNITS
      - SUM(sm.STOCK_MOVE) 
          OVER (
            PARTITION BY sm.ITEM_NO, sm.LOCATION_NO
            ORDER BY sm.TXN_DATE DESC
            ROWS BETWEEN UNBOUNDED PRECEDING 
                     AND 1 PRECEDING
          )
      AS DECIMAL(18,4)
    ) AS STOCK_LEVEL

FROM STOCK_MOVE sm
JOIN adi.STOCK_LEVEL s
  ON sm.ITEM_NO     = s.ITEM_NO
 AND sm.LOCATION_NO = s.LOCATION_NO

WHERE sm.STOCK_MOVE <> 0
  AND sm.TXN_DATE     > DATEADD(DAY, -100001, GETDATE())
;

