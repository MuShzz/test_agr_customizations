

-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns stock per locations
--
-- 19.03.2025.BF	Created
-- ===============================================================================


CREATE VIEW [bc_rest_cus].[v_CC_stock_per_location]
AS

	WITH stockVerslun AS (
		SELECT
			CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
			CAST(SUM(sl.STOCK_UNITS) AS DECIMAL(18,4)) AS totalstockVerslun
		FROM
			adi.STOCK_LEVEL sl 
			JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
		WHERE lm.locationNo='VERSLUN'
		--AND sl.ITEM_NO='REE-S6-H001'
		GROUP BY sl.ITEM_NO
	),
	
	stockVoruhus AS (
		SELECT
			CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
			CAST(SUM(sl.STOCK_UNITS) AS DECIMAL(18,4)) AS totalstockVoruhus
		FROM
			adi.STOCK_LEVEL sl 
			JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
		WHERE lm.locationNo IN ('VÖRUHÚS','VÖRUHÚS_IN','BAKOVT')
		--AND sl.ITEM_NO='REE-S6-H001'
		GROUP BY sl.ITEM_NO
	)
    SELECT
        CAST(it.itemNo AS NVARCHAR(255)) AS ITEM_NO,
        CAST(isnull(SUM(ver.totalstockVerslun),0) AS INT) AS stockVerslun,
		CAST(isnull(SUM(vor.totalstockVoruhus),0) AS INT) AS stockVoruhus
	from
		dbo.AGREssentials_items it
        LEFT JOIN stockVerslun ver ON it.itemNo=ver.ITEM_NO
		LEFT JOIN stockVoruhus vor ON it.itemNo=vor.ITEM_NO
	--WHERE it.itemNo='REE-S6-H001'
	GROUP BY it.itemNo



