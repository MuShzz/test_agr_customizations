


-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Open Sales Orders mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- 21.02.2025.BF	Adding open sales from other companies to main company ND-2
-- 04.03.2025.DRG	Item number not same in different companies. Used custom columns in cc_item_type for mapping the Nordenta item no on the sales orders. 
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_OPEN_SALES_ORDER]
AS
 
    SELECT
        CAST(CONCAT('DN - ',sl.[DocumentNo]) AS NVARCHAR(128)) AS SALES_ORDER_NO,
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
    GROUP BY
        sl.[DocumentNo], sl.[No], sl.[VariantCode], ISNULL(sl.[LocationCode],sh.[LocationCode]), sl.[ShipmentDate], sh.SelltoCustomerNo
    HAVING SUM(CAST(sl.[OutstandingQtyBase] AS DECIMAL(18,4))) <> 0

	-- Company LIC Scadenta | only from Location Code - '' | location Name - HOVEDLAGER

	UNION ALL
    
	SELECT
        CAST(CONCAT('SCA - ',sl.[DocumentNo])AS NVARCHAR(128)) AS SALES_ORDER_NO,
        --CAST(sl.[No] + CASE WHEN ISNULL(sl.[VariantCode], '') = '' THEN '' ELSE '-' + sl.[VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO_IN_LIC],
		CAST(cit.[ItemNo] AS NVARCHAR(255)) AS [ITEM_NO],
        CAST('01' AS NVARCHAR(255)) AS LOCATION_NO,
        SUM(CAST(sl.[OutstandingQtyBase] AS DECIMAL(18,4))) AS QUANTITY,
		CAST(sh.SelltoCustomerNo AS NVARCHAR(255)) AS CUSTOMER_NO,
        CAST(sl.[ShipmentDate] AS DATE) AS DELIVERY_DATE
	FROM  
		bc_rest_cus.cc_item_type cit 
        INNER JOIN bc_rest_cus.sales_line_scadenta sl ON sl.No = cit.ItemNoLIC AND cit.ItemNoLIC <> ''
		INNER JOIN bc_rest_cus.sales_header_scadenta sh ON sl.DocumentNo = sh.No AND sl.DocumentType = sh.DocumentType
    WHERE
        sl.[DocumentType] = 'Order'
        AND sl.[DropShipment] = 0
        AND ISNULL(sl.[LocationCode],sh.[LocationCode])=''
    GROUP BY
        sl.[DocumentNo], /*sl.[No], sl.[VariantCode],*/ ISNULL(sl.[LocationCode],sh.[LocationCode]), sl.[ShipmentDate], sh.SelltoCustomerNo, cit.[ItemNo]
    HAVING SUM(CAST(sl.[OutstandingQtyBase] AS DECIMAL(18,4))) <> 0

	-- Company 3D Dental | only from Location Code - 3D | location Name – 3D Dental Aps

	UNION ALL
    
	SELECT
        CAST(CONCAT('3D - ',sl.[DocumentNo]) AS NVARCHAR(128)) AS SALES_ORDER_NO,
        --CAST(sl.[No] + CASE WHEN ISNULL(sl.[VariantCode], '') = '' THEN '' ELSE '-' + sl.[VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO_IN_3D],
		CAST(cit.[ItemNo] AS NVARCHAR(255)) AS [ITEM_NO],
        CAST('01' AS NVARCHAR(255)) AS LOCATION_NO,
        SUM(CAST(sl.[OutstandingQtyBase] AS DECIMAL(18,4))) AS QUANTITY,
		CAST(sh.SelltoCustomerNo AS NVARCHAR(255)) AS CUSTOMER_NO,
        CAST(sl.[ShipmentDate] AS DATE) AS DELIVERY_DATE
    FROM
		bc_rest_cus.cc_item_type cit 
        INNER JOIN bc_rest_cus.sales_line_3d_dental sl ON sl.No = cit.ItemNo3D AND cit.ItemNo3D <> ''
		INNER JOIN bc_rest_cus.sales_header_3d_dental sh ON sl.DocumentNo = sh.No AND sl.DocumentType = sh.DocumentType
    WHERE
        sl.[DocumentType] = 'Order'
        AND sl.[DropShipment] = 0
        AND ISNULL(sl.[LocationCode],sh.[LocationCode])='3D'
    GROUP BY
        sl.[DocumentNo],/* sl.[No], sl.[VariantCode],*/ ISNULL(sl.[LocationCode],sh.[LocationCode]), sl.[ShipmentDate], sh.SelltoCustomerNo, cit.ItemNo
    HAVING SUM(CAST(sl.[OutstandingQtyBase] AS DECIMAL(18,4))) <> 0

	-- Company Zenith Dental | only from Location Code - ZENITH | location Name – 3D Dental Aps  

	UNION ALL
    
	SELECT
        CAST(CONCAT('ZEN - ',sl.[DocumentNo]) AS NVARCHAR(128)) AS SALES_ORDER_NO,
        --CAST(sl.[No] + CASE WHEN ISNULL(sl.[VariantCode], '') = '' THEN '' ELSE '-' + sl.[VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO_IN_ZEN],
		CAST(cit.ItemNo AS NVARCHAR(255)) AS [ITEM_NO],
        CAST('01' AS NVARCHAR(255)) AS LOCATION_NO,
        SUM(CAST(sl.[OutstandingQtyBase] AS DECIMAL(18,4))) AS QUANTITY,
		CAST(sh.SelltoCustomerNo AS NVARCHAR(255)) AS CUSTOMER_NO,
        CAST(sl.[ShipmentDate] AS DATE) AS DELIVERY_DATE
    FROM
		bc_rest_cus.cc_item_type cit
        INNER JOIN bc_rest_cus.sales_line_zenith sl ON sl.No = cit.ItemNoZD AND cit.ItemNoZD <> ''
		INNER JOIN bc_rest_cus.sales_header_zenith sh ON sl.DocumentNo = sh.No AND sl.DocumentType = sh.DocumentType
    WHERE
        sl.[DocumentType] = 'Order'
        AND sl.[DropShipment] = 0
        AND ISNULL(sl.[LocationCode],sh.[LocationCode])='ZENITH'
    GROUP BY
        sl.[DocumentNo], /*sl.[No], sl.[VariantCode],*/ ISNULL(sl.[LocationCode],sh.[LocationCode]), sl.[ShipmentDate], sh.SelltoCustomerNo, cit.ItemNo
    HAVING SUM(CAST(sl.[OutstandingQtyBase] AS DECIMAL(18,4))) <> 0


	-- Add open transfer orders for cars in in the SKU table.

	UNION ALL

	SELECT
    CAST([DocumentNo] + '_' + [TransferfromCode] AS NVARCHAR(128)) AS SALES_ORDER_NO,
    CAST([ItemNo] + CASE WHEN ISNULL([VariantCode], '') = '' THEN '' ELSE '-' + [VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO],
    CAST([TransferfromCode] AS NVARCHAR(255)) AS LOCATION_NO,
    CAST(SUM([OutstandingQtyBase]) AS DECIMAL(18,4)) AS QUANTITY,
	CAST([DocumentNo] + '_' + [TransferfromCode] AS NVARCHAR(255)) AS CUSTOMER_NO,
    CAST(IIF([ReceiptDate]='0001-01-01 00:00:00.000', GETDATE(),[ReceiptDate]) AS DATE) AS DELIVERY_DATE
	FROM
		[bc_rest].transfer_line tl
	WHERE
		[OutstandingQtyBase] > 0
		AND NOT EXISTS (
			SELECT 1
			FROM [bc_rest].stock_keeping_unit sku
			WHERE
				sku.ItemNo = tl.ItemNo
				AND ISNULL(sku.VariantCode, '') = ISNULL(tl.VariantCode, '')
				AND sku.LocationCode = tl.TransfertoCode
		)
	GROUP BY
		[DocumentNo], [TransferfromCode], [ItemNo], [VariantCode], [TransfertoCode],
		CAST(IIF([ReceiptDate]='0001-01-01 00:00:00.000', GETDATE(),[ReceiptDate]) AS DATE)
	HAVING
		SUM([OutstandingQtyBase]) > 0


