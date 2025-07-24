-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Sales transactions from NAV to adi format, customisation to include some transfer orders into sale history - SEC-14
--
-- 16.12.2024.BF    Created
-- ===============================================================================
CREATE VIEW [nav_cus].[v_SALES_HISTORY]
AS

     SELECT
        CAST(ile.[Entry No_] AS NVARCHAR(255)) AS [TRANSACTION_ID],
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(ile.[Location Code] AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[Posting Date] AS DATE) AS [DATE],
        CAST(SUM(IIF(ile.[Entry Type] = 1, -ile.[Quantity], 0)) AS DECIMAL(18, 4)) AS [SALE],
        CAST(ISNULL(c.[No_], 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
        ISNULL(ssh.[Order No_],'') AS REFERENCE_NO,
        CAST(0 AS BIT) AS IS_EXCLUDED
    FROM
        nav.ItemLedgerEntry ile
        LEFT JOIN nav.SalesShipmentHeader ssh ON ssh.[No_] = ile.[Document No_]
        LEFT JOIN nav.Customer c ON c.[No_] = ile.[Source No_]
        JOIN core.setting s ON s.settingKey = 'sale_history_retention_years'
        JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[Location Code]
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
        ssh.[Order No_]

	-- Sec-14 - customisation
	UNION ALL

	 SELECT
        CAST(ile.[Entry No_] AS NVARCHAR(255)) AS [TRANSACTION_ID],
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(ile.[Location Code] AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[Posting Date] AS DATE) AS [DATE],
        CAST(SUM(-ile.[Quantity]) AS DECIMAL(18, 4)) AS [SALE],
		CAST('agr_no_customer' AS NVARCHAR(255)) AS CUSTOMER_NO,
        CAST('' AS NVARCHAR(255)) AS REFERENCE_NO,
        CAST(0 AS BIT) AS IS_EXCLUDED
    FROM
        nav.ItemLedgerEntry ile
		--LEFT JOIN nav.SalesShipmentHeader ssh ON ssh.[No_] = ile.[Document No_]
  --      LEFT JOIN nav.Customer c ON c.[No_] = ile.[Source No_]
        JOIN core.setting s ON s.settingKey = 'sale_history_retention_years'
        JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[Location Code]
    WHERE
        ile.[Entry Type] IN (4)
		AND ile.[Location Code] IN ('G0020','G0030','G0040') -- only those 3 stores
		AND ile.[Document No_] LIKE 'ÞP%'
		AND ile.Quantity < 0
        AND CAST(ile.[Posting Date] AS DATE) > DATEADD(YEAR,-CAST(s.settingValue AS INT),CAST(GETDATE() AS DATE))
    GROUP BY
        CAST(ile.[Entry No_] AS NVARCHAR(255)) ,
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) ,
        CAST(ile.[Location Code] AS NVARCHAR(255)) ,
        CAST(ile.[Posting Date] AS DATE)
		--CAST(ISNULL(c.[No_], 'agr_no_customer') AS NVARCHAR(255)),
		--ssh.[Order No_]


