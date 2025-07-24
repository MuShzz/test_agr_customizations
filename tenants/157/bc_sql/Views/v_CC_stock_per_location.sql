


-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns stock per locations
--
-- 19.03.2025.BF	Created
-- ===============================================================================


CREATE VIEW [bc_sql_cus].[v_CC_stock_per_location]
AS

	WITH stockAkureyri AS (
		SELECT
		CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
		CAST('AKUREYRI' AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(IIF(lm.locationNo='AKUREYRI'OR lm.parentLocationId=1155,SUM(sl.STOCK_UNITS),0) AS DECIMAL(18,4)) AS totalstockAkureyri
	FROM
		adi.STOCK_LEVEL sl 
		JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
	GROUP BY sl.ITEM_NO, lm.locationNo, lm.parentLocationId
	),
	stockBildshofdi AS (

		SELECT
		CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
		CAST('BÍLDSHÖFÐI' AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(IIF(lm.locationNo='BÍLDSHÖFÐI'OR lm.parentLocationId=1156,SUM(sl.STOCK_UNITS),0) AS DECIMAL(18,4)) AS totalstockBildshofdi
	FROM
		adi.STOCK_LEVEL sl 
		JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
	GROUP BY sl.ITEM_NO, lm.locationNo, lm.parentLocationId
	),
	stockFitjar AS (

		SELECT
		CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
		CAST('FITJAR' AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(IIF(lm.locationNo='FITJAR'OR lm.parentLocationId=1159,SUM(sl.STOCK_UNITS),0) AS DECIMAL(18,4)) AS totalstockFitjar
	FROM
		adi.STOCK_LEVEL sl 
		JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
	GROUP BY sl.ITEM_NO, lm.locationNo, lm.parentLocationId
	),
	stockGrandi AS (

		SELECT
		CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
		CAST('GRANDI' AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(IIF(lm.locationNo='GRANDI'OR lm.parentLocationId=1161,SUM(sl.STOCK_UNITS),0) AS DECIMAL(18,4)) AS totalstockGrandi
	FROM
		adi.STOCK_LEVEL sl 
		JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
	GROUP BY sl.ITEM_NO, lm.locationNo, lm.parentLocationId
	),
	stockSelfoss AS (

		SELECT
		CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
		CAST('SELFOSS' AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(IIF(lm.locationNo='SELFOSS'OR lm.parentLocationId=1163,SUM(sl.STOCK_UNITS),0) AS DECIMAL(18,4)) AS totalstockSelfoss
	FROM
		adi.STOCK_LEVEL sl 
		JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
	GROUP BY sl.ITEM_NO, lm.locationNo, lm.parentLocationId
	),
	stockSkeifan AS (

		SELECT
		CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
		CAST('SKEIFAN' AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(IIF(lm.locationNo='SKEIFAN'OR lm.parentLocationId=1165,SUM(sl.STOCK_UNITS),0) AS DECIMAL(18,4)) AS totalstockSkeifan
	FROM
		adi.STOCK_LEVEL sl 
		JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
	GROUP BY sl.ITEM_NO, lm.locationNo, lm.parentLocationId
	),
	stockSmaratorg AS (

		SELECT
		CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
		CAST('SMÁRATORG' AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(IIF(lm.locationNo='SMÁRATORG'OR lm.parentLocationId=1166,SUM(sl.STOCK_UNITS),0) AS DECIMAL(18,4)) AS totalstockSmaratorg
	FROM
		adi.STOCK_LEVEL sl 
		JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
	GROUP BY sl.ITEM_NO, lm.locationNo, lm.parentLocationId
	),
	stockVoruhus AS (

	SELECT
		CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
		CAST('VÖRUHÚS' AS NVARCHAR(255)) AS LOCATION_NO,
		--CAST(IIF(lm.locationNo='VÖRUHÚS'OR lm.parentLocationId=1169,SUM(sl.STOCK_UNITS),0) AS DECIMAL(18,4)) AS totalstockVoruhus --22.07.2025.GM Removed OR lm.parentLocationId=1169
		CAST(IIF(lm.locationNo='VÖRUHÚS',SUM(sl.STOCK_UNITS),0) AS DECIMAL(18,4)) AS totalstockVoruhus
	FROM
		adi.STOCK_LEVEL sl 
		JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
	GROUP BY sl.ITEM_NO, lm.locationNo, lm.parentLocationId
	)

    SELECT
        CAST(it.itemNo AS NVARCHAR(255)) AS ITEM_NO,
        CAST(ISNULL(SUM(ak.totalstockAkureyri),0) AS INT) AS stockAkureyri,
		CAST(ISNULL(SUM(bi.totalstockBildshofdi),0) AS INT) AS stockBildshofdi,
		CAST(ISNULL(SUM(fi.totalstockFitjar),0) AS INT) AS stockFitjar,
		CAST(ISNULL(SUM(gr.totalstockGrandi),0) AS INT) AS stockGrandi,
		CAST(ISNULL(SUM(se.totalstockSelfoss),0) AS INT) AS stockSelfoss,
		CAST(ISNULL(SUM(sk.totalstockSkeifan),0) AS INT) AS stockSkeifan,
		CAST(ISNULL(SUM(sm.totalstockSmaratorg),0) AS INT) AS stockSmaratorg,
		CAST(ISNULL(SUM(vo.totalstockVoruhus),0) AS INT) AS stockVoruhus
	FROM
		dbo.AGREssentials_items it
        LEFT JOIN stockAkureyri ak ON it.itemNo=ak.ITEM_NO AND ak.LOCATION_NO=it.locationNo
		LEFT JOIN stockBildshofdi bi ON it.itemNo=bi.ITEM_NO AND bi.LOCATION_NO=it.locationNo
		LEFT JOIN stockFitjar fi ON it.itemNo=fi.ITEM_NO AND fi.LOCATION_NO=it.locationNo
		LEFT JOIN stockGrandi gr ON it.itemNo=gr.ITEM_NO AND gr.LOCATION_NO=it.locationNo
		LEFT JOIN stockSelfoss se ON it.itemNo=se.ITEM_NO AND se.LOCATION_NO=it.locationNo
		LEFT JOIN stockSkeifan sk ON it.itemNo=sk.ITEM_NO AND sk.LOCATION_NO=it.locationNo
		LEFT JOIN stockSmaratorg sm ON it.itemNo=sm.ITEM_NO AND sm.LOCATION_NO=it.locationNo
		LEFT JOIN stockVoruhus vo ON it.itemNo=vo.ITEM_NO AND vo.LOCATION_NO=it.locationNo
	GROUP BY it.itemNo


