
CREATE VIEW [cus].[v_PURCHASE_ORDER_ROUTE]
AS

 SELECT
                CAST([ITEM_NO] AS NVARCHAR(255)) AS [ITEM_NO],
                CAST([LOCATION_NO] AS NVARCHAR(255)) AS [LOCATION_NO],
                CAST(pd.Supplier AS NVARCHAR(255)) AS [VENDOR_NO],
				CAST(1 AS BIT) AS [PRIMARY],
				CAST(pd.MaterialPlannedDeliveryDurn AS SMALLINT) AS LEAD_TIME_DAYS,				
                CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],
				CASE 
				WHEN pd.PurgDocOrderQuantityUnit=ipl.BaseUnit 
					THEN CAST(pd.MinimumPurchaseOrderQuantity AS DECIMAL(18,4))
				ELSE 
					CAST(pd.MinimumPurchaseOrderQuantity/ISNULL(CAST(uom.QuantityDenominator AS DECIMAL(18,4)),1) AS DECIMAL(18,4)) END AS [MIN_ORDER_QTY],
			   CAST(NULL AS DECIMAL(18,4)) AS [COST_PRICE],
				CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
				 CASE 
				WHEN TRY_CAST(REPLACE(REPLACE(psp.LotSizeRoundingQuantity, ' ', ''), ',', '.') AS DECIMAL(18,4))<1 
					THEN CAST (1 AS DECIMAL(18,4))
				ELSE TRY_CAST(REPLACE(REPLACE(psp.LotSizeRoundingQuantity, ' ', ''), ',', '.') AS DECIMAL(18,4)) END
				AS [ORDER_MULTIPLE],
                CAST(NULL AS INT) AS [QTY_PALLET]
	FROM cus.v_ITEM_LOCATION pa
	INNER JOIN cus.PlantData pd ON pd.Material=pa.ITEM_NO AND pa.LOCATION_NO= '7901' ---(SELECT no FROM cus.v_LOCATION)
		AND pd.Supplier NOT IN (SELECT NO FROM cus.v_LOCATION) AND pd.plant=''
					
		AND pd.IsMarkedForDeletion<>1
		JOIN cus.v_ITEM pinf ON pinf.NO=pa.ITEM_NO AND pinf.PRIMARY_vendor_no=pd.Supplier
				 
		JOIN cus.ItemPlant ipl ON ipl.Product=pd.Material AND ipl.Plant='7901'
	INNER JOIN cus.ProductUoM uom ON uom.Product=ipl.Product AND pd.PurgDocOrderQuantityUnit=uom.AlternativeUnit
	LEFT JOIN cus.ProductSupplyPlanning psp ON psp.product=ipl.Product AND psp.plant=ipl.Plant
WHERE 1 = 0

