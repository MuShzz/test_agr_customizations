
CREATE VIEW [ax_cus].[V_PURCHASE_ORDER_ROUTE]
AS
SELECT
    CAST(i.ITEM_NO AS NVARCHAR(255))					AS [ITEM_NO],
    CAST('Myl' AS NVARCHAR(255))						AS [LOCATION_NO],
    Cast(CASE 
			 WHEN reqdim.REQPOTYPEACTIVE = 1 AND reqdim.REQPOTYPE = 2 AND orderfrom_req.[NO] IS NOT NULL THEN orderfrom_req.[NO] -- Item coverage set to Transfer
			 WHEN reqdim.REQPOTYPEACTIVE = 1 AND reqdim.REQPOTYPE = 0 AND reqdim.ITEMCOVFIELDSACTIVE = 0 and primvend.[NO] is not null THEN primvend.[NO] -- Item coverage set to Purchase
			 WHEN reqdim.REQPOTYPEACTIVE = 1 AND reqdim.REQPOTYPE = 0 AND reqdim.ITEMCOVFIELDSACTIVE = 1 and orderfrom_req_vend.[NO] is not null THEN orderfrom_req_vend.[NO] -- Item coverage set to Purchase and supplier set in item coverage
			 WHEN (reqdim.REQPOTYPEACTIVE = 0 OR reqdim.REQPOTYPEACTIVE IS NULL) AND il.REQREFILL = 1 and orderfrom.[NO] is not null THEN orderfrom.[NO] -- Warehose default set to Transfer
			 WHEN (reqdim.REQPOTYPEACTIVE = 0 OR reqdim.REQPOTYPEACTIVE IS NULL) AND il.REQREFILL = 0 and primvend.[NO] is not null THEN primvend.[NO] -- No Warehose default
			 WHEN (reqdim.REQPOTYPEACTIVE = 0 OR reqdim.REQPOTYPEACTIVE IS NULL) AND il.REQREFILL = 0 AND reqdim.ITEMCOVFIELDSACTIVE = 1 and orderfrom_req_vend.[NO]  is not null THEN orderfrom_req_vend.[NO] -- No Warehose default and supplier set in item coverage
		ELSE 'vendor_missing' 
		END as nvarchar(255))							AS [VENDOR_NO],
    CAST(1 AS BIT)										AS [PRIMARY],
    CAST((CASE 
			WHEN ip.LEADTIME = 0 
			THEN ISNULL(vt.AGRDeliveryTime,1) 
			ELSE 
			ISNULL(ip.LEADTIME,1)
		END) AS SMALLINT)								AS [LEAD_TIME_DAYS],
    CAST(NULL AS SMALLINT)                              AS [ORDER_FREQUENCY_DAYS],
    CAST(CASE 
			--Transfer
			WHEN (reqdim.REQPOTYPEACTIVE = 1 AND reqdim.REQPOTYPE = 2) THEN  ISNULL(site_spec_iis.LOWESTQTY,ISNULL(iis.LOWESTQTY,1)) -- Item coverage set to Transfer and Site specific values set
			WHEN (reqdim.REQPOTYPEACTIVE = 0 OR reqdim.REQPOTYPEACTIVE IS NULL) AND il.REQREFILL = 1 THEN ISNULL(site_spec_iis.LOWESTQTY,ISNULL(iis.LOWESTQTY,1)) --  Warehose default set to Transfer and Site specific values set
			--Purchase
			WHEN reqdim.REQPOTYPEACTIVE = 1 AND reqdim.REQPOTYPE = 0 THEN ISNULL(site_spec_ips.LOWESTQTY,ISNULL(ips.LOWESTQTY,1)) -- Item coverage set to Purchase and Site specific values set
			WHEN (reqdim.REQPOTYPEACTIVE = 0 OR reqdim.REQPOTYPEACTIVE IS NULL) AND il.REQREFILL = 0 THEN ISNULL(site_spec_ips.LOWESTQTY,ISNULL(ips.LOWESTQTY,1)) -- No Warehose default and Site specific values set
			 ELSE 1
		END AS decimal(18,4))							AS [MIN_ORDER_QTY],
    CAST(ISNULL(itm.Price,0) AS [decimal](18,4))                   AS [COST_PRICE],
    CAST(NULL AS DECIMAL(18, 4))                   AS [PURCHASE_PRICE],
    CAST((CASE 
			--Transfer
			WHEN (reqdim.REQPOTYPEACTIVE = 1 AND reqdim.REQPOTYPE = 2) THEN ISNULL(site_spec_iis.MULTIPLEQTY,ISNULL(iis.MULTIPLEQTY,1)) -- Item coverage set to Transfer and Site specific values set
			WHEN (reqdim.REQPOTYPEACTIVE = 0 OR reqdim.REQPOTYPEACTIVE IS NULL) AND il.REQREFILL = 1 THEN  ISNULL(site_spec_iis.MULTIPLEQTY,ISNULL(iis.MULTIPLEQTY,1)) --  Warehose default set to Transfer and Site specific values set
			--Purchase
			WHEN reqdim.REQPOTYPEACTIVE = 1 AND reqdim.REQPOTYPE = 0 THEN ISNULL(site_spec_ips.MULTIPLEQTY,ISNULL(ips.MULTIPLEQTY,1)) -- Item coverage set to Purchase and Site specific values set
			WHEN (reqdim.REQPOTYPEACTIVE = 0 OR reqdim.REQPOTYPEACTIVE IS NULL) AND il.REQREFILL = 0 THEN ISNULL(site_spec_ips.MULTIPLEQTY,ISNULL(ips.MULTIPLEQTY,1)) -- No Warehose default and Site specific values set
			 ELSE 1
		END) AS decimal(18,4))            AS [ORDER_MULTIPLE],
    CAST(isnull(intable.CEPALLETQTY,1) AS DECIMAL(18, 4))                        AS [QTY_PALLET],
    CAST(i.COMPANY AS NVARCHAR(4))                AS [COMPANY]
