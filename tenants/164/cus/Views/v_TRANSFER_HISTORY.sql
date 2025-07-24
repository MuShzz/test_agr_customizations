


    CREATE VIEW [cus].[v_TRANSFER_HISTORY] AS
       SELECT 
		CAST(CONCAT(CONVERT(VARCHAR, CAST([DATE] AS DATE), 112), 100000000 + (ROW_NUMBER() OVER (PARTITION BY [DATE] ORDER BY [DATE], [ITEM_NO]))) AS BIGINT) AS [TRANSACTION_ID],
		[ITEM_NO],
		[FROM_LOCATION_NO],
		[TO_LOCATION_NO],
		[DATE],
		[TRANSFER],
		[IS_EXCLUDED]
		FROM (
			SELECT
				CAST(ile.[ItemNo] + CASE WHEN ISNULL(ile.[VariantCode], '') = '' THEN '' ELSE '-' + ile.[VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO],
				CAST(ile.[LocationCode] AS NVARCHAR(255)) AS [FROM_LOCATION_NO],
				CAST(NULL AS NVARCHAR(255)) AS [TO_LOCATION_NO],
				CAST(ile.[PostingDate] AS DATE) AS [DATE],
				CAST(SUM(-ile.[Quantity]) AS DECIMAL(18,4)) AS [TRANSFER],
				CAST(0 AS BIT) AS [IS_EXCLUDED]
			FROM
				[cus].item_ledger_entry ile
				LEFT JOIN [cus].sales_shipment_header ssh ON ssh.[No] = ile.[DocumentNo]
				LEFT JOIN [cus].customer c ON c.[No] = ile.[SourceNo]
				--JOIN core.setting s ON s.settingkey = 'sale_history_retention_years'
				JOIN core.[location_mapping_setup] lm ON lm.locationNo = ile.[LocationCode]
			WHERE
				ile.[EntryType] = 'Transfer'
			GROUP BY
				CAST(ile.[ItemNo] + CASE WHEN ISNULL(ile.[VariantCode], '') = '' THEN '' ELSE '-' + ile.[VariantCode] END AS NVARCHAR(255)),
				CAST(ile.[LocationCode] AS NVARCHAR(255)),
				CAST(ile.[PostingDate] AS DATE)
		) T1

