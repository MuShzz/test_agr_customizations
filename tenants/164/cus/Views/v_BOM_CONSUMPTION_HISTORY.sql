
-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: BOM consumption history mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- ===============================================================================
CREATE VIEW [cus].[v_BOM_CONSUMPTION_HISTORY]
AS
    
    SELECT
        ile.[EntryNo] AS [TRANSACTION_ID],
        CAST(ile.[ItemNo] + CASE WHEN ISNULL(ile.[VariantCode], '') = '' THEN '' ELSE '-' + ile.[VariantCode] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST(ile.[LocationCode] AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[PostingDate] AS DATE) AS [DATE],
        CAST(-ile.[Quantity] AS DECIMAL(18,4)) AS [UNIT_QTY],
		[Company]
    FROM
        [cus].item_ledger_entry ile
        JOIN core.setting s ON s.[settingKey] = 'sale_history_retention_years'
    WHERE
        ile.[EntryType] IN ('Consumption', 'Assembly Consumption')
        AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.[settingValue] AS INT),CAST(GETDATE() AS DATE))

