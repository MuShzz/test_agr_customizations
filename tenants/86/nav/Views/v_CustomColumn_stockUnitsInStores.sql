

-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom Column Stock Units in Stores
--
-- 27.01.2025.BF    Created
-- ===============================================================================
CREATE VIEW [nav_cus].[v_CustomColumn_stockUnitsInStores]
AS

	WITH stockUnitsInStores AS (
		SELECT
			CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
			CAST(SUM(ile.Quantity) AS DECIMAL(18,4)) AS stockUnitsInStores
		FROM
			[nav].ItemLedgerEntry ile
			LEFT JOIN core.location_mapping_setup lms ON lms.locationNo=ile.[Location Code]
		WHERE
			ile.[Location Code] NOT LIKE 'U-%' AND
			ile.[Location Code] NOT LIKE 'VI%' AND
			ile.[Location Code] NOT IN ('HS','HD')
		GROUP BY
			ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END
	)
    SELECT
        CAST(ai.itemNo AS NVARCHAR(255)) AS ITEM_NO,
		CAST(ai.locationNo AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(sumstores.stockUnitsInStores AS DECIMAL(18,4)) AS stockUnitsInStores
    FROM
		dbo.AGREssentials_items ai
		LEFT JOIN stockUnitsInStores sumstores ON sumstores.ITEM_NO = ai.itemNo
	--where
	--ai.itemNo='LDPE8813'
    GROUP BY
        ai.itemNo,ai.locationNo, sumstores.stockUnitsInStores


