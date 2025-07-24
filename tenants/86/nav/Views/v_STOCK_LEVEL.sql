-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Stock level from NAV to adi format
--
-- 09.10.2024.TO    Created
-- 07.03.2025.BF	added filtering on nav.v_item to reduce the items based on settings like exclude closed items
-- ===============================================================================
CREATE VIEW [nav_cus].[v_STOCK_LEVEL]
AS


    SELECT
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST(ile.[Location Code] AS NVARCHAR(255)) AS LOCATION_NO,
        --CAST(IIF(ile.[Expiration Date]='1753-01-01 00:00:00.0000000', DATEFROMPARTS(2100, 1, 1),ile.[Expiration Date]) AS DATE) AS EXPIRE_DATE,
		CAST(DATEFROMPARTS(2100, 1, 1) AS DATE) AS EXPIRE_DATE,
        CAST(SUM(ile.Quantity) AS DECIMAL(18,4)) AS STOCK_UNITS
	FROM
        [nav].ItemLedgerEntry ile
        JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[Location Code] --and include = 1
	WHERE EXISTS (
		SELECT 1 FROM nav_cus.v_item i WHERE i.NO = CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)))
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code]--, ile.[Expiration Date]
    HAVING SUM(ile.Quantity)<>0

