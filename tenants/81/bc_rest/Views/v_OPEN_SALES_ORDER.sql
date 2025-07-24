

-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Open Sales Orders mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_OPEN_SALES_ORDER]
AS
 
	 --ERP_BC_REST
	SELECT CAST(sl.[DocumentNo] AS NVARCHAR(128)) AS SALES_ORDER_NO,
		   CAST(sl.[No] + CASE
							  WHEN ISNULL(sl.[VariantCode], '') = '' THEN
								  ''
							  ELSE
								  '-' + sl.[VariantCode]
						  END AS NVARCHAR(255)) AS [ITEM_NO],
		   CAST(CASE
					WHEN ISNULL(sl.[LocationCode], sh.[LocationCode]) = '' THEN
						'VARAHLUTIR'
					ELSE
						ISNULL(sl.[LocationCode], sh.[LocationCode])
				END AS NVARCHAR(255)) AS LOCATION_NO,
		   SUM(CAST(sl.[OutstandingQtyBase] AS DECIMAL(18, 4))) AS QUANTITY,
		   CAST(sh.SelltoCustomerNo AS NVARCHAR(255)) AS CUSTOMER_NO,
		   CAST(sl.[ShipmentDate] AS DATE) AS DELIVERY_DATE
	FROM [bc_rest].sales_line sl
		INNER JOIN bc_rest.sales_header sh
			ON sl.DocumentNo = sh.No
			   AND sl.DocumentType = sh.DocumentType
	WHERE sl.[DocumentType] = 'Order'
		  AND sl.[DropShipment] = 0
	--AND sh.Status = 'Open'
	GROUP BY sl.[DocumentNo],
			 sl.[No],
			 sl.[VariantCode],
			 ISNULL(sl.[LocationCode], sh.[LocationCode]),
			 sl.[ShipmentDate],
			 sh.SelltoCustomerNo
	HAVING SUM(CAST(sl.[OutstandingQtyBase] AS DECIMAL(18, 4))) <> 0;