FROM  
ax_cus.v_ITEM_LOCATION i
INNER JOIN ax_cus.v_LOCATION l on l.[NO] = i.location_no and l.[NO] = 'Myl'
LEFT JOIN ax_cus.vendtable vt ON i.PRIMARY_VENDOR_NO = vt.accountnum AND vt.dataareaid = 'mfk' --21.04.2021 BOB
INNER JOIN [ax_cus].[INVENTLOCATION] il ON l.[NO] = il.INVENTLOCATIONID 
LEFT JOIN (
SELECT req.ITEMID,dim.INVENTLOCATIONID,dim.INVENTSIZEID,dim.INVENTCOLORID,dim.INVENTSTYLEID,req.INVENTLOCATIONIDREQMAIN, req.LEADTIMETRANSFER, req.LEADTIMEPURCHASE, req.[LEADTIMEPURCHASEACTIVE], req.[LEADTIMETRANSFERACTIVE], req.REQPOTYPE,req.REQPOTYPEACTIVE,req.MININVENTONHAND,req.MAXINVENTONHAND,req.VENDID,req.ITEMCOVFIELDSACTIVE,req.[PARTITION],req.DATAAREAID
  FROM ax_cus.REQITEMTABLE req
  INNER JOIN ax_cus.INVENTDIM dim ON dim.INVENTDIMID=req.COVINVENTDIMID AND req.[PARTITION]=dim.[PARTITION] and req.DATAAREAID=dim.DATAAREAID
  GROUP BY req.ITEMID,dim.INVENTLOCATIONID,dim.INVENTSIZEID,dim.INVENTCOLORID,dim.INVENTSTYLEID,req.INVENTLOCATIONIDREQMAIN, req.LEADTIMETRANSFER, req.LEADTIMEPURCHASE, req.[LEADTIMEPURCHASEACTIVE], req.[LEADTIMETRANSFERACTIVE], req.REQPOTYPE,req.REQPOTYPEACTIVE,req.MININVENTONHAND,req.MAXINVENTONHAND,req.VENDID,req.ITEMCOVFIELDSACTIVE,req.[PARTITION],req.DATAAREAID
  HAVING REQPOTYPE = MAX(REQPOTYPE) --(1:Purchase order, 1:Production, 2:Transfer, 3:Kanban)
  ) reqdim ON i.ITEM_NO = reqdim.ITEMID  AND i.location_no=reqdim.INVENTLOCATIONID 
