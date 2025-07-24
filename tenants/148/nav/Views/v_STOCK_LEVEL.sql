
-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Stock level from NAV to adi format
--
-- 09.10.2024.TO    Created
-- ===============================================================================
CREATE VIEW [nav_cus].[v_STOCK_LEVEL]
AS

    SELECT
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST(ile.[Location Code] AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(IIF(ile.[Expiration Date]='1753-01-01 00:00:00.0000000', DATEFROMPARTS(2100, 1, 1),ile.[Expiration Date]) AS DATE) AS EXPIRE_DATE,
        CAST(SUM(ile.Quantity) - COALESCE(sl.TotalServiceQuantity, 0) AS DECIMAL(18,4)) AS STOCK_UNITS
	FROM
        [nav].ItemLedgerEntry ile
        JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[Location Code]
		LEFT JOIN  (
        -- Pre-aggregate ServiceLine to ensure only ONE row per ItemNo & Location
				SELECT 
					No_ AS ItemNo, 
					[Location Code] AS LocationNo, 
					SUM(Quantity) AS TotalServiceQuantity
				FROM nav_cus.ServiceLine
				WHERE Delivered = 1
				GROUP BY No_, [Location Code]
			) sl ON sl.ItemNo = ile.[Item No_] 
				 AND sl.LocationNo = ile.[Location Code]
	--WHERE
	--	ile.[Item No_] = '01010-81030'
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code], sl.TotalServiceQuantity, ile.[Expiration Date]
	HAVING SUM(ile.Quantity)<>0

