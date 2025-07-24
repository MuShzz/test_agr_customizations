

CREATE VIEW [ax_cus].[v_UNDELIVERED_PURCHASE_ORDER] 
AS

	SELECT
		CAST(CONCAT('Innkaupapöntun ', p.PURCHID) AS VARCHAR(128))																			AS [PURCHASE_ORDER_NO],
		CAST(it.[ITEMID]
			+ CASE WHEN id.INVENTSIZEID  <> '' AND id.INVENTSIZEID IS NOT NULL THEN '_' + id.INVENTSIZEID ELSE '' END
			+ CASE WHEN id.INVENTCOLORID <> '' AND id.INVENTCOLORID IS NOT NULL THEN '_' + id.INVENTCOLORID ELSE '' END
			+ CASE WHEN id.INVENTSTYLEID <> '' AND id.INVENTSTYLEID IS NOT NULL THEN '_' + id.INVENTSTYLEID ELSE '' END AS NVARCHAR(255))   AS ITEM_NO,
		CAST(id.INVENTLOCATIONID AS NVARCHAR(255))																							AS [LOCATION_NO],
		CAST(p.DELIVERYDATE AS DATE)																										AS [DELIVERY_DATE],
		CAST(SUM(it.QTY) AS DECIMAL(18,4))																									AS [QUANTITY],
		CAST(it.DATAAREAID AS NVARCHAR(4))																									AS [COMPANY]
	FROM
		ax.INVENTTRANS it
		INNER JOIN ax_cus.INVENTTRANSORIGIN ito		ON ito.RECID = it.INVENTTRANSORIGIN AND it.DATAAREAID = ito.DATAAREAID AND it.PARTITION = ito.PARTITION
		INNER JOIN ax.INVENTDIM id					ON id.inventdimid = it.inventdimid AND id.DATAAREAID = it.DATAAREAID AND id.PARTITION = ito.PARTITION
		INNER JOIN ax_cus.PURCHTABLE p				ON p.PURCHID = ito.REFERENCEID AND p.DATAAREAID = ito.DATAAREAID AND p.PARTITION = ito.PARTITION
		INNER JOIN ax.INVENTTABLE pip				ON pip.ITEMID		= it.ITEMID
		INNER JOIN core.location_mapping_setup lms ON lms.locationNo=id.INVENTLOCATIONID
	WHERE 
		ito.REFERENCECATEGORY = 3				-- Stock movement from purchase orders
		AND it.QTY > 0							-- positive movement into stock => returns
		AND it.STATUSISSUE <> 1
		AND it.DATEPHYSICAL = '1900-01-01 00:00:00.000'  -- When an item comes in house the record has a DatePhysical value and is added to stock level, is no longer undelivered
		AND p.PURCHSTATUS = 1  --- Status = Open order -> None: 0 („empty“),Backorder: 1 (Open order),Received: 2, Invoiced: 3 ,Canceled: 4
		AND p.documentstate = 40 -- Approval status = Confirmed -> Draft: 0, InReview: 10, Rejected: 20, Approved: 30, InExternalReview: 35, Finalized: 50, Confirmed: 40
		AND it.DATAAREAID = 'byko'			-- getfunction
		AND it.PARTITION = '5637144576'		-- get from core.setting
		--AND p.PURCHID = '2044548'
	GROUP BY 
		CAST(CONCAT('Innkaupapöntun ', p.PURCHID) AS VARCHAR(128)),
		it.[ITEMID]
			+ CASE WHEN id.INVENTSIZEID  <> '' AND id.INVENTSIZEID IS NOT NULL THEN '_' + id.INVENTSIZEID ELSE '' END
			+ CASE WHEN id.INVENTCOLORID <> '' AND id.INVENTCOLORID IS NOT NULL THEN '_' + id.INVENTCOLORID ELSE '' END
			+ CASE WHEN id.INVENTSTYLEID <> '' AND id.INVENTSTYLEID IS NOT NULL THEN '_' + id.INVENTSTYLEID ELSE '' END,
		id.INVENTLOCATIONID,
		p.DELIVERYDATE,
		it.DATAAREAID

