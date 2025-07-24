

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Quick Books Desktop
--
--  23.09.2024.TO   Altered
-- ===============================================================================


    CREATE VIEW [cus].[v_STOCK_HISTORY] AS
       SELECT
            CAST(ts.[TxnNumber]*10000+ts.[ItemLineSeqNo] AS BIGINT) AS [TRANSACTION_ID],
            CAST(ts.ItemLineItemRefFullName AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(ins.[Name] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(ts.[TxnDate] AS DATE) AS [DATE],
            CAST([ItemLineQuantity] AS DECIMAL(18, 4)) AS [STOCK_MOVE],
            CAST(NULL AS DECIMAL(18, 4)) AS [STOCK_LEVEL]
      FROM [cus].[v_transactions_combined] ts
	  INNER JOIN [cus].[InventorySite] ins ON ts.ItemLineInventorySiteRefListID = ins.ListID
	  INNER JOIN [cus].[ItemInventory] ii ON ii.ListID = ts.[ItemLineItemRefListID]
	  WHERE ins.IsActive = 1  
	  

