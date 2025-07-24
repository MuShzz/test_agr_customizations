

    CREATE VIEW [cus].[v_STOCK_HISTORY] AS
      SELECT 
		CAST(CONCAT(CONVERT(VARCHAR, CAST([DATE] AS DATE), 112), 100000000 + (ROW_NUMBER() OVER (PARTITION BY [DATE] ORDER BY [DATE], [ITEM_NO]))) AS BIGINT) AS [TRANSACTION_ID],
		[ITEM_NO],
		[LOCATION_NO],
		[DATE],
		[STOCK_MOVE],
		[STOCK_LEVEL]
		FROM (	
		   SELECT
				CAST([ItemNo] + CASE WHEN ISNULL([VariantCode], '') = '' THEN '' ELSE '-' + [VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO],
				CAST([LocationCode] AS NVARCHAR(255)) AS [LOCATION_NO],
				CAST([PostingDate] AS DATE) AS [DATE],
				CAST(SUM([Quantity]) AS DECIMAL(18,4)) AS [STOCK_MOVE],
				CAST(NULL AS DECIMAL(18,4)) AS [STOCK_LEVEL]
		   FROM
				[cus].item_ledger_entry ile
				JOIN core.[location_mapping_setup] lm ON lm.locationNo = ile.[LocationCode]
		   GROUP BY
				CAST([ItemNo] + CASE WHEN ISNULL([VariantCode], '') = '' THEN '' ELSE '-' + [VariantCode] END AS NVARCHAR(255)), 
				CAST([LocationCode] AS NVARCHAR(255)), 
				CAST([PostingDate] AS DATE)
		) T1

