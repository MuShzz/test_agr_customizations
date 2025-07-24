

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Netsuite
--
--  29.09.2024.TO   Altered
-- ===============================================================================


    CREATE VIEW [cus].[v_PURCHASE_ORDER_ROUTE] AS
       SELECT
            CAST(iil.item_code AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(iil.location_name  AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(v.entityid AS NVARCHAR(255)) AS [VENDOR_NO],
            CAST(IIF(iv.[preferredvendor] = 'T',1,0) AS BIT) AS [PRIMARY],
            CAST(NULL AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],
			CASE WHEN iil.[location_name] = 'Amazon FBA UK' THEN 1
            WHEN iil.[location_name] = 'Bristol' THEN ISNULL(i.[custitem_hh_moq], 1)
			    END AS [MIN_ORDER_QTY],   
            CAST(iv.vendorcost AS DECIMAL(18, 4)) AS [COST_PRICE],
            CAST(iv.purchaseprice AS DECIMAL(18, 4)) AS [PURCHASE_PRICE],
            CASE WHEN iil.[location_name] = 'Amazon FBA UK' THEN 1
			    WHEN iil.[location_name] = 'Bristol' THEN ISNULL(i.[custitem_hh_ot_qty], 1)
			    END AS [ORDER_MULTIPLE],
            CAST(NULL AS DECIMAL(18, 4)) AS [QTY_PALLET]
          FROM [cus].[ItemVendor] iv
          INNER JOIN [cus].[Vendor] v ON iv.vendor = v.id
          INNER JOIN [cus].[InventoryItemLocations] iil ON  iv.item = iil.item
		  LEFT JOIN [cus].[Item] i ON iil.item = i.id


