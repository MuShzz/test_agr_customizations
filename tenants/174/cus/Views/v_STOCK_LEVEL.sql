CREATE VIEW cus.v_STOCK_LEVEL
AS
SELECT 
	i.ITEMID as ITEM_NO,
	id.DATAAREAID AS LOCATION_NO,
	'01-01-2100' as EXPIRE_DATE, 
	CAST(ISNULL( SUM(ins.PhysicalInvent/ NULLIF(uc.Factor, 0)), -9999.) AS BIGINT) AS STOCK_UNITS,
	CAST(NULL AS DECIMAL(18,4))  AS [STOCK_LEVEL]
FROM cus.InventSum ins 
	inner join cus.InventDim id on ins.DATAAREAID = id.DATAAREAID and ins.INVENTDIMID = id.INVENTDIMID
	inner join cus.UnitConvert uc on uc.ITEMID = ins.ITEMID and uc.DATAAREAID = ins.DATAAREAID
	inner join cus.InventTableModule itm on itm.ITEMID = ins.ITEMID and uc.FROMUNIT = itm.UNITID and itm.DATAAREAID = ins.DATAAREAID
	inner join cus.INVENTTABLE i on i.ITEMID = ins.ITEMID
WHERE id.INVENTLOCATIONID IN('ADF','AFK')
	and itm.MODULETYPE=0
	and uc.TOUNIT='ks'
group by i.itemid, id.DATAAREAID
