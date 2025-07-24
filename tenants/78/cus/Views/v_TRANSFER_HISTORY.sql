

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Quick Books Desktop
--
--  23.09.2024.TO   Altered
-- ===============================================================================


CREATE VIEW [cus].[v_TRANSFER_HISTORY] AS
       
	SELECT 
		CAST(t.[TxnNumber]*10000+t.[TransferInventorySeqNo] AS BIGINT)			AS [TRANSACTION_ID],
		CAST(ii.[Name] AS NVARCHAR(255))										AS [ITEM_NO],
        CAST(ins.[Name] AS NVARCHAR(255))										AS [FROM_LOCATION_NO],
        CAST('' AS NVARCHAR(255))												AS [TO_LOCATION_NO],
        CAST(t.[TxnDate] AS DATE)												AS [DATE],
        CAST(t.[TransferInventoryLineQuantityTransferred] AS DECIMAL(18, 4))	AS [TRANSFER]
	FROM 
		[cus].[TransferInventoryLine] t
		INNER JOIN [cus].[ItemInventory] ii ON ii.ListID = t.[TransferInventoryLineItemRefListID]
		INNER JOIN cus.InventorySite ins ON ins.ListID = t.[FromInventorySiteListID]



