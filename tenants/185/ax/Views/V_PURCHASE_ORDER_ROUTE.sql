



CREATE VIEW [ax_cus].[V_PURCHASE_ORDER_ROUTE]
AS
        SELECT CAST(iips.ITEMID AS NVARCHAR(255)) AS [ITEM_NO],
               CAST(lms.locationNo AS NVARCHAR(255)) AS [LOCATION_NO],
               CAST(CASE
                        WHEN it.PRIMARYVENDORID = '' THEN
                            'vendor_missing'
                        ELSE
                            it.PRIMARYVENDORID
                    END AS NVARCHAR(255)) AS [VENDOR_NO],
               CAST(1 AS BIT) AS [PRIMARY],
               CAST(CASE
                        WHEN iips.LEADTIME > 0 THEN
                            iips.LEADTIME
                        ELSE
                            NULL
                    END AS SMALLINT) AS [LEAD_TIME_DAYS],
               CAST(CASE
                        WHEN v.AGRORDERFREQUENCY IS NOT NULL
                             AND v.AGRORDERFREQUENCY <> 0 THEN
                            v.AGRORDERFREQUENCY
                        ELSE
                            NULL
                    END AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],
               CAST(iips.LOWESTQTY AS DECIMAL(18, 4)) AS [MIN_ORDER_QTY],
               CAST(inv.PRICE AS DECIMAL(18, 4)) AS [COST_PRICE],
               CAST(pur.PRICE AS DECIMAL(18, 4)) AS [PURCHASE_PRICE],
               CAST(CASE
                        WHEN iips.MULTIPLEQTY < 1
                             OR iips.MULTIPLEQTY IS NULL THEN
                            1
                        ELSE
                            iips.MULTIPLEQTY
                    END * CAST(ISNULL(STK.FACTOR, 1) AS DECIMAL(18, 4)) AS DECIMAL(18, 4)) AS [ORDER_MULTIPLE],
               CAST(ISNULL(it.CEPALLETQTY, 1) AS DECIMAL(18, 4)) AS [QTY_PALLET],
               CAST(iips.DATAAREAID AS NVARCHAR(4)) AS [COMPANY]
        FROM ax.INVENTITEMPURCHSETUP AS iips
            CROSS JOIN core.location_mapping_setup lms
            INNER JOIN ax_cus.DataAreas da
                ON iips.PARTITION = da.PARTITION
                   AND iips.DATAAREAID = da.DATAAREAID
            INNER JOIN ax.INVENTDIM AS dim
                ON dim.INVENTDIMID = iips.INVENTDIMID
                   AND dim.DATAAREAID = iips.DATAAREAID
                   AND dim.PARTITION = iips.PARTITION
            LEFT JOIN ax_cus.INVENTTABLEMODULE AS inv
                ON inv.ITEMID = iips.ITEMID
                   AND inv.MODULETYPE = 0 /* INVENTORY */
                   AND inv.DATAAREAID = iips.DATAAREAID
                   AND inv.PARTITION = iips.PARTITION
            LEFT JOIN ax_cus.INVENTTABLEMODULE AS pur
                ON pur.ITEMID = iips.ITEMID
                   AND pur.MODULETYPE = 1 /* PURCHASE */
                   AND pur.DATAAREAID = iips.DATAAREAID
                   AND pur.PARTITION = iips.PARTITION
            INNER JOIN ax_cus.INVENTTABLE it
                ON it.ITEMID = iips.ITEMID
                   AND it.DATAAREAID = iips.DATAAREAID
            LEFT JOIN ax.VENDTABLE v
                ON it.PRIMARYVENDORID = v.ACCOUNTNUM
                   AND v.DATAAREAID = it.DATAAREAID
            LEFT JOIN
            (
                SELECT DISTINCT  it.[PRODUCT],
                       [FACTOR],
                       uomc.[PARTITION],
                       itm.ITEMID,
                       itm.DATAAREAID
                FROM ax_cus.[UNITOFMEASURECONVERSION] uomc
                    INNER JOIN ax_cus.DataAreas da
                        ON uomc.PARTITION = da.PARTITION
                    JOIN ax_cus.[UNITOFMEASURE] uom_from
                        ON uomc.[FROMUNITOFMEASURE] = uom_from.[RECID]
                           AND uomc.[PARTITION] = uom_from.[PARTITION]
                    JOIN ax_cus.[UNITOFMEASURE] uom_to
                        ON uomc.[TOUNITOFMEASURE] = uom_to.[RECID]
                           AND uomc.[PARTITION] = uom_to.[PARTITION]
                    JOIN ax_cus.INVENTTABLEMODULE itm
                        ON itm.UNITID = uom_from.symbol
                           AND da.DATAAREAID = itm.DATAAREAID
                           AND da.PARTITION = itm.PARTITION
                    INNER JOIN ax_cus.INVENTTABLE it
                        ON da.DATAAREAID = it.DATAAREAID
                           AND da.PARTITION = it.PARTITION
                           AND it.PRODUCT = uomc.PRODUCT
                           AND it.ITEMID = itm.ITEMID
                WHERE uom_to.[SYMBOL] = 'STK'
            ) STK
                ON STK.PRODUCT = it.PRODUCT
                   AND STK.[PARTITION] = iips.[PARTITION]
                   AND STK.ITEMID = iips.ITEMID
                   AND STK.DATAAREAID = da.DATAAREAID
WHERE iips.INVENTDIMID = 'AllBlank'

