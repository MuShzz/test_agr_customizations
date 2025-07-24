




CREATE VIEW [cus].[v_ITEM]
             AS

    SELECT DISTINCT
	i.product AS NO
      ,ISNULL(id.item_name,'Missing') NAME
     , id.item_name AS DESCRIPTION
	 ,CAST(pir.Supplier AS NVARCHAR(255)) AS PRIMARY_VENDOR_NO
	 ,CAST(2 AS SMALLINT) AS PURCHASE_LEAD_TIME_DAYS
	 ,CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS]
     ,CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS]
     ,CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS]
     ,CAST(NULL AS DECIMAL(18,4)) AS [MIN_ORDER_QTY]
     ,pir.SupplierMaterialNumber AS ORIGINAL_NO
     , CAST(i.IsMarkedForDeletion AS BIT ) AS CLOSED
	 ,CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING]
     ,CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE]
     ,CAST(1.0 AS DECIMAL(18,4)) AS SALE_PRICE
	 ,CAST(pv.MovingAveragePrice AS DECIMAL(18,4)) AS COST_PRICE
     ,CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE]
	 ,CAST(1 AS DECIMAL(18,4)) AS ORDER_MULTIPLE
	 ,CAST(pal.QuantityNumerator AS INT) AS QTY_PALLET
	 ,CAST(vol.MaterialVolume AS DECIMAL(18,4)) AS VOLUME
     ,CAST(i.GrossWeight AS DECIMAL(18,4)) AS WEIGHT
     ,CAST(NULL AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS]
     ,CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK]
     ,CAST(NULL AS DECIMAL(18,4)) AS [MAX_STOCK]
     ,i.productGroup AS [ITEM_GROUP_NO_LVL_1]
     ,CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_2]
     ,CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_3]
     ,CAST(NULL AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE]
     ,CAST(NULL AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE]
     ,CAST(NULL AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT]
     ,CAST(0 AS DECIMAL(18,4)) AS [REORDER_POINT]
     ,CAST(NULL AS BIT) AS [SPECIAL_ORDER]
     ,CAST(0 AS BIT) AS [INCLUDE_IN_AGR]      
       
--SELECT  *
FROM cus.Item i
LEFT JOIN  (SELECT Product, MAX(ProductDescription) AS item_name FROM cus.ItemDescription WHERE Language='NO' GROUP BY Product ) id ON id.Product=i.product
LEFT JOIN cus.ProductValuation pv ON pv.Product=i.Product
LEFT JOIN (
	SELECT 
	Material, Supplier AS Supplier,
	SupplierMaterialNumber AS SupplierMaterialNumber  
	,CAST([OrderItemQtyToBaseQtyDnmntr] AS DECIMAL(18,4)) AS order_multiple
	FROM  cus.[PurchasingInfoRecord]
		WHERE IsRegularSupplier=1
	) pir ON pir.Material=i.product
	LEFT JOIN (SELECT product, MaterialVolume FROM  cus.ProductUoM  WHERE baseunit=alternativeUnit ) vol ON vol.Product=i.Product
	LEFT JOIN (SELECT product, QuantityNumerator FROM  cus.ProductUoM  WHERE alternativeUnit='PAL' ) pal ON pal.Product=i.Product
	LEFT JOIN (SELECT product, QuantityNumerator FROM  cus.ProductUoM  WHERE alternativeUnit='CAR' ) car ON car.Product=i.Product
	-- 20.06.2025.DRG added to make sure we don't get items into AGR that are not in the item_location view, but are in the item table. 
	INNER JOIN cus.ItemPlant ipl ON ipl.Product = i.Product
	INNER JOIN cus.v_LOCATION loc ON loc.NO=ipl.Plant
	WHERE (ipl.plant = '7901' AND ipl.MRPType IN ('Z1','V1','YD'))
	OR  (ipl.Plant IN ('7001','7002','7003','7004','7005','7006','7007','7008','7009',
					  '7010','7011','7012','7013','7014','7015','7016','7017','7018',
					  '7019','7020','7021','7022','7023','7024','7025','7026','7027',
					  '7028','7029','7030','7031','7032','7033','7034','7035')
				   AND ipl.MRPType = 'YD')


