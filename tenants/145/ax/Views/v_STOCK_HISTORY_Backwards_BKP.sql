CREATE VIEW [ax_cus].[v_STOCK_HISTORY_Backwards_BKP]
AS
WITH stock_history AS
         (SELECT pinf.NO             AS ITEM_NO,
                 id.INVENTLOCATIONID AS LOCATION_NO,
                 it.DATEPHYSICAL     AS [DATE],
                 SUM(it.QTY)         AS STOCK_MOVE
          FROM ax.INVENTTRANS it
                   INNER JOIN ax_cus.INVENTDIM id
                              ON id.inventdimid = it.inventdimid AND id.DATAAREAID = it.DATAAREAID AND
                                 id.[PARTITION] = it.[PARTITION]
                   INNER JOIN ax_cus.Item_v pinf
                              ON pinf.No_TO_JOIN_IL = it.ITEMID AND pinf.COLOUR_NO = id.INVENTCOLORID AND
                                 pinf.SIZE_NO = id.INVENTSIZEID AND pinf.STYLE_NO = id.INVENTSTYLEID
                                  AND pinf.company = id.DATAAREAID
          WHERE it.DATEPHYSICAL <> '1900-01-01 00:00:00.000'
            AND pinf.CLOSED = 0
          GROUP BY it.DATEPHYSICAL,
                   pinf.NO,
                   id.INVENTLOCATIONID),
     stock_level AS (SELECT ins.ITEMID              AS [ITEM_NO],
                            iv.INVENTLOCATIONID     AS [LOCATION_NO],
                            SUM(ins.PHYSICALINVENT) AS [STOCK_UNITS]
                     FROM [ax].INVENTSUM ins
                              INNER JOIN
                          [ax].INVENTDIM iv
                          ON iv.INVENTDIMID = ins.INVENTDIMID
                              AND iv.DATAAREAID = ins.DATAAREAID
                              AND iv.PARTITION = ins.PARTITION
                     WHERE CAST(ins.PHYSICALINVENT AS DECIMAL(18, 4)) > 0
                       AND iv.INVENTLOCATIONID <> ''
                     GROUP BY ins.[ITEMID], iv.INVENTLOCATIONID)
SELECT sl.item_no                                AS ITEM_NO,
       sl.LOCATION_NO                            AS LOCATION_NO,
       CAST(SH.[DATE] AS DATE)                   AS [DATE],
       CAST(0 AS DECIMAL(18, 4))              AS STOCK_MOVE,
       CAST(ISNULL(sl.stock_units + SUM(-sh.stock_move) OVER (
           ORDER BY sh.[date] DESC
           ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
           ), sl.stock_units) AS DECIMAL(18, 4)) AS STOCK_LEVEL,
       CAST(NULL AS BIGINT)                      AS [TRANSACTION_ID]
FROM stock_level sl
         LEFT JOIN stock_history sh
                   ON sh.item_no = sl.item_no
                       AND sh.location_no = sl.location_no
                       AND CAST(SH.[DATE] AS DATE) IS NOT NULL
