




-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

CREATE VIEW [cus].[v_SALES_HISTORY] AS
	
	WITH
	FirstQuery AS (
        SELECT 
            CAST(LSH.[Item No_] + CASE WHEN ISNULL(LSH.[Variant Code], '') = '' THEN '' ELSE '-' + LSH.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
            CAST('01-JLR' AS NVARCHAR(255)) AS LOCATION_NO,
            CAST(LSH.[Posting Date] AS DATE) AS [DATE],
			NULL AS CUSTOMER_NO,
			NULL AS REFERENCE_NO,
            CAST(SUM(IIF(LSH.[Entry Type] = 1, -LSH.[Quantity], 0)) AS DECIMAL(18,4)) AS SALE,         
            'JLR' AS COMPANY
        FROM
            [cus].LEGACY_SALES_HISTORY LSH
        WHERE
            LSH.[Entry Type] IN (1)
            AND LSH.[Location Code] = '06'
            AND LSH.[Posting Date] < '2024-01-01'
        GROUP BY
            LSH.[Item No_], LSH.[Variant Code], LSH.[Location Code], CAST(LSH.[Posting Date] AS DATE) --CUSTOMER_NO, REFERENCE_NO
    ),
    SecondQuery AS (
        SELECT
            CAST(LSH.[Item No_] + CASE WHEN ISNULL(LSH.[Variant Code], '') = '' THEN '' ELSE '-' + LSH.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
            CAST('01-JLR' AS NVARCHAR(255)) AS LOCATION_NO,
            CAST(LSH.[Posting Date] AS DATE) AS [DATE],
			NULL  AS CUSTOMER_NO,
			NULL AS REFERENCE_NO,
            CAST(SUM(IIF(LSH.[Entry Type] = 1, -LSH.[Quantity], 0)) AS DECIMAL(18,4)) AS SALE,
            'JLR' AS COMPANY
        FROM
            [cus].LEGACY_SALES_HISTORY LSH
        WHERE
            LSH.[Entry Type] IN (1)
			AND LSH.[Location Code] = '01'
            AND LSH.[Posting Date] < '2024-01-01'
            AND LSH.[Posting Date] > '2022-01-01'
        GROUP BY
            LSH.[Item No_], LSH.[Variant Code], LSH.[Location Code], CAST(LSH.[Posting Date] AS DATE)
    ),CombinedQueries AS (
        SELECT 
            COALESCE(FQ.ITEM_NO, SQ.ITEM_NO) AS ITEM_NO,
            COALESCE(FQ.LOCATION_NO, SQ.LOCATION_NO) AS LOCATION_NO,
            COALESCE(FQ.DATE, SQ.DATE) AS DATE,
            COALESCE(FQ.SALE, SQ.SALE) AS SALE,
			COALESCE(FQ.CUSTOMER_NO, SQ.CUSTOMER_NO) AS	 CUSTOMER_NO,
			COALESCE(FQ.REFERENCE_NO, SQ.REFERENCE_NO) AS REFERENCE_NO,
            COALESCE(FQ.Company, SQ.Company) AS Company
        FROM 
            FirstQuery FQ
        FULL OUTER JOIN 
            SecondQuery SQ
			ON FQ.ITEM_NO = SQ.ITEM_NO 
            AND FQ.LOCATION_NO = SQ.LOCATION_NO 
            AND FQ.DATE = SQ.DATE)
	
	,SALE_HISTORY AS (

    SELECT 
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST(ile.[Location Code] + '-' + ile.[Company] AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[Posting Date] AS DATE) AS [DATE],
		CAST(ISNULL(ile.[Source No_], 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
		CAST(ISNULL(ssh.[Order No_],ile.[Entry No_])AS NVARCHAR(255)) AS REFERENCE_NO,
        CAST(SUM(IIF(ile.[Entry Type] IN (1), -ile.[Quantity], 0)) AS DECIMAL(18,4)) AS SALE,
		ile.Company 
    FROM
        [cus].ItemLedgerEntry ile
		LEFT JOIN cus.SalesShipmentHeader ssh ON ssh.[No_] = ile.[Document No_]
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        ile.[Entry Type] IN (1)
		AND ile.[Location Code] = '01'
		AND ile.Company = 'BLI'
        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code], CAST(ile.[Posting Date] AS DATE),ile.Company,ISNULL(ile.[Source No_], 'agr_no_customer'), ISNULL(ssh.[Order No_],ile.[Entry No_]) 

	UNION ALL

	SELECT
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST(ile.[Location Code] + '-' + ile.[Company] AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[Posting Date] AS DATE) AS [DATE],
		CAST(ISNULL(ile.[Source No_], 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
		CAST(ISNULL(ssh.[Order No_],ile.[Entry No_])AS NVARCHAR(255)) AS REFERENCE_NO,
        CAST(SUM(IIF(ile.[Entry Type] IN (1), -ile.[Quantity], 0)) AS DECIMAL(18,4)) AS SALE,
		ile.Company
    FROM
        [cus].ItemLedgerEntry ile
		LEFT JOIN cus.SalesShipmentHeader ssh ON ssh.[No_] = ile.[Document No_]
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        ile.[Entry Type] IN (1)
		AND ile.[Location Code] = '01'
		AND ile.Company = 'JLR'
        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code], CAST(ile.[Posting Date] AS DATE),ile.Company,ISNULL(ile.[Source No_], 'agr_no_customer'), ISNULL(ssh.[Order No_],ile.[Entry No_]) 

	UNION ALL

	SELECT
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST(ile.[Location Code] + '-' + ile.[Company] AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[Posting Date] AS DATE) AS [DATE],
		CAST(ISNULL(ile.[Source No_], 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
		CAST(ISNULL(ssh.[Order No_],ile.[Entry No_])AS NVARCHAR(255)) AS REFERENCE_NO,
        CAST(SUM(IIF(ile.[Entry Type] IN (1), -ile.[Quantity], 0)) AS DECIMAL(18,4)) AS SALE,
		ile.Company
    FROM
        [cus].ItemLedgerEntry ile
		LEFT JOIN cus.SalesShipmentHeader ssh ON ssh.[No_] = ile.[Document No_]
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        ile.[Entry Type] IN (1)
		AND ile.[Location Code] IN ('08')
		AND ile.Company = 'HYU'
		--AND ile.[Item No_] = 'HY124767'
        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code], CAST(ile.[Posting Date] AS DATE),ile.Company,ISNULL(ile.[Source No_], 'agr_no_customer'), ISNULL(ssh.[Order No_],ile.[Entry No_]) 

	UNION ALL

	SELECT
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST(ile.[Location Code] + '-' + ile.[Company] AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[Posting Date] AS DATE) AS [DATE],
		CAST(ISNULL(ile.[Source No_], 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
		CAST(ISNULL(ssh.[Order No_],ile.[Entry No_])AS NVARCHAR(255)) AS REFERENCE_NO,
        CAST(SUM(IIF(ile.[Entry Type] = 1, -ile.[Quantity], 0)) AS DECIMAL(18,4)) AS SALE,
		ile.Company
    FROM
        [cus].ItemLedgerEntry ile
		LEFT JOIN cus.SalesShipmentHeader ssh ON ssh.[No_] = ile.[Document No_]
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        ile.[Entry Type] IN (1)
		AND ile.[Location Code] = '12'
		AND ile.Company = 'HYU'
        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code], CAST(ile.[Posting Date] AS DATE),ile.Company,ISNULL(ile.[Source No_], 'agr_no_customer'), ISNULL(ssh.[Order No_],ile.[Entry No_]) 

	UNION ALL
	
	SELECT
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST('08-HYU' AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[Posting Date] AS DATE) AS [DATE],
		CAST(ISNULL(ile.[Source No_], 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
		CAST(ISNULL(ssh.[Order No_],ile.[Entry No_])AS NVARCHAR(255)) AS REFERENCE_NO,
        CAST(CASE
			WHEN (ile.[Remaining Quantity] > 0 AND ile.[Entry Type] = 1 AND ile.[Invoiced Quantity] > ile.[Remaining Quantity]) THEN SUM(ile.Quantity) --15.01.2025.DFS Added in AND [Invoiced Quantity] > [Remaining Quantity]) THEN SUM(ile.Quantity) after a request via email from Sigurður 
			WHEN ile.[Entry Type] = 1 THEN SUM(-ile.Quantity)
		END AS DECIMAL(18,4)) AS SALE,
		ile.Company
    FROM
        [cus].ItemLedgerEntry ile
		LEFT JOIN cus.SalesShipmentHeader ssh ON ssh.[No_] = ile.[Document No_]
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        ile.[Entry Type] IN (1)
		AND ile.[Location Code] IN ('09')
		AND ile.Company = 'HYU'

		--and ile.[Item No_] = 'HY145366'
		--and ile.[Posting Date] = '2024-05-31'
        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code], CAST(ile.[Posting Date] AS DATE),ile.Company,ile.[Entry Type],ile.[Remaining Quantity],ISNULL(ile.[Source No_], 'agr_no_customer'), ISNULL(ssh.[Order No_],ile.[Entry No_]),ile.[Invoiced Quantity]

	UNION ALL


	SELECT
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST('08-HYU' AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[Posting Date] AS DATE) AS [DATE],
		CAST(ISNULL(ile.[Source No_], 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
		CAST(ISNULL(ssh.[Order No_],ile.[Entry No_])AS NVARCHAR(255)) AS REFERENCE_NO,
        CAST(CASE
			WHEN (ile.[Remaining Quantity] > 0 AND ile.[Entry Type] = 1 AND ile.[Invoiced Quantity] > ile.[Remaining Quantity]) THEN SUM(ile.Quantity) --15.01.2025.DFS Added in AND [Invoiced Quantity] > [Remaining Quantity]) THEN SUM(ile.Quantity) after a request via email from Sigurður
			WHEN ile.[Entry Type] = 1 THEN SUM(-ile.Quantity)
		END AS DECIMAL(18,4)) AS SALE,
		ile.Company
    FROM
        [cus].ItemLedgerEntry ile
		LEFT JOIN cus.SalesShipmentHeader ssh ON ssh.[No_] = ile.[Document No_]
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        ile.[Entry Type] IN (1)
		AND ile.[Location Code] = '18'
		AND ile.Company = 'HYU'
		--and ile.[Item No_] = 'HY150946'
        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code], CAST(ile.[Posting Date] AS DATE),ile.Company,ile.[Entry Type],ile.[Remaining Quantity],ISNULL(ile.[Source No_], 'agr_no_customer'), ISNULL(ssh.[Order No_],ile.[Entry No_]),ile.[Invoiced Quantity]

	UNION ALL

	SELECT
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST('12-HYU' AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[Posting Date] AS DATE) AS [DATE],
		CAST(ISNULL(ile.[Source No_], 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
		CAST(ISNULL(ssh.[Order No_],ile.[Entry No_])AS NVARCHAR(255)) AS REFERENCE_NO,
        CAST(CASE
			WHEN (ile.[Remaining Quantity] > 0 AND ile.[Entry Type] = 1 AND ile.[Invoiced Quantity] > ile.[Remaining Quantity]) THEN SUM(ile.Quantity) --15.01.2025.DFS Added in AND [Invoiced Quantity] > [Remaining Quantity]) THEN SUM(ile.Quantity) after a request via email from Sigurður
			WHEN ile.[Entry Type] = 1 THEN SUM(-ile.Quantity)
		END AS DECIMAL(18,4)) AS SALE,
		ile.Company
    FROM
        [cus].ItemLedgerEntry ile
		LEFT JOIN cus.SalesShipmentHeader ssh ON ssh.[No_] = ile.[Document No_]
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        ile.[Entry Type] IN (1)
		AND ile.[Location Code] = '13'
		AND ile.Company = 'HYU'
        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code], CAST(ile.[Posting Date] AS DATE),ile.Company,ile.[Entry Type],ile.[Remaining Quantity],ISNULL(ile.[Source No_], 'agr_no_customer'), ISNULL(ssh.[Order No_],ile.[Entry No_]),ile.[Invoiced Quantity]

	UNION ALL

	SELECT
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST('01-BLI' AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[Posting Date] AS DATE) AS [DATE],
		CAST(ISNULL(ile.[Source No_], 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
		CAST(ISNULL(ssh.[Order No_],ile.[Entry No_])AS NVARCHAR(255)) AS REFERENCE_NO,
        CAST(CASE
			WHEN (ile.[Remaining Quantity] > 0 AND ile.[Entry Type] = 1 AND ile.[Invoiced Quantity] > ile.[Remaining Quantity]) THEN SUM(ile.Quantity) --15.01.2025.DFS Added in AND [Invoiced Quantity] > [Remaining Quantity]) THEN SUM(ile.Quantity) after a request via email from Sigurður
			WHEN ile.[Entry Type] = 1 THEN SUM(-ile.Quantity)
		END AS DECIMAL(18,4)) AS SALE,
		ile.Company
    FROM
        [cus].ItemLedgerEntry ile
		LEFT JOIN cus.SalesShipmentHeader ssh ON ssh.[No_] = ile.[Document No_]
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        ile.[Entry Type] IN (1)
		AND ile.[Location Code] = '02'
		AND ile.Company = 'BLI'
        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code], CAST(ile.[Posting Date] AS DATE),ile.Company,ile.[Entry Type],ile.[Remaining Quantity],ISNULL(ile.[Source No_], 'agr_no_customer'), ISNULL(ssh.[Order No_],ile.[Entry No_]),ile.[Invoiced Quantity]

	UNION ALL

	SELECT
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST('01-BLI' AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[Posting Date] AS DATE) AS [DATE],
		CAST(ISNULL(ile.[Source No_], 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
		CAST(ISNULL(ssh.[Order No_],ile.[Entry No_])AS NVARCHAR(255)) AS REFERENCE_NO,
        CAST(CASE
			WHEN (ile.[Remaining Quantity] > 0 AND ile.[Entry Type] = 1 AND ile.[Invoiced Quantity] > ile.[Remaining Quantity]) THEN SUM(ile.Quantity) --15.01.2025.DFS Added in AND [Invoiced Quantity] > [Remaining Quantity]) THEN SUM(ile.Quantity) after a request via email from Sigurður
			WHEN ile.[Entry Type] = 1 THEN SUM(-ile.Quantity)
		END AS DECIMAL(18,4)) AS SALE,
		ile.Company
    FROM
        [cus].ItemLedgerEntry ile
		LEFT JOIN cus.SalesShipmentHeader ssh ON ssh.[No_] = ile.[Document No_]
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        ile.[Entry Type] IN (1)
		AND ile.[Location Code] = '22'
		AND ile.Company = 'BLI'
        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code], CAST(ile.[Posting Date] AS DATE),ile.Company,ile.[Entry Type],ile.[Remaining Quantity],ISNULL(ile.[Source No_], 'agr_no_customer'), ISNULL(ssh.[Order No_],ile.[Entry No_]),ile.[Invoiced Quantity]

	UNION ALL

	SELECT
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST('01-JLR' AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[Posting Date] AS DATE) AS [DATE],
		CAST(ISNULL(ile.[Source No_], 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
		CAST(ISNULL(ssh.[Order No_],ile.[Entry No_])AS NVARCHAR(255)) AS REFERENCE_NO,
        CAST(CASE
			WHEN (ile.[Remaining Quantity] > 0 AND ile.[Entry Type] = 1 AND ile.[Invoiced Quantity] > ile.[Remaining Quantity]) THEN SUM(ile.Quantity) --15.01.2025.DFS Added in AND [Invoiced Quantity] > [Remaining Quantity]) THEN SUM(ile.Quantity) after a request via email from Sigurður
			WHEN ile.[Entry Type] = 1 THEN SUM(-ile.Quantity)
		END AS DECIMAL(18,4)) AS SALE,
		ile.Company
    FROM
        [cus].ItemLedgerEntry ile
		LEFT JOIN cus.SalesShipmentHeader ssh ON ssh.[No_] = ile.[Document No_]
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        ile.[Entry Type] IN (1)
		AND ile.[Location Code] = '07'
		AND ile.Company = 'JLR'
        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code], CAST(ile.[Posting Date] AS DATE),ile.Company,ile.[Entry Type],ile.[Remaining Quantity],ISNULL(ile.[Source No_], 'agr_no_customer'), ISNULL(ssh.[Order No_],ile.[Entry No_]),ile.[Invoiced Quantity]

	UNION ALL
	-- returns nothing
	SELECT
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST('01-JLR' AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[Posting Date] AS DATE) AS [DATE],
		CAST(ISNULL(ile.[Source No_], 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
		CAST(ISNULL(ssh.[Order No_],ile.[Entry No_])AS NVARCHAR(255)) AS REFERENCE_NO,
        CAST(CASE
			WHEN (ile.[Remaining Quantity] > 0 AND ile.[Entry Type] = 1 AND ile.[Invoiced Quantity] > ile.[Remaining Quantity]) THEN SUM(ile.Quantity) --15.01.2025.DFS Added in AND [Invoiced Quantity] > [Remaining Quantity]) THEN SUM(ile.Quantity) after a request via email from Sigurður
			WHEN ile.[Entry Type] = 1 THEN SUM(-ile.Quantity)
		END AS DECIMAL(18,4)) AS SALE,
		ile.Company
    FROM
        [cus].ItemLedgerEntry ile
		LEFT JOIN cus.SalesShipmentHeader ssh ON ssh.[No_] = ile.[Document No_]
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        ile.[Entry Type] IN (1,4)
		AND ile.[Location Code] = '19'
		AND ile.Company = 'JLR'
        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code], CAST(ile.[Posting Date] AS DATE),ile.Company,ile.[Entry Type],ile.[Remaining Quantity],ISNULL(ile.[Source No_], 'agr_no_customer'), ISNULL(ssh.[Order No_],ile.[Entry No_]),ile.[Invoiced Quantity]

	UNION ALL

	SELECT
        CAST(LSH.[Item No_] + CASE WHEN ISNULL(LSH.[Variant Code], '') = '' THEN '' ELSE '-' + LSH.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST('01-BLI' AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(LSH.[Posting Date] AS DATE) AS [DATE],
		NULL AS CUSTOMER_NO,
		NULL AS REFERENCE_NO,
        CAST(SUM(IIF(LSH.[Entry Type] = 1, -LSH.[Quantity], 0)) AS DECIMAL(18,4)) AS SALE,
		'BLI' AS Company
    FROM
        [cus].LEGACY_SALES_HISTORY LSH
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        LSH.[Entry Type] IN (1)
		AND LSH.[Location Code] = '01'
		AND LSH.[Posting Date] < '2024-01-01'
        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        LSH.[Item No_], LSH.[Variant Code], LSH.[Location Code], CAST(LSH.[Posting Date] AS DATE)

	UNION ALL

	SELECT
        CAST(LSH.[Item No_] + CASE WHEN ISNULL(LSH.[Variant Code], '') = '' THEN '' ELSE '-' + LSH.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST('08-HYU' AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(LSH.[Posting Date] AS DATE) AS [DATE],
		NULL AS CUSTOMER_NO,
		NULL AS REFERENCE_NO,
        CAST(SUM(IIF(LSH.[Entry Type] = 1, -LSH.[Quantity], 0)) AS DECIMAL(18,4)) AS SALE,
		'HYU' AS Company
    FROM
        [cus].LEGACY_SALES_HISTORY LSH
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        LSH.[Entry Type] IN (1)
		AND LSH.[Location Code] IN ('08','09')
		AND LSH.[Posting Date] < '2024-01-01'


        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        LSH.[Item No_], LSH.[Variant Code], LSH.[Location Code], CAST(LSH.[Posting Date] AS DATE)

	UNION ALL

	SELECT
        CAST(LSH.[Item No_] + CASE WHEN ISNULL(LSH.[Variant Code], '') = '' THEN '' ELSE '-' + LSH.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST('12-HYU' AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(LSH.[Posting Date] AS DATE) AS [DATE],
		NULL AS CUSTOMER_NO,
		NULL AS REFERENCE_NO,
        CAST(SUM(IIF(LSH.[Entry Type] = 1, -LSH.[Quantity], 0)) AS DECIMAL(18,4)) AS SALE,
		'HYU' AS Company
    FROM
        [cus].LEGACY_SALES_HISTORY LSH
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        LSH.[Entry Type] IN (1)
		AND LSH.[Location Code] = '12'
		AND LSH.[Posting Date] < '2024-01-01'
        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        LSH.[Item No_], LSH.[Variant Code], LSH.[Location Code], CAST(LSH.[Posting Date] AS DATE)

	UNION ALL

	SELECT
        CAST(LSH.[Item No_] + CASE WHEN ISNULL(LSH.[Variant Code], '') = '' THEN '' ELSE '-' + LSH.[Variant Code] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST('12-HYU' AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(LSH.[Posting Date] AS DATE) AS [DATE],
		NULL AS CUSTOMER_NO,
		NULL AS REFERENCE_NO,
        CAST(SUM(IIF(LSH.[Entry Type] = 1, -LSH.[Quantity], 0)) AS DECIMAL(18,4)) AS SALE,
		'HYU' AS Company
    FROM
        [cus].LEGACY_SALES_HISTORY LSH
        --JOIN core.setting s ON s.setting_key = 'sale_history_retention_years'
       -- JOIN erp_raw.location_mapping_setup lm ON lm.location_no = ile.[Location Code] AND include = 1
    WHERE
        LSH.[Entry Type] IN (1)
		AND LSH.[Location Code] = '13'
		AND LSH.[Posting Date] < '2024-01-01'
        --AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.setting_value AS INT),CAST(GETDATE() AS DATE))
        -- changed to erp_raw.get_views procedure:
        --AND CAST(ile.[PostingDate] AS DATE) > ISNULL((SELECT MAX([Date]) FROM erp_raw.sale_history),'1900-01-01')
        --AND CAST(ile.[PostingDate] AS DATE) < CAST(GETDATE() AS DATE)
    GROUP BY
        LSH.[Item No_], LSH.[Variant Code], LSH.[Location Code], CAST(LSH.[Posting Date] AS DATE)

	UNION ALL

    -- Include the results from CombinedQueries
    SELECT
        ITEM_NO,
        LOCATION_NO,
        [DATE],
		CUSTOMER_NO,
        REFERENCE_NO,
        SALE,
        COMPANY
    FROM CombinedQueries)

	SELECT
		CONCAT(CONVERT(VARCHAR, CAST([date] AS DATE), 112),100000000+ROW_NUMBER() OVER(ORDER BY [date])) AS [transaction_id],
		ITEM_NO,
		LOCATION_NO,
		[DATE],
		ISNULL(CUSTOMER_NO,'agr_no_customer') AS CUSTOMER_NO,
        ISNULL(REFERENCE_NO,'') AS REFERENCE_NO,
		CAST(SUM(ISNULL(SALE,0)) AS DECIMAL(18,4)) AS SALE,
		CAST(0 AS BIT) AS IS_EXCLUDED
	FROM SALE_HISTORY
	
	GROUP BY
		ITEM_NO, LOCATION_NO, [DATE], SALE, CUSTOMER_NO, REFERENCE_NO, COMPANY;


