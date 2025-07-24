
-- ===============================================================================
-- Author:      Paulo Marques
-- Description: Item mapping from raw to adi
--
--  24.09.2024.TO   Updated
-- ===============================================================================

CREATE VIEW [cus].[v_ITEM] AS
WITH partCostsCalc AS (
			SELECT pc.[PartNum],
				   CASE WHEN pt.CostMethod = 'A' THEN
						ISNULL(pc.[AvgLaborCost]+pc.[AvgBurdenCost]+pc.[AvgMaterialCost]+pc.[AvgSubContCost]+pc.[AvgMtlBurCost],0)
				   
				   ELSE 
						ISNULL(pc.[StdLaborCost]+pc.[StdBurdenCost]+pc.[StdMaterialCost]+pc.[StdSubContCost]+pc.[StdMtlBurCost],0)
				   END AS [TotalCost]
			  FROM cus.PartCost pc
		INNER JOIN cus.Part pt ON pc.PartNum = pt.PartNum
			)
	   SELECT
        CAST(cp.[PartNum] AS NVARCHAR(255)) AS [NO],
        CAST(cp.[PartDescription] AS NVARCHAR(255)) AS [NAME],
        CAST(cp.[PartDescription] AS NVARCHAR(1000)) AS [DESCRIPTION],
        CAST(NULL AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO], --null
        CAST(NULL AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS], --null
        CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS], --null
        CAST(NULL AS SMALLINT ) AS [ORDER_FREQUENCY_DAYS], --null
        CAST(NULL AS SMALLINT ) AS [ORDER_COVERAGE_DAYS], --null
        CAST(NULL AS DECIMAL(18,4)) AS [MIN_ORDER_QTY], --null
        CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO], --null
		CAST(cp.InActive AS BIT) AS [CLOSED],
        CAST(0 AS BIT) AS [CLOSED_FOR_ORDERING],
        CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE], --null
        CAST(cp.[UnitPrice] AS DECIMAL(18,4)) AS [SALE_PRICE],
        CAST(cpcs.[TotalCost] AS DECIMAL(18,4)) AS [COST_PRICE],
        CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE], --null
        CAST(1 AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
        CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET], --null
        CAST(NULL AS DECIMAL(18,6)) AS [VOLUME], --null
        CAST(cp.[GrossWeight] AS DECIMAL(18,6)) AS [WEIGHT],
        CAST(NULL AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],
        CAST(NULL AS DECIMAL(18,4)) AS [MAX_STOCK], --null
        CAST(cp.[ProdCode] AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_1],
        CAST(cp.[ClassID] AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_3], --null
        CAST(cp.[IUM] AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE],
        CAST(cp.[PUM] AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(1 AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
        CAST(0 AS BIT) AS [SPECIAL_ORDER],
        CAST(0 AS DECIMAL(18,4)) AS [REORDER_POINT],
		CAST(0 AS BIT) AS [INCLUDE_IN_AGR]
    FROM cus.Part cp
	   LEFT JOIN partCostsCalc cpcs ON cp.[PartNum] = cpcs.[PartNum]
	   WHERE cp.ProdCode <> '831'



