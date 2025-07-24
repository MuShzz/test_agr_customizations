


-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

CREATE VIEW [cus].[v_STOCK_LEVEL] AS


	WITH STOCK_HISTORY AS (
		SELECT
			CAST([Item No_] + CASE WHEN ISNULL([Variant Code], '') = '' THEN '' ELSE '-' + [Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
			CAST([Location Code] + '-' + [Company] AS NVARCHAR(255)) AS LOCATION_NO,
			CAST(IIF(ile.[Expiration Date]='1753-01-01 00:00:00.0000000', DATEFROMPARTS(2100, 1, 1),ile.[Expiration Date]) AS DATE) AS EXPIRE_DATE,
			CAST(SUM([Quantity]) AS DECIMAL(18,4)) AS STOCK_UNITS,
			[Company]
		FROM
			cus.ItemLedgerEntry ile
		GROUP BY
			[Item No_], [Variant Code], [Location Code], ile.[Expiration Date], [Company]
		HAVING SUM(ile.Quantity)<>0)
		SELECT
			ITEM_NO,
			[LOCATION_NO],
			EXPIRE_DATE,
			SUM(STOCK_UNITS) AS [STOCK_UNITS]
		FROM
			STOCK_HISTORY
		GROUP BY
			ITEM_NO,LOCATION_NO,EXPIRE_DATE,Company


