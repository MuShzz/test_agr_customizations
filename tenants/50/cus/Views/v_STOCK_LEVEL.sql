



-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Netsuite
--
--  29.09.2024.TO   Altered
-- ===============================================================================


    CREATE VIEW [cus].[v_STOCK_LEVEL] AS
       SELECT
            CAST(iil.[item_code] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(iil.location_name AS NVARCHAR(255)) AS [LOCATION_NO],
			CAST(DATEFROMPARTS(2100, 1, 1) AS DATE)     AS EXPIRE_DATE,
            CAST(CAST(ISNULL(iil.[quantityonhand],0)  AS DECIMAL(18, 4)) / ISNULL(CAST(uom.conversionrate AS DECIMAL(18,4)),1) AS DECIMAL(18, 4)) AS [STOCK_UNITS]
       FROM [cus].[InventoryItemLocations] iil
	   INNER JOIN [cus].[Item] i ON iil.[item_code] = i.itemid
	   LEFT JOIN [cus].[Unitstypeuom] uom ON i.purchaseunit_id = uom.internalid
	   WHERE iil.item_code <> 'Was SMIDC08'


