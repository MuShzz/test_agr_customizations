-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Multiple Vendor mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_PURCHASE_ORDER_ROUTE]
AS
	
	WITH RankedVendors AS (
		SELECT
			pll.*,
			ROW_NUMBER() OVER (
				PARTITION BY pll.Asset_No, pll.Source_No, pll.Variant_Code
				ORDER BY pll.Minimum_Quantity ASC
			) AS rn
		FROM bc_rest_cus.AGR_Price_List_Lines pll
	)

	SELECT
		CAST(i.[No] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS [item_no],
		CAST(lms.locationNo AS NVARCHAR(255)) AS [location_no],
		CAST(COALESCE(iven.VendorNo, i.VendorNo) AS NVARCHAR(255)) AS [vendor_no],
		CAST(CASE 
				WHEN COALESCE(iven.VendorNo, i.VendorNo) = i.VendorNo THEN 1 
				ELSE 0 
			END AS BIT) AS [primary],
		bc_rest.LeadTimeConvert(iven.LeadTimeCalculation,GETDATE()) AS [lead_time_days],
		CAST(NULL AS SMALLINT) AS [order_frequency_days],
		CAST(pll.Minimum_Quantity AS DECIMAL(18,4)) AS [min_order_qty],
		CAST(pll.Unit_Cost AS DECIMAL(18,4)) AS [cost_price],
		CAST(pll.DirectUnitCost AS DECIMAL(18,4)) AS [purchase_price],
		CAST(NULL AS DECIMAL(18,4)) AS [order_multiple],
		CAST(NULL AS DECIMAL(18,4)) AS [qty_pallet]
	FROM
		bc_rest.item i
		LEFT JOIN [bc_rest].item_variant iv				ON iv.[ItemNo] = i.[No]
		LEFT JOIN [bc_rest].item_vendor iven ON iven.ItemNo=i.No AND (
			(iv.Code IS NOT NULL AND iv.Code = iven.VariantCode)
			OR (iv.Code IS NULL AND (iven.VariantCode IS NULL OR iven.VariantCode = ''))
		)
		LEFT JOIN RankedVendors pll 
			ON pll.rn = 1
			AND pll.Asset_No = COALESCE(iv.ItemNo, i.No)
			AND pll.Source_No = COALESCE(iven.VendorNo, i.VendorNo)
			AND (
				(iv.Code IS NOT NULL AND iv.Code = pll.Variant_Code)
				OR (iv.Code IS NULL AND (pll.Variant_Code IS NULL OR pll.Variant_Code = ''))
			)
		cross JOIN core.location_mapping_setup lms 



