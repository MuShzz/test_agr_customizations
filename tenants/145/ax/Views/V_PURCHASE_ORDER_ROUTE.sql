
CREATE VIEW [ax_cus].[V_PURCHASE_ORDER_ROUTE]
AS
SELECT DISTINCT CAST(pinf.[NO] AS NVARCHAR(255))                                       AS [ITEM_NO],
                CAST(id.INVENTLOCATIONID AS NVARCHAR(255))                             AS [LOCATION_NO],
                CAST(vendext.CUSTVENDRELATION AS NVARCHAR(255))                        AS [VENDOR_NO],
                CAST(IIF(vendext.CUSTVENDRELATION <> it.PRIMARYVENDORID, 0, 1) AS BIT) AS [PRIMARY],
                CAST(CASE
                         WHEN id.INVENTLOCATIONID = '13' AND vendext.CUSTVENDRELATION = '4501993469' THEN 2 -- Aðföng
                         WHEN id.INVENTLOCATIONID = '10' AND vendext.CUSTVENDRELATION = '4107911299'
                             THEN 0 --Kökugerð HP (Flatköku)
                         WHEN vendext.CUSTVENDRELATION = '6002692089' THEN 0 -- Sláturfélag Suðurlands
                         --WHEN vendext.CUSTVENDRELATION = '5303901289' THEN 0 --Bananar 04.07.2025.GM Removed by request of Jóna Dóra/Rannveig
                         WHEN req.LEADTIMEPURCHASE > 0 THEN req.LEADTIMEPURCHASE -- Gildi niður á staðsetningu
                         WHEN iips.LEADTIME > 0
                             THEN iips.LEADTIME -- Global gildi ef það er ekki til gildi niður á staðsetningu
                         ELSE 1
                    END AS SMALLINT)                                                   AS LEAD_TIME_DAYS,
                CAST(
                        CASE
                            WHEN it.REQGROUPID = 'transit'
                                THEN 7 -- 20.01.2022.GH Use same logic as for transit colum in item_extra_info
                            WHEN v.AGRORDERFREQUENCY IS NOT NULL AND v.AGRORDERFREQUENCY <> 0 THEN v.AGRORDERFREQUENCY
                            WHEN it.AGRORDERFREQUENCY <> 0 AND it.AGRORDERFREQUENCY IS NOT NULL
                                THEN it.AGRORDERFREQUENCY
                            --WHEN v.VENDGROUP = 'Erl'											THEN 7		-- 19.01.2022.GH Við höldum að þetta séu transit vörur
                            ELSE 7 -- by Rannveig comment "we should change it to 7 and if they have any items they need to order daily they will create a schedule for it"
                            END AS SMALLINT)                                           AS [ORDER_FREQUENCY_DAYS],

                CAST(iips.LOWESTQTY AS DECIMAL(18, 4))                                 AS [MIN_ORDER_QTY],
				CAST(NULL AS DECIMAL(18,4))												AS[PURCHASE_PRICE],
                CAST(itm.PRICE AS DECIMAL(18, 4))                                      AS [COST_PRICE],
                CAST(CASE
                         WHEN unit_conversion.ORDER_MULTIPLE IS NOT NULL THEN IIF(unit_conversion.ORDER_MULTIPLE < 1, 1,
                                                                                  unit_conversion.ORDER_MULTIPLE) -- 26.01.2023.ÞG Put 1 we get 0 there
                         WHEN unit_conversion.ORDER_MULTIPLE IS NULL
                             THEN IIF(iips.MULTIPLEQTY < 1, 1, iips.MULTIPLEQTY) -- 01.03.2022.GH Put 1 we get 0 there
                         ELSE IIF(ISNULL(unit_conversion.FACTOR, 0) < 1, 1,
                                  unit_conversion.FACTOR) -- 01.03.2022.GH Put 1 we get 0 there
                    END AS DECIMAL(18, 4))                                             AS ORDER_MULTIPLE,

                CAST(NULL AS INT)                                                      AS QTY_PALLET,
                CAST(NULL AS INT)                                                      AS [QTY_PALLET_LAYER]

FROM ax_cus.INVENTTABLE it
         INNER JOIN ax_cus.REQITEMTABLE req ON it.ITEMID = req.ITEMID
         INNER JOIN ax_cus.INVENTDIM id ON id.INVENTDIMID = req.COVINVENTDIMID
         INNER JOIN core.location_mapping_setup l ON l.locationNo = id.INVENTLOCATIONID
         INNER JOIN ax_cus.VENDTABLE v ON it.PRIMARYVENDORID = v.ACCOUNTNUM AND v.DATAAREAID = it.DATAAREAID
         INNER JOIN ax_cus.Item_v pinf
                    ON pinf.No_TO_JOIN_IL = it.ITEMID AND pinf.COLOUR_NO = id.INVENTCOLORID AND pinf.SIZE_NO = id.INVENTSIZEID
         INNER JOIN ax.INVENTITEMPURCHSETUP iips ON iips.ITEMID = pinf.NO
         INNER JOIN ax_cus.INVENTTABLEMODULE itm ON itm.ItemId = pinf.NO
         INNER JOIN ax.CUSTVENDEXTERNALITEM vendext ON it.ITEMID = vendext.ITEMID
         LEFT JOIN ax_cus.v_PRODUCT_PURCHASE_INFO_UNIT_CONVERSION unit_conversion ON pinf.NO = unit_conversion.NO
WHERE id.INVENTSITEID = '01'
  AND itm.MODULETYPE = 0 -- 0: Purchase orders
  AND vendext.MODULETYPE = '3'
  --AND pinf.NO = '1243555'

