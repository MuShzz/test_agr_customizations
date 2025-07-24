

-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom Column Stock Units in locations Norolingabraut
--
-- 19.11.2024.BF    Created
-- ===============================================================================
CREATE VIEW [nav_cus].[v_CustomColumn_stockUnitsNorolingabraut]
AS

	WITH Location01Stock AS (
		SELECT
			CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
			CAST(SUM(ile.Quantity) AS DECIMAL(18,4)) AS stockUnitsLocation01
		FROM
			[nav].ItemLedgerEntry ile
		WHERE
			ile.[Location Code] = '01'
		GROUP BY
			ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END
	)
    SELECT
        CAST(ai.itemNo AS NVARCHAR(255)) AS ITEM_NO,
		CAST(ai.locationNo AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(stockUnitsLocation01 AS DECIMAL(18,4)) AS stockUnitsNorolingabraut
    FROM
		dbo.AGREssentials_items ai
        --LEFT JOIN [nav].ItemLedgerEntry ile ON ile.[Location Code]=ai.locationNo AND ile.[Item No_]=ai.itemNo
		LEFT JOIN Location01Stock loc01 ON loc01.ITEM_NO = ai.itemNo
	--where
	--ai.itemNo='0046 3   30'
    GROUP BY
        ai.itemNo,ai.locationNo, loc01.stockUnitsLocation01


