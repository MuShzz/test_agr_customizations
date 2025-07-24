-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Stock level from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_STOCK_LEVEL]
AS


    --SELECT
    --    CAST(ile.[ItemNo] + CASE WHEN ISNULL(ile.[VariantCode], '') = '' THEN '' ELSE '-' + ile.[VariantCode] END AS NVARCHAR(255)) AS ITEM_NO,
    --    CAST(ile.[LocationCode] AS NVARCHAR(255)) AS LOCATION_NO,
    --    CAST(IIF((ile.[ExpirationDate]='0001-01-01 00:00:00.000'), DATEFROMPARTS(2100, 1, 1),ile.[ExpirationDate]) AS DATE) AS EXPIRE_DATE,
    --    CAST(SUM(ile.Quantity) AS DECIMAL(18,4)) AS STOCK_UNITS
    --FROM
    --    [bc_rest].item_ledger_entry ile
    --    JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[LocationCode]
    --GROUP BY
    --    ile.[ItemNo], ile.[VariantCode], ile.[LocationCode], ile.[ExpirationDate]
    --HAVING SUM(ile.Quantity)<>0

	-- plus customisation
	SELECT
        CAST(pvi.Item_No AS NVARCHAR(255)) AS ITEM_NO,
        CAST(lms.locationNo AS NVARCHAR(255)) AS LOCATION_NO,
        DATEFROMPARTS(2100, 1, 1) AS EXPIRE_DATE,
        CAST(SUM(pvi.Inventory) AS DECIMAL(18,4)) AS STOCK_UNITS
    FROM
        bc_rest_cus.people_vox_inventory pvi
		CROSS JOIN core.location_mapping_setup lms
    GROUP BY
        pvi.Item_No, lms.locationNo
	HAVING SUM(pvi.Inventory) <>0


