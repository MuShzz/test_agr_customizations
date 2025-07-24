

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
        CAST(CASE
		WHEN ile.LocationCode = '' THEN 'VARAHLUTIR'
		ELSE
			ile.LocationCode
		END AS NVARCHAR(255)) AS LOCATION_NO,
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
        --JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[LocationCode]
    WHERE
        ile.[EntryType] = 'Sale'
        AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.settingValue AS INT),CAST(GETDATE() AS DATE))