LEFT JOIN ax_cus.v_VENDOR orderfrom ON orderfrom.[NO] = il.[INVENTLOCATIONIDREQMAIN]
LEFT JOIN ax_cus.v_VENDOR orderfrom_req ON orderfrom_req.[NO] = reqdim.[INVENTLOCATIONIDREQMAIN]
LEFT JOIN ax_cus.v_VENDOR  orderfrom_req_vend ON orderfrom_req_vend.[NO] = reqdim.[VENDID]
LEFT JOIN ax_cus.v_VENDOR  primvend ON primvend.[NO] = i.PRIMARY_VENDOR_NO
LEFT JOIN ax_cus.INVENTTABLE intable ON intable.ITEMID = i.ITEM_NO 
LEFT JOIN ax.InventTableModule itm ON i.ITEM_NO = itm.ItemId AND itm.ModuleType = 0 --1:purchase orders, 0:inventory
LEFT JOIN ax_cus.INVENTITEMPURCHSETUP ip ON ip.ITEMID = intable.ITEMID and ip.INVENTDIMID = 'AllBlank'


	--Site specific order values
	LEFT JOIN (
		SELECT ip.ITEMID, id.INVENTSITEID, id2.INVENTLOCATIONID, CASE WHEN ip.MULTIPLEQTY = 0 THEN 1 ELSE ip.MULTIPLEQTY END AS MULTIPLEQTY, ip.LOWESTQTY, ip.HIGHESTQTY, ip.STANDARDQTY, ip.LEADTIME, ip.[PARTITION], ip.DATAAREAID 
		FROM  [ax_cus].[INVENTITEMPURCHSETUP] ip
		INNER JOIN  [ax_cus].[INVENTDIM] id ON id.INVENTDIMID = ip.INVENTDIMID AND ip.DATAAREAID = id.DATAAREAID AND ip.[PARTITION] = id.[PARTITION]
		INNER JOIN  [ax_cus].[INVENTDIM] id2 ON id2.INVENTDIMID = ip.INVENTDIMIDDEFAULT AND ip.DATAAREAID = id2.DATAAREAID AND ip.[PARTITION] = id2.[PARTITION]
		WHERE ip.[OVERRIDE] = 1
	) site_spec_ips ON site_spec_ips.ITEMID = i.ITEM_NO AND site_spec_ips.INVENTSITEID = il.INVENTSITEID AND site_spec_ips.INVENTLOCATIONID = il.INVENTLOCATIONID
	LEFT JOIN (
		SELECT ii.ITEMID, id.INVENTSITEID, id2.INVENTLOCATIONID, CASE WHEN ii.MULTIPLEQTY = 0 THEN 1 ELSE ii.MULTIPLEQTY END AS MULTIPLEQTY, ii.LOWESTQTY, ii.HIGHESTQTY, ii.STANDARDQTY, ii.LEADTIME, ii.[PARTITION], ii.DATAAREAID  
		FROM  [ax_cus].[INVENTITEMINVENTSETUP] ii
		INNER JOIN [ax_cus].[INVENTDIM] id ON id.INVENTDIMID = ii.INVENTDIMID
		INNER JOIN [ax_cus].[INVENTDIM] id2 ON id2.INVENTDIMID = ii.INVENTDIMIDDEFAULT
		WHERE ii.[OVERRIDE] = 1
	) site_spec_iis ON site_spec_iis.ITEMID = i.ITEM_NO  AND site_spec_iis.INVENTSITEID = il.INVENTSITEID AND site_spec_iis.INVENTLOCATIONID = il.INVENTLOCATIONID 
	--Default order values
	LEFT JOIN (
		SELECT ip.ITEMID, CASE WHEN ip.MULTIPLEQTY = 0 THEN 1 ELSE ip.MULTIPLEQTY END AS MULTIPLEQTY, ip.LOWESTQTY, ip.HIGHESTQTY, ip.STANDARDQTY, ip.LEADTIME, ip.[PARTITION], ip.DATAAREAID 
		FROM  [ax_cus].[INVENTITEMPURCHSETUP] ip
		INNER JOIN  [ax_cus].[INVENTDIM] id ON id.INVENTDIMID = ip.INVENTDIMID AND ip.DATAAREAID = id.DATAAREAID AND ip.[PARTITION] = id.[PARTITION]
		WHERE id.INVENTSITEID = '' OR  id.INVENTSITEID = 'AllBlank'
	) ips ON ips.ITEMID = i.ITEM_NO 
	LEFT JOIN (
		SELECT ii.ITEMID, CASE WHEN ii.MULTIPLEQTY = 0 THEN 1 ELSE ii.MULTIPLEQTY END AS MULTIPLEQTY, ii.LOWESTQTY, ii.HIGHESTQTY, ii.STANDARDQTY, ii.LEADTIME, ii.[PARTITION], ii.DATAAREAID  
		FROM  [ax_cus].[INVENTITEMINVENTSETUP] ii
		INNER JOIN [ax_cus].[INVENTDIM] id ON id.INVENTDIMID = ii.INVENTDIMID AND ii.DATAAREAID = id.DATAAREAID AND ii.[PARTITION] = id.[PARTITION]
		WHERE id.INVENTSITEID = '' OR  id.INVENTSITEID = 'AllBlank'
	) iis ON iis.ITEMID = i.ITEM_NO 
	LEFT JOIN (
		SELECT DISTINCT [PRODUCT],[FACTOR],uomc.[PARTITION]
		FROM [ax_cus].[UNITOFMEASURECONVERSION] uomc
		JOIN [ax_cus].[UNITOFMEASURE] uom_from ON uomc.[FROMUNITOFMEASURE] = uom_from.[RECID] AND uomc.[PARTITION] = uom_from.[PARTITION]
		JOIN [ax_cus].[UNITOFMEASURE] uom_to ON uomc.[TOUNITOFMEASURE] = uom_to.[RECID] AND uomc.[PARTITION] = uom_to.[PARTITION]
		WHERE uom_from.[SYMBOL] = 'Layer' AND uom_to.[SYMBOL] = 'Ea'
	) layer ON layer.PRODUCT = intable.PRODUCT 
	LEFT JOIN (
		SELECT DISTINCT [PRODUCT],[FACTOR],uomc.[PARTITION]
		FROM [ax_cus].[UNITOFMEASURECONVERSION] uomc
		JOIN [ax_cus].[UNITOFMEASURE] uom_from ON uomc.[FROMUNITOFMEASURE] = uom_from.[RECID] AND uomc.[PARTITION] = uom_from.[PARTITION]
		JOIN [ax_cus].[UNITOFMEASURE] uom_to ON uomc.[TOUNITOFMEASURE] = uom_to.[RECID] AND uomc.[PARTITION] = uom_to.[PARTITION]
		WHERE uom_from.[SYMBOL] = 'Pallet' AND uom_to.[SYMBOL] = 'Ea'
	) pallet ON pallet.PRODUCT = intable.PRODUCT 

