
-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Stock transactions from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_STOCK_HISTORY]
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
		CAST(ile.[Quantity] AS DECIMAL(18,4)) AS STOCK_MOVE,
		CAST(NULL AS DECIMAL(18,4)) AS STOCK_LEVEL
    FROM
        bc_rest.item_ledger_entry ile
        --JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[LocationCode]

