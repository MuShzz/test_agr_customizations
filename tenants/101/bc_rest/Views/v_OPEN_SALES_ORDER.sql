-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Open Sales Orders mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_OPEN_SALES_ORDER]
AS
 
	 --ERP_BC_REST
    SELECT
        CAST(sl.[DocumentNo] AS NVARCHAR(128)) AS SALES_ORDER_NO,
        CAST(sl.[No] + CASE WHEN ISNULL(sl.[VariantCode], '') = '' THEN '' ELSE '-' + sl.[VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(ISNULL(sl.[LocationCode],sh.[LocationCode]) AS NVARCHAR(255)) AS LOCATION_NO,
        SUM(CAST(sl.[OutstandingQtyBase] AS DECIMAL(18,4))) AS QUANTITY,
		CAST(sh.SelltoCustomerNo AS NVARCHAR(255)) AS CUSTOMER_NO,
        CAST(sl.[ShipmentDate] AS DATE) AS DELIVERY_DATE
    FROM
        [bc_rest].sales_line sl
		INNER JOIN bc_rest.sales_header sh ON sl.DocumentNo = sh.No AND sl.DocumentType = sh.DocumentType
    WHERE
        sl.[DocumentType] = 'Order'
        AND sl.[DropShipment] = 0
        --AND sh.Status = 'Open'
    GROUP BY
        sl.[DocumentNo], sl.[No], sl.[VariantCode], ISNULL(sl.[LocationCode],sh.[LocationCode]), sl.[ShipmentDate], sh.SelltoCustomerNo
    having SUM(CAST(sl.[OutstandingQtyBase] AS DECIMAL(18,4))) <> 0

	UNION 

	
      SELECT
        CAST([DocumentNo]+'_'+[TransferfromCode] AS NVARCHAR(128))	AS SALES_ORDER_NO,
        CAST([ItemNo] AS NVARCHAR(255))								AS [ITEM_NO],
        CAST([TransferfromCode] AS NVARCHAR(255))					AS LOCATION_NO,
        SUM(CAST([OutstandingQtyBase] AS DECIMAL(18,4)))			AS QUANTITY,
		CAST('30938' AS NVARCHAR(255))								AS CUSTOMER_NO,
        CAST([ShipmentDate] AS DATE) AS DELIVERY_DATE
    FROM
        [bc_rest].[transfer_line] tl
    GROUP BY
        [DocumentNo]+'_'+[TransferfromCode], [ItemNo], [TransferfromCode], [ShipmentDate]
    having SUM(CAST([OutstandingQtyBase] AS DECIMAL(18,4))) <> 0

	UNION

    SELECT
			CAST(ah.[No]+'_AH' AS NVARCHAR(128))						AS SALES_ORDER_NO,
			CAST(al.[No] AS NVARCHAR(255))								AS [ITEM_NO],
			CAST('SKOPPUM' AS NVARCHAR(255))							AS LOCATION_NO,
			SUM(CAST(al.[RemainingQuantityBase] AS DECIMAL(18,4)))		AS QUANTITY,
			CAST('30938' AS NVARCHAR(255))								AS CUSTOMER_NO,
			CAST(al.[DueDate] AS DATE)									AS DELIVERY_DATE
		  FROM [bc_rest_cus].[assembly_header] ah
	INNER JOIN [bc_rest_cus].[assembly_line] al ON ah.[No] = al.[DocumentNo] AND ah.[DocumentType] = al.[AuxiliaryIndex1]
		 WHERE ah.[DocumentType] = 'Order'
    GROUP BY
        ah.[No]+'_AH', al.[No], al.[DueDate] 
    having SUM(CAST(al.[RemainingQuantityBase] AS DECIMAL(18,4))) <> 0

