
-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Transfer transactions from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_TRANSFER_HISTORY]
AS

    SELECT
		ile.[EntryNo] AS [TRANSACTION_ID],
        CAST(ile.[ItemNo] AS NVARCHAR(255)) AS [ITEM_NO],
		CAST(ile.[LocationCode] AS NVARCHAR(255)) AS FROM_LOCATION_NO,
        CAST(NULL AS NVARCHAR(255)) AS TO_LOCATION_NO,
        CAST(ile.[PostingDate] AS DATE) AS [DATE],
		CAST(-ile.[Quantity] AS DECIMAL(18,4)) AS TRANSFER
    FROM
        bc_rest.item_ledger_entry ile
        JOIN core.setting s ON s.settingKey = 'sale_history_retention_years'
        JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[LocationCode]
    WHERE
        ile.[EntryType] = 'Transfer'
        AND CAST(ile.[PostingDate] AS DATE) > DATEADD(YEAR,-CAST(s.settingValue AS INT),CAST(GETDATE() AS DATE))

