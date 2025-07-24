

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
		CAST(IIF(lm.locationNo='AKUREYRI'OR lm.parentLocationId=594,SUM(sl.STOCK_UNITS),0) AS DECIMAL(18,4)) AS totalstockAkureyri
	FROM
		adi.STOCK_LEVEL sl 
		JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
	GROUP BY sl.ITEM_NO, lm.locationNo, lm.parentLocationId
	),
	stockKauptun AS (

		SELECT
		CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
		CAST('KAUPTUN' AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(IIF(lm.locationNo='KAUPTUN'OR lm.parentLocationId=598,SUM(sl.STOCK_UNITS),0) AS DECIMAL(18,4)) AS totalstockKauptun
	FROM
		adi.STOCK_LEVEL sl 
		JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
	GROUP BY sl.ITEM_NO, lm.locationNo, lm.parentLocationId
	),
	stockKvoruhus AS (

		SELECT
		CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
		CAST('KVÖRUHÚS' AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(IIF(lm.locationNo='KVÖRUHÚS'OR lm.parentLocationId=600,SUM(sl.STOCK_UNITS),0) AS DECIMAL(18,4)) AS totalstockKvoruhus
	FROM
		adi.STOCK_LEVEL sl 
		JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
	GROUP BY sl.ITEM_NO, lm.locationNo, lm.parentLocationId
	),
	stockSelfoss AS (

		SELECT
		CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
		CAST('SELFOSS' AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(IIF(lm.locationNo='SELFOSS'OR lm.parentLocationId=603,SUM(sl.STOCK_UNITS),0) AS DECIMAL(18,4)) AS totalstockSelfoss
	FROM
		adi.STOCK_LEVEL sl 
		JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO
	GROUP BY sl.ITEM_NO, lm.locationNo, lm.parentLocationId
	)
    SELECT
        CAST(it.itemNo AS NVARCHAR(255)) AS ITEM_NO,
        CAST(isnull(SUM(ak.totalstockAkureyri),0) AS INT) AS stockAkureyri,
		CAST(isnull(SUM(ka.totalstockKauptun),0) AS INT) AS stockKauptun,
		CAST(isnull(SUM(kv.totalstockKvoruhus),0) AS INT) AS stockKvoruhus,
		CAST(isnull(SUM(se.totalstockSelfoss),0) AS INT) AS stockSelfoss
		from
		dbo.AGREssentials_items it
        LEFT JOIN stockAkureyri ak ON it.itemNo=ak.ITEM_NO AND ak.LOCATION_NO=it.locationNo
		LEFT JOIN stockKauptun ka ON it.itemNo=ka.ITEM_NO AND ka.LOCATION_NO=it.locationNo
		LEFT JOIN stockKvoruhus kv ON it.itemNo=kv.ITEM_NO AND kv.LOCATION_NO=it.locationNo
		LEFT JOIN stockSelfoss se ON it.itemNo=se.ITEM_NO AND se.LOCATION_NO=it.locationNo
	GROUP BY it.itemNo



