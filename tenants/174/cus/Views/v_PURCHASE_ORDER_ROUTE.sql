
CREATE VIEW [cus].[v_PURCHASE_ORDER_ROUTE]
AS
SELECT DISTINCT
    CAST(it.ITEMID AS NVARCHAR(255))						AS [ITEM_NO],
    --CAST(dim.INVENTLOCATIONID AS NVARCHAR(255))			AS [LOCATION_NO],
	CAST('ADF' AS NVARCHAR(255))							AS [LOCATION_NO],
    CAST(it.PRIMARYVENDORID AS NVARCHAR(255))				AS [VENDOR_NO],
    CAST(1 AS BIT)      AS [PRIMARY],
    CAST(CASE 
			WHEN it.CEAGRLEADTIME >0 THEN it.CEAGRLEADTIME
		ELSE v.AGRDeliveryTime	
		END AS SMALLINT)									AS [LEAD_TIME_DAYS],
    CAST(NULL AS SMALLINT)									AS [ORDER_FREQUENCY_DAYS],
    CAST(iips.LowestQty / 
		CASE uc.Factor 
			WHEN 0 THEN 1 
		ELSE uc.Factor 
		END AS DECIMAL(18, 4))								AS [MIN_ORDER_QTY],
    CAST(MAX(uc.Factor * itm.Price / 
		CASE itm.PriceUnit 
			WHEN 0 THEN 1 
		ELSE itm.PriceUnit 
		END) AS DECIMAL(18, 4))								AS [COST_PRICE],
    CAST(itm.PRICE AS DECIMAL(18, 4))						AS [PURCHASE_PRICE],
    CAST(CEILING((CASE iips.MultipleQty 
					WHEN 0 THEN 1 
				ELSE iips.MultipleQty 
				END)/
				(CASE uc.Factor 
					WHEN 0 THEN 1 
				ELSE uc.Factor 
				END)) AS DECIMAL(18, 4))					AS [ORDER_MULTIPLE], 
    CAST(it.AGRStandardPalletQuantity  AS DECIMAL(18, 4))   AS [QTY_PALLET]
FROM cus.INVENTTABLE it
	INNER JOIN cus.DataAreas da ON da.company_id=it.DATAAREAID
	INNER JOIN cus.UnitConvert uc ON uc.ITEMID=it.ITEMID 
	INNER JOIN cus.INVENTITEMPURCHSETUP iips ON iips.ITEMID=it.ITEMID AND iips.DATAAREAID=it.DATAAREAID
	INNER JOIN cus.VENDTABLE v ON v.ACCOUNTNUM = it.PRIMARYVENDORID AND v.DATAAREAID=da.company_id
	INNER JOIN cus.INVENTTABLEMODULE itm ON itm.ITEMID=it.ITEMID AND itm.DATAAREAID=da.company_id AND itm.UNITID=uc.FROMUNIT
	INNER JOIN cus.INVENTDIM AS dim ON dim.INVENTDIMID = iips.INVENTDIMIDDEFAULT AND dim.DATAAREAID = iips.DATAAREAID
WHERE uc.ToUnit='ks'
	--and FROMUNIT='stk'
	AND itm.MODULETYPE=0
	AND (CASE 
			WHEN it.CESPECIALPURCHASE = 1 THEN 1
		ELSE ISNULL(it.AGRBlocked,0) 
		END) = 0
	--AND it.ITEMID IN ('127099','128869')
	--AND CAST(dim.INVENTLOCATIONID AS NVARCHAR(255)) = 'AFK'
GROUP BY it.ITEMID, 
		it.PRIMARYVENDORID, 
		iips.LOWESTQTY, 
		iips.MULTIPLEQTY, 
		uc.FACTOR, 
		it.CEAGRLEADTIME, 
		v.AGRDELIVERYTIME, 
		it.AGRStandardPalletQuantity, 
		it.AGRQtyPerLayer,
		dim.INVENTLOCATIONID,
		iips.LEADTIME,
		itm.PRICE,
		iips.DATAAREAID 

