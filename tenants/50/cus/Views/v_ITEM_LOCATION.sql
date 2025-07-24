




-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Netsuite
--
--  29.09.2024.TO   Altered
-- ===============================================================================

CREATE   VIEW [cus].[v_ITEM_LOCATION]
AS
SELECT CAST(iil.[item_code] AS NVARCHAR(255)) AS [ITEM_NO],
       CAST(iil.[location_name] AS NVARCHAR(255)) AS [LOCATION_NO],

        CAST(NULL AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],

       CAST(NULL AS DECIMAL(18, 4)) AS [MAX_STOCK],--
       CAST(0 AS BIT) AS [CLOSED_FOR_ORDERING],--
       CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE],--
       CAST(NULL AS NVARCHAR(255)) AS [NAME],--
       CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION],--
       CAST(NULL AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO],--
       CAST(iil.[leadtime] AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS],
       CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS],--
       CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS],--
       CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS],--
       CASE WHEN iil.[location_name] = 'Amazon FBA UK' THEN 1
			   WHEN iil.[location_name] = 'Bristol' THEN ISNULL(i.[custitem_hh_moq], 1)
			   END AS [MIN_ORDER_QTY],
       CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO],--
       CAST(NULL AS DECIMAL(18, 4)) AS [SALE_PRICE],--
       CAST(iil.[averagecostmli] AS DECIMAL(18, 4)) AS [COST_PRICE],
       CAST(NULL AS DECIMAL(18, 4)) AS [PURCHASE_PRICE],--
       CASE WHEN iil.[location_name] = 'Amazon FBA UK' THEN 1
			   WHEN iil.[location_name] = 'Bristol' THEN ISNULL(i.[custitem_hh_ot_qty], 1)
			   END AS [ORDER_MULTIPLE],
       CAST(NULL AS DECIMAL(18, 4)) AS [QTY_PALLET],--
       CAST(NULL AS DECIMAL(18, 4)) AS [VOLUME],--
       CAST(NULL AS DECIMAL(18, 4)) AS [WEIGHT],--
	   CAST(0 AS DECIMAL(18,4)) AS [REORDER_POINT],
       CAST(1 AS BIT) AS [INCLUDE_IN_AGR],
       CAST(0 AS BIT) AS [CLOSED]
	   , CAST(NULL AS BIT)   AS [SPECIAL_ORDER]
FROM [cus].[InventoryItemLocations] iil
LEFT JOIN [cus].[Item] i ON iil.item = i.id

