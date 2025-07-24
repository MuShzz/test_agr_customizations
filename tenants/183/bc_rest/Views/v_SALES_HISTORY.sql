
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
-- Sale history for BOM parent (style+color items)

    SELECT
		ile.[EntryNo] AS [TRANSACTION_ID],
        --CAST(ile.[ItemNo] + CASE WHEN ISNULL(ile.[VariantCode], '') = '' THEN '' ELSE '-' + ile.[VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO],
		CAST(CONCAT(iei.[bc1_ItemHeaderID],iei.bc1_ItemVariant1ID) AS NVARCHAR(255)) AS [ITEM_NO],
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
		JOIN bc_rest_cus.item_extra_info iei ON iei.No = ile.ItemNo

    WHERE
        ile.[EntryType] = 'Sale'
        AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.settingValue AS INT),CAST(GETDATE() AS DATE))


