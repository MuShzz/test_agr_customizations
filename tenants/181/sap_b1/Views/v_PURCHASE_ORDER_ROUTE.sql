CREATE VIEW [sap_b1_cus].[v_PURCHASE_ORDER_ROUTE] AS
	SELECT
		CAST(it.ItemCode AS NVARCHAR(255))       AS [ITEM_NO],
		CAST(ow.WhsCode AS NVARCHAR(255))          AS [LOCATION_NO],               -- Placeholder for future OITW join
		CAST(COALESCE(itm2.VendorCode,it.CardCode) AS NVARCHAR(255))     AS [VENDOR_NO],
		CAST(CASE 
					WHEN itm2.VendorCode = it.CardCode THEN 1 
					ELSE 0 
				END AS BIT) AS [primary],
		CAST(it.LeadTime AS SMALLINT)              AS [LEAD_TIME_DAYS],
		CAST(it.OrdrIntrvl AS SMALLINT)            AS [ORDER_FREQUENCY_DAYS],
		CAST(NULL AS DECIMAL(18, 4))               AS [MIN_ORDER_QTY],
		CAST(it.AvgPrice AS DECIMAL(18, 4))		   AS [COST_PRICE],                -- From OITM
		CAST(NULL AS DECIMAL(18, 4))			   AS [PURCHASE_PRICE],           
		CAST(it.OrdrMulti AS DECIMAL(18, 4))       AS [ORDER_MULTIPLE],
		CAST(NULL AS DECIMAL(18, 4))               AS [QTY_PALLET]
	FROM
		[sap_b1].OITM it
		LEFT JOIN sap_b1.OITW ow ON ow.ItemCode=it.ItemCode
		LEFT JOIN [sap_b1].ITM2 itm2 ON itm2.ItemCode=it.ItemCode
		INNER JOIN core.location_mapping_setup lms ON lms.locationNo=ow.WhsCode
	WHERE it.CardCode IS NOT NULL

	

