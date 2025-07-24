CREATE VIEW [cus].[v_transactions_combined]
AS

	SELECT bil.[TxnNumber],
		   bil.[ItemLineSeqNo],
		   bil.[ItemLineItemRefListID],
		   bil.[ItemLineItemRefFullName],
		   bil.[ItemLineInventorySiteRefListID],
		   bil.[TxnDate],
		   bil.[ItemLineQuantity],
		   'Bill' AS type
	FROM [cus].[BillItemLine] bil
		INNER JOIN [cus].[ItemInventory] ii
			ON ii.ListID = bil.[ItemLineItemRefListID]
	UNION ALL
	SELECT il.[TxnNumber],
		   il.[InvoiceLineSeqNo],
		   il.[InvoiceLineItemRefListID],
		   il.[InvoiceLineItemRefFullName],
		   il.[InvoiceLineInventorySiteRefListID],
		   il.[TxnDate],
		   -il.[InvoiceLineQuantity] AS [InvoiceLineQuantity],
		   'Invoice' AS TYPE
	FROM [cus].[InvoiceLine] il
		INNER JOIN [cus].[ItemInventory] ii
			ON ii.ListID = il.[InvoiceLineItemRefListID]
	WHERE il.[InvoiceLineQuantity] IS NOT NULL
	UNION ALL
	SELECT cil.[TxnNumber],
		   cil.[ItemLineSeqNo],
		   cil.[ItemLineItemRefListID],
		   cil.[ItemLineItemRefFullName],
		   cil.[ItemLineInventorySiteRefListID],
		   cil.[TxnDate],
		   cil.[ItemLineQuantity],
		   'Check' AS type
	FROM [cus].[CheckItemLine] cil
		INNER JOIN [cus].[ItemInventory] ii
			ON ii.ListID = cil.[ItemLineItemRefListID]
	UNION ALL
	SELECT ial.[TxnNumber],
		   ial.[InventoryAdjustmentSeqNo],
		   ial.[InventoryAdjustmentLineItemRefListID],
		   ial.[InventoryAdjustmentLineItemRefFullName],
		   ial.[InventorySiteRefListID],
		   ial.[TxnDate],
		   ial.[InventoryAdjustmentLineQuantityDifference],
		   'InventoryAdjustment' AS type
	FROM [cus].[InventoryAdjustmentLine] ial
		INNER JOIN [cus].[ItemInventory] ii
			ON ii.ListID = ial.[InventoryAdjustmentLineItemRefListID]
	WHERE ial.[InventoryAdjustmentLineQuantityDifference] <> 0
	UNION ALL
	SELECT iril.[TxnNumber],
		   iril.[ItemLineSeqNo],
		   iril.[ItemLineItemRefListID],
		   iril.[ItemLineItemRefFullName],
		   iril.[ItemLineInventorySiteRefListID],
		   iril.[TxnDate],
		   iril.[ItemLineQuantity],
		   'ItemReceipt' AS type
	FROM [cus].[ItemReceiptItemLine] iril
		INNER JOIN [cus].[ItemInventory] ii
			ON ii.ListID = iril.[ItemLineItemRefListID]
			LEFT JOIN [cus].[BillItemLine] b ON iril.[TxnNumber] = b.[TxnNumber] AND iril.ItemLineSeqNo = b.[ItemLineSeqNo]
	WHERE b.TxnID IS NULL
	UNION ALL
	SELECT [TxnNumber],
		   [TransferInventorySeqNo]*1000 AS [TransferInventorySeqNo],
		   [TransferInventoryLineItemRefListID],
		   [TransferInventoryLineItemRefFullName],
		   [ToInventorySiteListID],
		   [TxnDate],
		   [TransferInventoryLineQuantityTransferred],
		   'Transfer' AS type
	FROM [cus].[TransferInventoryLine]
	UNION ALL
	SELECT [TxnNumber],
		   [TransferInventorySeqNo],
		   [TransferInventoryLineItemRefListID],
		   [TransferInventoryLineItemRefFullName],
		   [FromInventorySiteListID],
		   [TxnDate],
		   -[TransferInventoryLineQuantityTransferred],
		   'Transfer' AS type
	FROM [cus].[TransferInventoryLine]
	UNION ALL
	SELECT cml.[TxnNumber],
		   cml.[CreditMemoLineSeqNo],
		   cml.[CreditMemoLineItemRefListID],
		   cml.[CreditMemoLineItemRefFullName],
		   cml.[CreditMemoLineInventorySiteRefListID],
		   cml.[TxnDate],
		   cml.[CreditMemoLineQuantity],
		   'CreditMemo' AS type
	FROM [cus].[CreditMemoLine] cml
		INNER JOIN [cus].[ItemInventory] ii
			ON ii.ListID = cml.[CreditMemoLineItemRefListID]
	UNION ALL
	SELECT bacil.[TxnNumber],
		   bacil.[ComponentItemLineSeqNo],
		   bacil.[ComponentItemLineItemRefListID],
		   bacil.[ComponentItemLineItemRefFullName],
		   bacil.[ComponentItemLineInventorySiteRefListID],
		   bacil.[TxnDate],
		   -bacil.[ComponentItemLineQuantityNeeded],
		   'BuildAssembly' AS type
	FROM [cus].[BuildAssemblyComponentItemLine] bacil
		INNER JOIN [cus].[ItemInventory] ii
			ON ii.ListID = bacil.[ComponentItemLineItemRefListID]
	UNION ALL
	SELECT vcil.[TxnNumber],
		   vcil.[ItemLineSeqNo],
		   vcil.[ItemLineItemRefListID],
		   vcil.[ItemLineItemRefFullName],
		   vcil.[ItemLineInventorySiteRefListID],
		   vcil.[TxnDate],
		   -vcil.[ItemLineQuantity],
		   'VendorCredit' AS type
	FROM [cus].[VendorCreditItemLine] vcil
		INNER JOIN [cus].[ItemInventory] ii
			ON ii.ListID = vcil.[ItemLineItemRefListID];




