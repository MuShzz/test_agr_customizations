





-- ===============================================================================
-- Author:      Paulo Marques
-- Description: Sales_header view
--
--  08.10.2024.TO   Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[sales_header]
AS

SELECT [DocumentType]
      ,[No]
	  ,[LocationCode]
	  ,[SelltoCustomerNo]
	  ,[RequestedDeliveryDate]
	  ,[PromisedDeliveryDate]
	  ,[Status]
  FROM [bc_rest].[sales_header]

	UNION ALL

SELECT 'Order' AS [Document Type]
      ,[DocumentNo]+'_'+[TransferfromCode] AS [No]
	  ,[TransferfromCode] AS [LocationCode]
	  ,'30938' AS [SelltoCustomerNo]
	  , MIN(CAST([ReceiptDate] AS DATE)) AS [RequestedDeliveryDate]
	  ,'0001-01-01 00:00:00' AS [PromisedDeliveryDate]
	  ,[Status]
  FROM [bc_rest].[transfer_line]
  GROUP BY [DocumentNo], [TransferfromCode], [Status]

  UNION ALL 

	   SELECT ah.[DocumentType]
			  ,ah.[No]+'_AH' AS [No]
			  ,'SKOPPUM' AS [LocationCode]
			  ,'30938' AS [SelltoCustomerNo]
			  , MIN(CAST(al.[DueDate] AS DATE)) AS [RequestedDeliveryDate]
			  ,'0001-01-01 00:00:00' AS [PromisedDeliveryDate]
			  ,ah.[Status]
	  FROM [bc_rest_cus].[assembly_header] ah
INNER JOIN [bc_rest_cus].[assembly_line] al ON ah.[No] = al.[DocumentNo]
	 WHERE ah.[DocumentType] = 'Order'
	 GROUP BY ah.[No], ah.[Status], ah.[DocumentType]

	 

