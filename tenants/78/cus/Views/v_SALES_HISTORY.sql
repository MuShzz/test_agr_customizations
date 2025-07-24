

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Quick Books Desktop
--
--  23.09.2024.TO   Altered
-- ===============================================================================


CREATE VIEW [cus].[v_SALES_HISTORY] AS
	SELECT
		CAST(t.[TxnNumber]*10000+t.[SeqNo] AS BIGINT)		AS [TRANSACTION_ID],
		CAST(ii.[Name] AS NVARCHAR(255))					AS [ITEM_NO],
		CAST(ins.[Name] AS NVARCHAR(255))					AS [LOCATION_NO],
		CAST(t.[TxnDate] AS DATE)							AS [DATE],
		CAST(t.[Quantity] AS DECIMAL(18, 4))				AS [SALE],
		CAST(t.CustomerRefListID AS NVARCHAR(255))			AS [CUSTOMER_NO],
		CAST(t.[RefNumber] AS NVARCHAR(255))				AS [REFERENCE_NO],
		CAST(0 AS BIT)										AS [IS_EXCLUDED]
    FROM (
			SELECT il.[TxnNumber],
				   il.[InvoiceLineSeqNo] AS SeqNo,
				   il.[InvoiceLineItemRefListID] AS ItemRefListID,
				   il.[InvoiceLineItemRefFullName] AS ItemRefFullName,
				   il.[InvoiceLineInventorySiteRefListID] AS InventorySiteRefListID,
				   il.CustomerRefListID,
				   il.[RefNumber],
				   il.[TxnDate],
				   il.[InvoiceLineQuantity] AS [Quantity],
				   'Invoice' AS type
			FROM [cus].[InvoiceLine] il
				INNER JOIN [cus].[ItemInventory] ii
					ON ii.ListID = il.[InvoiceLineItemRefListID]
			WHERE il.[InvoiceLineQuantity] IS NOT NULL
			
			UNION ALL
			
			SELECT cml.[TxnNumber],
				   cml.[CreditMemoLineSeqNo],
				   cml.[CreditMemoLineItemRefListID],
				   cml.[CreditMemoLineItemRefFullName],
				   cml.[CreditMemoLineInventorySiteRefListID],
				   cml.CustomerRefListID,
				   cml.[RefNumber],
				   cml.[TxnDate],
				   -cml.[CreditMemoLineQuantity],
				   'CreditMemo' AS type
			FROM [cus].[CreditMemoLine] cml
				INNER JOIN [cus].[ItemInventory] ii
					ON ii.ListID = cml.[CreditMemoLineItemRefListID]
		) t
		INNER JOIN [cus].[ItemInventory] ii ON ii.ListID = t.[ItemRefListID]
		INNER JOIN cus.InventorySite ins ON ins.ListID = t.InventorySiteRefListID


