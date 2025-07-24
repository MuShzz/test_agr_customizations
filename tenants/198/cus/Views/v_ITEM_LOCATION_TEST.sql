
CREATE VIEW [cus].[v_ITEM_LOCATION_TEST]

AS

		WITH stores_extra_info AS (
		SELECT DISTINCT 
			itp.Product AS ITEM_NO,
			itp.Plant AS LOCATION_NO,
			CASE WHEN TRY_CAST(REPLACE(REPLACE(LotSizeRoundingQuantity, ' ', ''), ',', '') AS DECIMAL(18,4))=0 
				THEN CAST (1 AS DECIMAL(18,4))
				ELSE TRY_CAST(REPLACE(REPLACE(LotSizeRoundingQuantity, ' ', ''), ',', '') AS DECIMAL(18,4)) 
			END AS [ORDER_MULTIPLE]
		FROM cus.ItemPlant itp
		LEFT JOIN cus.ProductSupplyPlanning psp ON psp.Product=itp.Product AND psp.Plant=itp.Plant
		WHERE itp.Plant <> '7901'
		), 
		warehouse_extra_info AS (
		SELECT DISTINCT
			CAST(pd.Material AS NVARCHAR(255)) AS [ITEM_NO],
			CAST(ipl.Plant AS NVARCHAR(255)) AS [LOCATION_NO],
			CAST(pir.Supplier AS NVARCHAR(255)) AS [VENDOR_NO],
			CAST(pd.MaterialPlannedDeliveryDurn AS SMALLINT) AS LEAD_TIME_DAYS,		
			CASE WHEN pd.PurgDocOrderQuantityUnit=ipl.BaseUnit 
				THEN CAST(pd.MinimumPurchaseOrderQuantity AS DECIMAL(18,4))
				ELSE CAST(pd.MinimumPurchaseOrderQuantity/ISNULL(CAST(uom.QuantityDenominator AS DECIMAL(18,4)),1) AS DECIMAL(18,4)) 
			END AS [MIN_ORDER_QTY],
			CASE WHEN TRY_CAST(REPLACE(REPLACE(psp.LotSizeRoundingQuantity, ' ', ''), ',', '.') AS DECIMAL(18,4))<1 
				THEN CAST (1 AS DECIMAL(18,4))
				ELSE TRY_CAST(REPLACE(REPLACE(psp.LotSizeRoundingQuantity, ' ', ''), ',', '.') AS DECIMAL(18,4)) 
			END AS [ORDER_MULTIPLE]
		FROM cus.PlantData pd --ON pd.Material=pa.ITEM_NO AND pa.LOCATION_NO= '7901' ---(SELECT no FROM cus.v_LOCATION)	 
		JOIN cus.ItemPlant ipl ON ipl.Product=pd.Material AND ipl.Plant='7901'
		INNER JOIN cus.ProductUoM uom ON uom.Product=ipl.Product AND pd.PurgDocOrderQuantityUnit=uom.AlternativeUnit
		LEFT JOIN cus.ProductSupplyPlanning psp ON psp.product=ipl.Product AND psp.plant=ipl.Plant
		inner JOIN (
				SELECT 
				Material, Supplier AS Supplier,
				SupplierMaterialNumber AS SupplierMaterialNumber  
				,CAST([OrderItemQtyToBaseQtyDnmntr] AS DECIMAL(18,4)) AS order_multiple
				FROM  cus.[PurchasingInfoRecord]
					WHERE IsRegularSupplier=1
				) pir ON pir.Material=ipl.product AND pir.Supplier = pd.Supplier AND pd.Material = pir.Material
		WHERE pd.Supplier NOT IN (SELECT NO FROM cus.v_LOCATION) AND pd.plant=''			
		AND pd.IsMarkedForDeletion<>1
		) 


	SELECT
		CAST([product] AS NVARCHAR(255)) AS [ITEM_NO],
		CAST([plant] AS NVARCHAR(255)) AS [LOCATION_NO],
		CAST(NULL AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
		CAST(0 AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],
		CAST(NULL AS DECIMAL(18,4)) AS [MAX_STOCK],
		CASE 
			WHEN MRPType='PD' OR MRPType='' OR ipl.MRPType='ND' THEN CAST(1 AS BIT)
			ELSE CAST(0 AS BIT) 
		END AS [CLOSED],
		CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING],
		CASE 
			WHEN re.name IS NULL THEN ipl.PurchasingGroup
			ELSE ipl.PurchasingGroup+'-'+ISNULL(re.name,'') 
		END AS [RESPONSIBLE],
		CAST(NULL AS NVARCHAR(255)) AS [NAME],
		CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION],
		CAST(wei.VENDOR_NO AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
		CAST(wei.LEAD_TIME_DAYS AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
		CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS],
		CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],
		CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS],
		CAST(wei.MIN_ORDER_QTY AS DECIMAL(18,4)) AS [MIN_ORDER_QTY],
		CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO],
		CAST(NULL AS DECIMAL(18,4)) AS [SALE_PRICE],
		CAST(NULL AS DECIMAL(18,4)) AS [COST_PRICE],
		CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
		CASE WHEN ipl.Plant = '7901' 
			THEN CAST(wei.ORDER_MULTIPLE AS DECIMAL(18,4))
			ELSE CAST(sei.ORDER_MULTIPLE AS DECIMAL(18,4)) 
		END AS [ORDER_MULTIPLE],
		CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET],
		CAST(NULL AS DECIMAL(18,4)) AS [VOLUME],
		CAST(NULL AS DECIMAL(18,4)) AS [WEIGHT],
		CAST(0 AS DECIMAL(18,4)) AS [REORDER_POINT],
		CAST(1 AS BIT) AS [INCLUDE_IN_AGR],
		CAST(NULL AS BIT) AS [SPECIAL_ORDER]
		FROM cus.ItemPlant ipl
	INNER JOIN cus.v_LOCATION loc ON loc.NO=ipl.Plant
	LEFT JOIN cus.responsible re ON ipl.PurchasingGroup=re.no
	LEFT JOIN stores_extra_info sei ON sei.ITEM_NO = ipl.Product AND sei.LOCATION_NO = ipl.Plant
	LEFT JOIN warehouse_extra_info wei ON wei.ITEM_NO = ipl.Product AND wei.LOCATION_NO = ipl.Plant
	WHERE ipl.plant NOT IN ('7029','7021','7001'
	,'7007'
	,'7010'
	,'7011'
	,'7012'
	,'7016'
	,'7018'
	,'7026'
	,'7028'
	,'7031'
	,'7002' 
	,'7003'
	,'7004'
	,'7005'
	,'7006'
	,'7008'
	,'7009'
	,'7013'
	,'7014'
	,'7015'
	,'7017'
	,'7019'
	,'7020'
	,'7022'
	,'7023'
	,'7024'
	,'7025'
	,'7027'
	,'7032'
	,'7033'
	,'7034'
	,'7035'
	,'7030'
	)

	UNION ALL


