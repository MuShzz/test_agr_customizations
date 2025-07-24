CREATE VIEW nav_cus.v_SALES_HISTORY AS

WITH promo_offer AS (
		SELECT 
		ile.[Entry No_],
		CAST(
				CASE 
					WHEN dle_mix.[Offer No_] IS NOT NULL THEN dle_mix.[Offer No_]
					WHEN dle_coupon.[Offer No_] IS NOT NULL THEN dle_coupon.[Offer No_]
					ELSE ISNULL(ssh.[Order No_],'')
				END AS NVARCHAR(255)
			)																				AS REFERENCE_NO
		FROM 
		nav.ItemLedgerEntry ile
			LEFT JOIN nav_cus.DiscountLedgerEntry dle_mix ON dle_mix.[Item Ledger Entry No_] = ile.[Entry No_] AND dle_mix.[Offer Type] = 3 AND dle_mix.[Offer No_] <>''
			LEFT JOIN nav_cus.DiscountLedgerEntry dle_coupon ON dle_coupon.[Item Ledger Entry No_] = ile.[Entry No_] AND dle_coupon.[Offer Type] = 12 AND dle_coupon.[Offer No_]<>''
			LEFT JOIN nav.SalesShipmentHeader ssh ON ssh.[No_] = ile.[Document No_]
		GROUP BY
		ile.[Entry No_],
		dle_mix.[Offer No_],
		dle_coupon.[Offer No_],
		ssh.[Order No_]
	)

	SELECT
			CAST(ile.[Entry No_] AS NVARCHAR(255))											AS [TRANSACTION_ID],
			CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' 
									THEN '' ELSE '-' + ile.[Variant Code] 
									END AS NVARCHAR(255))									AS [ITEM_NO],
			CAST(ile.[Location Code] AS NVARCHAR(255))										AS LOCATION_NO,
			CAST(ile.[Posting Date] AS DATE)												AS [DATE],
			CAST(SUM(IIF(ile.[Entry Type] = 1, -ile.[Quantity], 0)) AS DECIMAL(18, 4))		AS [SALE],
			CAST('agr_no_customer' AS NVARCHAR(255))										AS CUSTOMER_NO,
			po.REFERENCE_NO																	AS REFERENCE_NO,
			CAST(0 AS BIT)																	AS IS_EXCLUDED
		FROM
			nav.ItemLedgerEntry ile
			LEFT JOIN nav.Customer c ON c.[No_] = ile.[Source No_]
			JOIN core.setting s ON s.settingKey = 'sale_history_retention_years'
			JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[Location Code]
			LEFT JOIN promo_offer po ON po.[Entry No_]=ile.[Entry No_]
		WHERE
			ile.[Entry Type] = 1
			AND CAST(ile.[Posting Date] AS DATE) > DATEADD(YEAR,-CAST(s.settingValue AS INT),CAST(GETDATE() AS DATE))
		GROUP BY
			CAST(ile.[Entry No_] AS NVARCHAR(255)),
			CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)),
			CAST(ile.[Location Code] AS NVARCHAR(255)),
			CAST(ile.[Posting Date] AS DATE),
			CAST(ile.[Variant Code] AS NVARCHAR(255)),
			CAST(ISNULL(c.[No_], 'agr_no_customer') AS NVARCHAR(255)),
			po.REFERENCE_NO

