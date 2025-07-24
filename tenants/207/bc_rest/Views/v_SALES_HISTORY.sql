
-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Sales transactions from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_SALES_HISTORY]
AS

    SELECT
		ile.[EntryNo] AS [TRANSACTION_ID],
        CAST(ile.[ItemNo] + CASE WHEN ISNULL(ile.[VariantCode], '') = '' THEN '' ELSE '-' + ile.[VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(ile.[LocationCode] AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[PostingDate] AS DATE) AS [DATE],
		    CAST(-ile.[Quantity] AS DECIMAL(18,4)) AS SALE,
        CAST(ISNULL(c.[No], 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
        ISNULL(ssh.[OrderNo],'') AS REFERENCE_NO,
        CAST(0 AS BIT) AS IS_EXCLUDED
    FROM
        bc_rest.item_ledger_entry ile
        LEFT JOIN bc_rest.sales_shipment_header ssh ON ssh.[No] = ile.[DocumentNo]
        LEFT JOIN bc_rest.customer c ON c.[No] = ile.[SourceNo]
        JOIN core.setting s ON s.settingKey = 'sale_history_retention_years'
        JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[LocationCode]
    WHERE
        ile.[EntryType] = 'Sale'
        AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.settingValue AS INT),CAST(GETDATE() AS DATE))

    UNION ALL

    SELECT 
    CAST( NULL AS INT) AS [TRANSACTION_ID],
    CAST(ile.[ItemNo] + CASE
                                       WHEN ISNULL(ile.[VariantCode], '') = '' THEN
                                           ''
                                       ELSE
                                           '-' + ile.[VariantCode]
                                   END AS NVARCHAR(255)) AS [ITEM_NO],
               CAST(CASE
                        WHEN ile.LocationCode = '' THEN
                            '01'
                        ELSE
                            ile.LocationCode
                    END AS NVARCHAR(255)) AS LOCATION_NO,
               CAST(ile.[PostingDate] AS DATE) AS [DATE],
               CAST(SUM(-ile.[Quantity]) AS DECIMAL(18, 4)) AS SALE,
               CAST(ISNULL(c.[No], 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
               ISNULL(ssh.[OrderNo], '') AS REFERENCE_NO,
               CAST(0 AS BIT) AS IS_EXCLUDED
        FROM bc_rest.item_ledger_entry ile
            LEFT JOIN bc_rest.sales_shipment_header ssh
                ON ssh.[No] = ile.[DocumentNo]
            LEFT JOIN bc_rest.customer c
                ON c.[No] = ile.[SourceNo]
        WHERE ile.[EntryType] = 'Sale'
              AND CAST(ile.[LocationCode] AS NVARCHAR(255)) = ''
        GROUP BY CAST(ile.[ItemNo] + CASE
                                         WHEN ISNULL(ile.[VariantCode], '') = '' THEN
                                             ''
                                         ELSE
                                             '-' + ile.[VariantCode]
                                     END AS NVARCHAR(255)),
                 ile.PostingDate,
                 CAST(ISNULL(c.[No], 'agr_no_customer') AS NVARCHAR(255)),
                 ISNULL(ssh.[OrderNo], ''),
                 ile.LocationCode
        UNION ALL
        SELECT 
        CAST( NULL AS INT) AS [TRANSACTION_ID],
        CAST(lgc.Item_No AS NVARCHAR(255)) AS [ITEM_NO],
               CAST('01' AS NVARCHAR(255)) AS LOCATION_NO,
               CAST(lgc.Posting_Date AS DATE) AS [DATE],
               CAST(SUM(-lgc.Item_Ledger_Entry_Quantity) AS DECIMAL(18, 4)) AS SALE,
               CAST(ISNULL(lgc.CustomerNo, 'agr_no_customer') AS NVARCHAR(255)) AS CUSTOMER_NO,
               CAST('' AS NVARCHAR(50)) AS REFERENCE_NO,
               CAST(0 AS BIT) AS IS_EXCLUDED
        FROM [bc_rest_cus].[Malmsteypan_LegacySales2020_2023_CustomerNo] lgc
        WHERE lgc.Item_No IS NOT NULL
        GROUP BY CAST(lgc.Item_No AS NVARCHAR(255)),
                 CAST(lgc.Posting_Date AS DATE),
                 CAST(ISNULL(lgc.CustomerNo, 'agr_no_customer') AS NVARCHAR(255))
        UNION ALL


        SELECT
        CAST( NULL AS INT) AS [TRANSACTION_ID],
            CAST(lgc.Item_No
                 + CASE
                       WHEN lgei.Variant_Code = '' THEN ''
                       ELSE '-' + lgei.Variant_Code
                   END
                 AS NVARCHAR(255))          AS ITEM_NO,
            '01'                                  AS LOCATION_NO,
            CAST(lgc.Posting_Date AS DATE)        AS [DATE],
            -- sum DISTINCT so two –1 rows become a single 1
            CAST(
              SUM(DISTINCT -lgc.Item_Ledger_Entry_Quantity)
              AS DECIMAL(18,4)
            )                                      AS SALE,
            CAST(
              ISNULL(lgc.CustomerNo, 'agr_no_customer')
              AS NVARCHAR(255)
            )                                      AS CUSTOMER_NO,
            ''                                     AS REFERENCE_NO,
            CAST(0 AS BIT) AS IS_EXCLUDED
        FROM bc_rest_cus.Malmsteypan_LegacySales2020_2023_CustomerNo lgc
        JOIN bc_rest_cus.Malmsteypan_LegacySales2020_2023_ExtraInfo lgei
          ON lgei.Item_No              = lgc.Item_No
         AND lgei.Posting_Date         = lgc.Posting_Date
         AND lgei.Quantity             = lgc.Item_Ledger_Entry_Quantity
        WHERE lgei.Variant_Code IS NOT NULL
        GROUP BY
            CAST(lgc.Item_No
                 + CASE
                       WHEN lgei.Variant_Code = '' THEN ''
                       ELSE '-' + lgei.Variant_Code
                   END
                 AS NVARCHAR(255)),
            CAST(lgc.Posting_Date AS DATE),
            CAST(ISNULL(lgc.CustomerNo, 'agr_no_customer') AS NVARCHAR(255));

