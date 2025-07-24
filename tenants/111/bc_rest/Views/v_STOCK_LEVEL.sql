-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Stock level from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_STOCK_LEVEL]
AS


    SELECT
        CAST(ile.[ItemNo] + CASE WHEN ISNULL(ile.[VariantCode], '') = '' THEN '' ELSE '-' + ile.[VariantCode] END AS NVARCHAR(255)) AS ITEM_NO,
        CAST(ile.[LocationCode] AS NVARCHAR(255)) AS LOCATION_NO,
        --CAST(IIF((ile.[ExpirationDate]='0001-01-01 00:00:00.000'), DATEFROMPARTS(2100, 1, 1),ile.[ExpirationDate]) AS DATE) AS EXPIRE_DATE,
		CAST(DATEFROMPARTS(2100, 1, 1) AS DATE) AS EXPIRE_DATE,
        CAST(SUM(ile.Quantity) AS DECIMAL(18,4)) AS STOCK_UNITS
    FROM
        [bc_rest].item_ledger_entry ile
        JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[LocationCode]
    GROUP BY
        ile.[ItemNo], ile.[VariantCode], ile.[LocationCode]
    HAVING SUM(ile.Quantity)<>0


