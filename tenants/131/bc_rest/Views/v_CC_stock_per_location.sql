
-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns stock per locations
--
-- 19.03.2025.BF	Created
-- ===============================================================================


CREATE VIEW [bc_rest_cus].[v_CC_stock_per_location]
AS

    SELECT
        CAST(sl.ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
        CAST(sl.LOCATION_NO AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(IIF(lm.locationNo='00',sl.STOCK_UNITS,0) AS DECIMAL(18,4)) AS birgdir00,
		CAST(IIF(lm.locationNo='01',sl.STOCK_UNITS,0) AS DECIMAL(18,4)) AS birgdir01,
		CAST(IIF(lm.locationNo='02',sl.STOCK_UNITS,0) AS DECIMAL(18,4)) AS birgdir02,
		CAST(IIF(lm.locationNo='03',sl.STOCK_UNITS,0) AS DECIMAL(18,4)) AS birgdir03,
		CAST(IIF(lm.locationNo='06',sl.STOCK_UNITS,0) AS DECIMAL(18,4)) AS birgdir06
    FROM
        adi.STOCK_LEVEL sl
        JOIN core.location_mapping_setup lm ON lm.locationNo = sl.LOCATION_NO



