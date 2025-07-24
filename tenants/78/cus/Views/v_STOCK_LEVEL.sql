


-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Quick Books Desktop
--
--  23.09.2024.TO   Altered
-- ===============================================================================


    CREATE VIEW [cus].[v_STOCK_LEVEL] AS
       SELECT
            CAST(ts.ItemLineItemRefFullName AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(ins.[Name] AS NVARCHAR(255)) AS [LOCATION_NO],
			CAST(DATEFROMPARTS(2100, 1, 1) AS DATE)     AS EXPIRE_DATE,
            CAST(SUM(ts.[ItemLineQuantity]) AS DECIMAL(18, 4)) AS [STOCK_UNITS]
      FROM [cus].[v_transactions_combined] ts
	  INNER JOIN [cus].[InventorySite] ins ON ts.ItemLineInventorySiteRefListID = ins.ListID
	  INNER JOIN [cus].[ItemInventory] ii ON ii.ListID = ts.[ItemLineItemRefListID]
	  WHERE ins.IsActive = 1
	  GROUP BY ts.ItemLineItemRefFullName,ins.[Name]


