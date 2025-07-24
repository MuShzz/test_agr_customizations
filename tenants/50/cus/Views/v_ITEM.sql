CREATE VIEW [cus].[v_ITEM] AS
	   SELECT
        CAST(i.[itemid] AS NVARCHAR(255)) AS [NO],
        CAST(i.[displayname] AS NVARCHAR(255)) AS [NAME],
        CAST(i.[description] AS NVARCHAR(1000)) AS [DESCRIPTION],
        CAST(v.entityid AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],
        CAST(30 AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS], 
        CAST(NULL AS SMALLINT ) AS [ORDER_FREQUENCY_DAYS], 
        CAST(NULL AS SMALLINT ) AS [ORDER_COVERAGE_DAYS], 
        CAST(i.custitem_hh_moq AS DECIMAL(18,4)) AS [MIN_ORDER_QTY],
        CAST(iv.vendorcode AS NVARCHAR(50)) AS [ORIGINAL_NO],
        CAST(IIF(i.custitem_horwood_discontinued = 'T' OR i.[custitem_hh_sup_item] IS NOT NULL,1,0) AS BIT) AS [CLOSED_FOR_ORDERING],
        CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE], 
        CAST(p.[unitprice] AS DECIMAL(18,4)) AS [SALE_PRICE],
        CAST(NULL AS DECIMAL(18,4)) AS [COST_PRICE], 
        CAST(iv.[purchaseprice] AS DECIMAL(18,4)) AS [PURCHASE_PRICE],
        CAST(1 AS DECIMAL(18,4)) AS [ORDER_MULTIPLE],
        CAST(1 AS DECIMAL(18,4)) AS [QTY_PALLET],
        CAST(NULLIF(i.[custitem_hw_ot_length]*i.[custitem_hw_ot_width]*i.[custitem_hw_ot_height],0)/1000000 AS DECIMAL(18,6)) AS [VOLUME],
        CAST(i.[weight] AS DECIMAL(18,6)) AS [WEIGHT],

        CAST(NULL AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],

        CAST(NULL AS DECIMAL(18,4)) AS [MAX_STOCK], 
        CAST(i.[custitem_horwood_item_type_id] AS NVARCHAR(255))+'_type' AS [ITEM_GROUP_NO_LVL_1],
        CAST(i.[custitemcustitem_horwood_item_category_id] AS NVARCHAR(255))+'_category' AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255)) AS [ITEM_GROUP_NO_LVL_3],
        CAST(i.[stockunit] AS NVARCHAR(50)) AS [BASE_UNIT_OF_MEASURE],
        CAST(i.[purchaseunit] AS NVARCHAR(50)) AS [PURCHASE_UNIT_OF_MEASURE],
        CAST(1 AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
        CAST(0 AS DECIMAL(18,4)) AS [SPECIAL_ORDER],
        CAST(0 AS DECIMAL(18,4)) AS [REORDER_POINT],
		CAST(IIF(i.[isinactive] = 'T',1,0) AS BIT) AS [CLOSED],
		CAST(0 AS BIT) AS [INCLUDE_IN_AGR]
     FROM
        [cus].[Item] i
        LEFT JOIN [cus].[ItemVendor] iv ON i.id = iv.item AND iv.[preferredvendor] = 'T'
        LEFT JOIN [cus].[Vendor] v ON iv.vendor = v.id
        LEFT JOIN [cus].[Pricing] p ON p.item = i.id
		
		WHERE ISNULL(i.[isinactive],'F') <> 'T' AND i.displayname IS NOT NULL
        AND i.[displayname] not like 'Drop Ship%'
