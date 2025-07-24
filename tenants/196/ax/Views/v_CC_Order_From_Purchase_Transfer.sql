


-- ===============================================================================
-- Author:      Grétar Magnússon
-- Description: Custom Column to define order routes for items
--
-- 09.07.2025.GM   Created
-- ===============================================================================

CREATE VIEW [ax_cus].[v_CC_Order_From_Purchase_Transfer] AS

	SELECT DISTINCT 
		CAST(it.[ITEMID]
			+ CASE WHEN id2.INVENTSIZEID  <> '' AND id2.INVENTSIZEID IS NOT NULL THEN '_' + id2.INVENTSIZEID ELSE '' END
			+ CASE WHEN id2.INVENTCOLORID <> '' AND id2.INVENTCOLORID IS NOT NULL THEN '_' + id2.INVENTCOLORID ELSE '' END
			+ CASE WHEN id2.INVENTSTYLEID <> '' AND id2.INVENTSTYLEID IS NOT NULL THEN '_' + id2.INVENTSTYLEID ELSE '' END 
			AS NVARCHAR(255))																								AS [ItemNo],
		CASE
			WHEN
				id.INVENTSITEID IS NULL
				THEN id2.INVENTLOCATIONID--(SELECT STRING_AGG(locationNo,',') FROM core.location_mapping_setup WHERE isVirtual = 0)
			ELSE
				CONCAT('LAG',id.INVENTSITEID)
		END																													AS [Location],
		CASE
			WHEN
				req.INVENTLOCATIONIDREQMAIN IS NULL
				THEN it.PRIMARYVENDORID
			ELSE
				IIF(req.INVENTLOCATIONIDREQMAIN = '',it.PRIMARYVENDORID,req.INVENTLOCATIONIDREQMAIN)
		END																													AS [Supplier],				
       IIF(ISNULL(req.REQPOTYPE,0) = 0,'Purchase', 'Transfer')																AS [OrderFromType]
	FROM
		ax_cus.INVENTTABLE it
		LEFT JOIN ax_cus.REQITEMTABLE req	ON req.ITEMID = it.ITEMID
		LEFT JOIN ax.INVENTDIM id			ON id.INVENTDIMID = req.COVINVENTDIMID AND ISNULL(id.DATAAREAID,'byko') = it.DATAAREAID		
		LEFT JOIN ax.INVENTTRANS itt		ON itt.ITEMID = it.ITEMID AND itt.DATAAREAID = it.DATAAREAID
		LEFT JOIN ax.INVENTDIM id2			ON id2.INVENTDIMID = itt.INVENTDIMID AND id2.DATAAREAID = itt.DATAAREAID
		INNER JOIN core.location_mapping_setup lms ON lms.locationNo = id2.INVENTLOCATIONID AND lms.isVirtual = 0
	--WHERE 
	--	it.ITEMID IN ('0011226','94910061')


