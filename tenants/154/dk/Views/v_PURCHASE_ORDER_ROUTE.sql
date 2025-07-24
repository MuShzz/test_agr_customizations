


-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Purchase order route mapping from dk
--
--  24.10.2024.TO   Created
-- ===============================================================================
CREATE VIEW [dk_cus].[v_PURCHASE_ORDER_ROUTE]
AS

	WITH vendor AS (
		SELECT ipv.[ItemCode], 
			   ipv.[Vendors.Vendor], 
			   ipv.[Vendors.PrimarySupplier],
			   ipv.[Vendors.LastPurchasedPrice], 
			   ROW_NUMBER() OVER (
					PARTITION BY ipv.[ItemCode] 
					ORDER BY ipv.[Vendors.PrimarySupplier] DESC, ipv.[Vendors.LastPurchasedDate] DESC
			   ) AS rn, -- Original row number (untouched)
			   ROW_NUMBER() OVER (
					PARTITION BY ipv.[ItemCode], ipv.[Vendors.Vendor] 
					ORDER BY 
						CASE WHEN ipv.[Vendors.ItemCode] IS NULL OR ipv.[Vendors.ItemCode] = '' THEN 1 ELSE 0 END,  -- Prioritize non-empty ItemCodes
						ipv.[Vendors.LastPurchasedDate] DESC  -- More recent LastPurchasedDate
			   ) AS rn2, -- New row number to handle vendor duplicates
			   iv.[Delivery.DeliveryTime], 
			   ipv.[Vendors.ItemCode]--,
			   --iv.CurrencyCode
		FROM [dk].[import_product_vendors] ipv
		LEFT JOIN [dk].[import_vendor] iv 
			ON ipv.[Vendors.Vendor] = iv.[Number]
	)

	SELECT
		CAST(v.[ItemCode] AS NVARCHAR(255)) AS [item_no],
		CAST('bg1' AS NVARCHAR(255)) AS [location_no],
		CAST(v.[Vendors.Vendor] AS NVARCHAR(255)) AS [vendor_no],
		CAST(CASE WHEN v.rn = 1 THEN 1 ELSE 0 END AS BIT) AS [primary], -- Use original rn for primary selection
		CAST(ISNULL(v.[Delivery.DeliveryTime],1) AS SMALLINT) AS [lead_time_days],
		CAST(NULL AS SMALLINT) AS [order_frequency_days],
		CAST(NULL AS DECIMAL(18,4)) AS [min_order_qty],    -- Return NULL if value 0.0
		CAST(NULL AS DECIMAL(18,4)) AS [cost_price],
		CAST(v.[Vendors.LastPurchasedPrice] AS DECIMAL(18,4)) AS [purchase_price],
		CAST(NULL AS DECIMAL(18,4)) AS [order_multiple],   -- Return NULL if value 0.0
		CAST(NULL AS DECIMAL(18,4)) AS [qty_pallet]
	FROM vendor v
	--JOIN dk.import_vendor iv ON iv.Number = v.[Vendors.Vendor]
	--JOIN dk.import_products ip ON ip.ItemCode = v.ItemCode
	WHERE v.ItemCode NOT IN ('01-akstur','01-flutningur') 
	AND v.rn2 = 1 -- Ensures we only pick the best vendor per ItemCode-Vendor
	AND v.[Vendors.Vendor] IS NOT NULL

	--AND v.ItemCode = '07-13360152'



