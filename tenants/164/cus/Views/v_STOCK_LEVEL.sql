


CREATE VIEW [cus].[v_STOCK_LEVEL] AS
        SELECT
            CAST([ItemNo] + CASE WHEN ISNULL([VariantCode], '') = '' THEN '' ELSE '-' + [VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO],
            CAST([LocationCode] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(SUM(Quantity) AS DECIMAL(18,4)) AS [STOCK_UNITS],
            CAST(IIF((ile.[ExpirationDate]='0001-01-01 00:00:00.000'), DATEFROMPARTS(2100, 1, 1),ile.[ExpirationDate]) AS DATE) AS EXPIRE_DATE,
			CAST(NULL AS CHAR(3)) AS [Company]
       FROM
        [cus].item_ledger_entry ile
        JOIN core.[location_mapping_setup] lm ON lm.locationNo = ile.[LocationCode]
       GROUP BY
        [ItemNo], [VariantCode], [LocationCode], ile.[ExpirationDate]
	HAVING SUM(ile.Quantity)<>0

