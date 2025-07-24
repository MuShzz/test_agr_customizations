-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Stock level from NAV to adi format
--
-- 09.10.2024.TO    Created
-- 16.05.2025.BF	Plus customisation brought to SaaS
-- ===============================================================================
CREATE VIEW [nav_cus].[v_STOCK_LEVEL]
AS


    SELECT
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST(ile.[Location Code] AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(IIF(ile.[Expiration Date]='1753-01-01 00:00:00.0000000', DATEFROMPARTS(2100, 1, 1),ile.[Expiration Date]) AS DATE) AS EXPIRE_DATE,
        --CAST(SUM(ile.Quantity) AS DECIMAL(18,4)) AS STOCK_UNITS,
		CAST(SUM(iex.[Remaining Quantity]) AS DECIMAL(18,4)) AS STOCK_UNITS
    FROM
        [nav].ItemLedgerEntry ile
		inner JOIN nav_cus.ILEExtraInfo iex ON iex.[Entry No_]=ile.[Entry No_]
        JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[Location Code]
	WHERE iex.[Open]=1
	--AND ile.[Item No_]='55042 '
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code], ile.[Expiration Date]
    HAVING SUM(iex.[Remaining Quantity])<>0


