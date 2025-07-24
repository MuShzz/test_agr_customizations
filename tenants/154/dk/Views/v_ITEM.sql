


-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: ITEM mapping from dk

-- 24.10.2024.JOSÉ SUCENA    - ADI VIEWS
-- ===============================================================================

CREATE VIEW [dk_cus].[v_ITEM]
AS
	
	WITH vendor AS (
		 SELECT ipv.[ItemCode], 
				ipv.[Vendors.Vendor], 
				ipv.[Vendors.PrimarySupplier],
				ipv.[Vendors.LastPurchasedPrice], 
				ROW_NUMBER() OVER (PARTITION BY ipv.[ItemCode] ORDER BY ipv.[Vendors.PrimarySupplier] DESC, ipv.[Vendors.LastPurchasedDate] DESC) AS rn, 
				iv.[Delivery.DeliveryTime], 
				ipv.[Vendors.ItemCode]
		   FROM [dk].[import_product_vendors] ipv
	  LEFT JOIN [dk].[import_vendor] iv ON ipv.[Vendors.Vendor] = iv.[Number]
	)
    SELECT
        CAST(im.[ItemCode] AS NVARCHAR(255))									AS [NO],
        ISNULL(CAST(im.[Description] AS NVARCHAR(255)),'')						AS [NAME],
        CAST(NULL AS NVARCHAR(50)) 												AS [DESCRIPTION],
        CAST(ipv.[Vendors.Vendor] AS NVARCHAR(255)) 							AS [PRIMARY_VENDOR_NO],
        CAST((CASE WHEN ISNULL(im.[DeliveryTime],0) <> 0 
        	THEN im.[DeliveryTime] WHEN ISNULL(ipv.[Delivery.DeliveryTime],0) 
        	<> 0	THEN ipv.[Delivery.DeliveryTime] ELSE 1	END) AS SMALLINT) 	AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT) 													AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(21 AS SMALLINT) 													AS [ORDER_FREQUENCY_DAYS],
		CAST(NULL AS SMALLINT ) 												AS [ORDER_COVERAGE_DAYS],
		--CAST(ISNULL(REPLACE(moq.[ISBN], ',', '.'),0) AS DECIMAL(18, 4))	    AS [MIN_ORDER_QTY], 
		CAST(NULL AS DECIMAL(18,4))												AS [MIN_ORDER_QTY],
        CAST(COALESCE(ipv.[Vendors.ItemCode], im.[ItemCode]) AS NVARCHAR(255))	AS [ORIGINAL_NO],
        CAST(0 AS BIT) 															AS [CLOSED_FOR_ORDERING],
        CAST(NULL AS NVARCHAR(255)) 											AS [RESPONSIBLE],
        CAST(im.[UnitPrice1] AS DECIMAL(18,4))									AS [SALE_PRICE],
        CAST(im.[CostPrice] AS DECIMAL(18,4)) 									AS [COST_PRICE],
        CAST(ISNULL(im.PurchasePrice,ipv.[Vendors.LastPurchasedPrice]) AS DECIMAL(18,4)) 				AS [PURCHASE_PRICE],
        CAST((CASE WHEN ISNULL(im.[DefaultPurchaseQuantity],0) <> 0 
        	THEN im.[DefaultPurchaseQuantity] ELSE 1 END) AS DECIMAL(18,4))   	AS [ORDER_MULTIPLE],
        CAST(ipu.[Units.UnitQuantity] AS DECIMAL(18,4))							AS [QTY_PALLET],
        CAST(im.[UnitVolume] AS DECIMAL(18,6)) 									AS [VOLUME],
        CAST(im.[NetWeight] AS DECIMAL(18,6)) 									AS [WEIGHT],
		CAST(m.[Warehouses.MinimumStock] AS DECIMAL(18,4))						AS [SAFETY_STOCK_UNITS],
		CAST(NULL AS DECIMAL(18,4)) 											AS [MIN_DISPLAY_STOCK],
        CAST(NULL AS DECIMAL(18,4)) 											AS [MAX_STOCK],
        CAST(im.[Group] AS NVARCHAR(20)) 										AS [ITEM_GROUP_NO_LVL_1],
		CAST(NULL AS NVARCHAR(255)) 											AS [ITEM_GROUP_NO_LVL_2],
		CAST(NULL AS NVARCHAR(255))  											AS [ITEM_GROUP_NO_LVL_3],
		CAST('' AS NVARCHAR(50)) 												AS [BASE_UNIT_OF_MEASURE],
        CAST('' AS NVARCHAR(50)) 												AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(1 AS DECIMAL(18,4)) 												AS [QTY_PER_PURCHASE_UNIT],
        CAST(0 AS BIT)  														AS [SPECIAL_ORDER],
        CAST(0 AS DECIMAL(18,4))  												AS [REORDER_POINT],
        CAST(0 AS BIT) 															AS [INCLUDE_IN_AGR],
        CAST(im.[Inactive] AS BIT) 												AS [CLOSED]

		
	 FROM
        [dk].[import_products] im
        LEFT JOIN vendor ipv ON ipv.[ItemCode] = im.[ItemCode]
        INNER JOIN [dk].[import_product_warehouses] m ON m.[ItemCode] = im.[ItemCode]
		LEFT JOIN (SELECT [ItemCode], [Units.UnitQuantity] FROM [dk].[import_product_units] WHERE [Units.UnitCode] = 'bre') ipu ON ipu.[ItemCode] = im.[ItemCode]
		LEFT JOIN [dk].[import_moq] moq ON moq.[ITEMCODE] = im.[ItemCode]
	WHERE
        im.[Inactive] IN (0,1)
        AND (ipv.rn IS NULL OR ipv.rn = 1)
        --and isnull(im.deleted,0) <> 1 -- exclude items that have been marked as deleted in dk
		AND m.[Warehouses.Warehouse] = 'bg1'
		--AND im.ItemCode IN ('43-1020','43-1030')
    GROUP BY 
        im.[ItemCode],
		im.[Description],
		im.[ItemCode],
		ipv.[Vendors.Vendor],
		ipv.[ItemCode],
		im.[UnitPrice1],
		im.[CostPrice],
		im.[Group], 
		m.[Warehouses.MinimumStock],
		im.[DeliveryTime],
		ipv.[Delivery.DeliveryTime],
		ipv.[ItemCode],
		im.[DefaultPurchaseQuantity],
		ipv.[Vendors.LastPurchasedPrice],
		im.[UnitVolume],
		im.[NetWeight],
		ipu.[Units.UnitQuantity],
		moq.[ISBN],
		ipv.[Vendors.ItemCode],
        im.[Inactive],
		im.PurchasePrice

