


-- ===============================================================================
-- Author:      Paulo Marques
-- Description: Sales_line view
--
--  08.10.2024.TO   Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[sales_line]
AS

SELECT [DocumentType]
      ,[DocumentNo]
	  ,[LineNo]
      ,[Quantity]
	  ,[VariantCode]
	  ,[ItemReferenceNo]
	  ,[LocationCode]
	  ,[No]
	  ,[OutstandingQtyBase]
	  ,[PurchaseOrderNo]
      ,[PurchOrderLineNo]      
      ,[ShipmentDate]
      ,[DropShipment]
  FROM [bc_rest].[sales_line]

	UNION ALL

SELECT 'Order' AS [Document Type]
      ,[DocumentNo]+'_'+[TransferfromCode] AS [DocumentNo]
	  ,[LineNo]
      ,[Quantity]
	  ,[VariantCode]
	  ,'' AS [ItemReferenceNo]
	  ,[TransferfromCode] AS [LocationCode]
	  ,[ItemNo] AS [No]
	  ,[OutstandingQtyBase]
	  ,'' AS [PurchaseOrderNo]
      ,CAST(0 AS INT) AS [PurchOrderLineNo]      
      ,[ShipmentDate]
      ,CAST(0 AS BIT) AS [Drop Shipment]
  FROM [bc_rest].[transfer_line]

  UNION ALL

		SELECT ah.[DocumentType]
			  ,ah.[No]+'_AH'					AS [DocumentNo]
			  ,al.[AuxiliaryIndex2]				AS [LineNo]
			  ,SUM(al.[RemainingQuantityBase])	AS [Quantity]
			  ,''								AS [VariantCode]
			  ,''								AS [ItemReferenceNo]
			  ,ah.[LocationCode]				AS [LocationCode]
			  ,MIN(al.[No])						AS [No]
			  ,SUM(al.[RemainingQuantityBase])	AS [OutstandingQtyBase]
			  ,''								AS [PurchaseOrderNo]
			  ,CAST(0 AS INT)					AS [PurchOrderLineNo]      
			  ,MIN(al.[DueDate])						AS [ShipmentDate]
			  ,CAST(0 AS BIT)					AS [Drop Shipment]
	    FROM [bc_rest_cus].[assembly_header] ah
  INNER JOIN [bc_rest_cus].[assembly_line] al ON ah.[No] = al.[DocumentNo] AND ah.[DocumentType] = al.[AuxiliaryIndex1]
  WHERE ah.[DocumentType] = 'Order'
  GROUP BY ah.[DocumentType], ah.[No], al.[No], ah.[LocationCode], al.[AuxiliaryIndex2]