SELECT
    CAST([product] AS NVARCHAR(255)) AS [ITEM_NO],
    CAST([plant] AS NVARCHAR(255)) AS [LOCATION_NO],
    CAST(NULL AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
    CAST(0 AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],
    CAST(NULL AS DECIMAL(18,4)) AS [MAX_STOCK],
    CASE 
		WHEN ipl.MRPType='YD' THEN CAST(0 AS BIT)
		ELSE CAST(1 AS BIT) 
	END AS [CLOSED],
    CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING],
    CASE 
		WHEN re.name IS NULL THEN ipl.PurchasingGroup
		ELSE ipl.PurchasingGroup+'-'+ISNULL(re.name,'') 
	END AS [RESPONSIBLE],
    CAST(NULL AS NVARCHAR(255)) AS [NAME],
    CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION],
    CAST(wei.VENDOR_NO AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
    CAST(wei.LEAD_TIME_DAYS AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
    CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS],
    CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],
    CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS],
    CAST(wei.MIN_ORDER_QTY AS DECIMAL(18,4)) AS [MIN_ORDER_QTY],
    CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO],
    CAST(NULL AS DECIMAL(18,4)) AS [SALE_PRICE],
    CAST(NULL AS DECIMAL(18,4)) AS [COST_PRICE],
    CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
	CASE WHEN ipl.Plant = '7901' 
		THEN CAST(wei.ORDER_MULTIPLE AS DECIMAL(18,4))
		ELSE CAST(sei.ORDER_MULTIPLE AS DECIMAL(18,4)) 
	END AS [ORDER_MULTIPLE],
    CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET],
    CAST(NULL AS DECIMAL(18,4)) AS [VOLUME],
    CAST(NULL AS DECIMAL(18,4)) AS [WEIGHT],
    CAST(NULL AS DECIMAL(18,4)) AS [REORDER_POINT],
    CAST(1 AS BIT) AS [INCLUDE_IN_AGR],
    CAST(NULL AS BIT) AS [SPECIAL_ORDER]
FROM cus.ItemPlant ipl
INNER JOIN cus.v_LOCATION loc ON loc.NO=ipl.Plant
LEFT JOIN cus.responsible re ON ipl.PurchasingGroup=re.no		   
LEFT JOIN stores_extra_info sei ON sei.ITEM_NO = ipl.Product AND sei.LOCATION_NO = ipl.Plant
LEFT JOIN warehouse_extra_info wei ON wei.ITEM_NO = ipl.Product AND wei.LOCATION_NO = ipl.Plant
WHERE ipl.plant IN ('7029','7021'
,'7001'
,'7007'
,'7010'
,'7011'
,'7012'
,'7016'
,'7018'
,'7026'
,'7028'
,'7031'
,'7002' 
,'7003'
,'7004'
,'7005'
,'7006'
,'7008'
,'7009'
,'7013'
,'7014'
,'7015'
,'7017'
,'7019'
,'7020'
,'7022'
,'7023'
,'7024'
,'7025'
,'7027'
,'7032'
,'7033'
,'7034'
,'7035'
,'7030')


