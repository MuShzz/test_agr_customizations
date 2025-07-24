




    CREATE VIEW [cus].[v_UNDELIVERED_TRANSFER_ORDER] AS
       SELECT
            CAST([Document No_] + '_' + [Transfer-from Code] + '-' + [Company] AS VARCHAR(128)) AS [TRANSFER_ORDER_NO],
            CAST([Item No_] + CASE WHEN ISNULL([Variant Code], '') = '' THEN '' ELSE '-' + [Variant Code] END  AS NVARCHAR(255)) AS [ITEM_NO],
            CAST([Transfer-to Code] + '-' + [Company] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST([Receipt Date] AS DATE) AS [DELIVERY_DATE],
            CAST(SUM([Outstanding Qty_ (Base)]) AS DECIMAL(18, 4)) AS [QUANTITY],
            CAST([Transfer-from Code] + '-' + [Company]  AS NVARCHAR(255)) AS [ORDER_FROM_LOCATION_NO],
			[COMPANY]
       FROM
			[cus].TransferLine
		WHERE
			[Outstanding Qty_ (Base)] > 0
			--OR [Transfer-to Code] = '08-HYU'
			--OR [Transfer-from Code] = '08-HYU'
			--AND 1=2
		GROUP BY
			[Document No_], [Transfer-from Code], [Item No_], [Variant Code], [Transfer-to Code], CAST([Receipt Date] AS DATE), [Company]

