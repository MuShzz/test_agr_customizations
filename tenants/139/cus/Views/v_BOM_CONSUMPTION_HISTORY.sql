
CREATE VIEW [cus].[v_BOM_CONSUMPTION_HISTORY] AS
    SELECT
        ROW_NUMBER() OVER(ORDER BY  CAST(ile.[PostingDate] AS DATE)) AS [transaction_id],
        CAST(ile.[ItemNo] + CASE WHEN ISNULL(ile.[VariantCode], '') = '' THEN '' ELSE '-' + ile.[VariantCode] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST(ile.[LocationCode] AS NVARCHAR(255))			AS LOCATION_NO,
        CAST(ile.[PostingDate] AS DATE)						AS [DATE],
        CAST(SUM(-ile.[Quantity]) AS DECIMAL(18,4))			AS [UNIT_QTY],
		ile.Company
    FROM
        [cus].item_ledger_entry ile
		JOIN core.setting s ON s.[settingKey] = 'sale_history_retention_years'
    WHERE
        ile.[EntryType] IN ('Consumption', 'Assembly Consumption')
        AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.settingvalue AS INT),CAST(GETDATE() AS DATE))
    GROUP BY
        ile.[ItemNo], ile.[VariantCode], ile.[LocationCode], CAST(ile.[PostingDate] AS DATE), ile.Company


