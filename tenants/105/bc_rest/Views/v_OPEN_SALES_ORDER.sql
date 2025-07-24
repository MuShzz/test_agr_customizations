







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
        CAST(sl.[DocumentNo] AS NVARCHAR(128))											AS SALES_ORDER_NO,
        CAST(sl.[No] + 
			CASE 
			WHEN ISNULL(sl.[VariantCode], '') = '' 
			THEN '' 
			ELSE '-' + sl.[VariantCode] END AS NVARCHAR(255))							AS [ITEM_NO],
        CAST(ISNULL(sl.[LocationCode],sh.[LocationCode]) AS NVARCHAR(255))				AS LOCATION_NO,
        SUM(CAST(sl.[OutstandingQtyBase] AS DECIMAL(18,4)))								AS QUANTITY,
		CAST(sh.SelltoCustomerNo AS NVARCHAR(255))										AS CUSTOMER_NO,

		-- Added for PS-15
        CAST(CASE WHEN ait.sku_item_type_code IN ('VOORRAAD A','VOORRAAD X','BESTEL')
			 THEN GETDATE()
			 ELSE sl.[ShipmentDate] END AS DATE)  										AS DELIVERY_DATE
    FROM
        [bc_rest].sales_line sl
		INNER JOIN bc_rest.sales_header sh ON sl.DocumentNo = sh.No AND sl.DocumentType = sh.DocumentType
		LEFT JOIN bc_rest_cus.AGR_ITEM ait ON sl.[No] = ait.[No_] AND (ISNULL(sl.[VariantCode], '') = '' OR sl.[VariantCode] = ait.SKU_Variant_Code AND ISNULL(sl.[LocationCode],sh.[LocationCode]) = ait.SKU_Location_Code)
    WHERE
        sl.[DocumentType] = 'Order'
        AND sl.[DropShipment] = 0
        --AND sh.Status = 'Open'

		-- added to make sure we don't add sales orders older than the sales orders days back setting to today's date. 
		AND sl.ShipmentDate > (SELECT CAST(DATEADD(DD, -CAST(settingValue AS INT), GETDATE()) AS DATE) 
                                    FROM core.setting 
                                    WHERE settingKey = 'order_logic_sales_orders_days_back')
    GROUP BY
        sl.[DocumentNo], sl.[No], sl.[VariantCode], ISNULL(sl.[LocationCode],sh.[LocationCode]), 
		CAST(CASE WHEN ait.sku_item_type_code IN ('VOORRAAD A','VOORRAAD X','BESTEL')
			 THEN GETDATE()
			 ELSE sl.[ShipmentDate] END AS DATE), sh.SelltoCustomerNo
    HAVING SUM(CAST(sl.[OutstandingQtyBase] AS DECIMAL(18,4))) <> 0

	UNION ALL

	SELECT
        CAST([AH_No]+'_AH' AS NVARCHAR(128))											AS SALES_ORDER_NO,
        CAST(al.[AL_Item_No] + 
			CASE WHEN ISNULL(al.[AL_Variant_Code], '') = '' THEN '' 
			ELSE '-' + al.[AL_Variant_Code] END AS NVARCHAR(255))						AS [ITEM_NO],
        CAST(ah.[AH_Location_Code] AS NVARCHAR(255))									AS LOCATION_NO,
        SUM(CAST(al.[AL_Remaining_Quantity_Base] AS DECIMAL(18,4)))						AS QUANTITY,
		CAST(NULL AS NVARCHAR(255))														AS CUSTOMER_NO,

		-- Added for PS-15
        CAST(CASE WHEN ait.sku_item_type_code IN ('VOORRAAD A','VOORRAAD X','BESTEL')
			 THEN GETDATE()
			 ELSE al.[AL_Due_Date] END AS DATE)  										AS DELIVERY_DATE
    FROM 
		[bc_rest_cus].[assembly_header] ah
		INNER JOIN [bc_rest_cus].[assembly_line] al ON ah.[AH_No] = al.[AL_Document_No]
		LEFT JOIN bc_rest_cus.AGR_ITEM ait ON al.[AL_Item_No] = ait.[No_] AND (ISNULL(al.[AL_Variant_Code], '') = '' OR al.AL_Variant_Code = ait.SKU_Variant_Code AND ah.AH_Location_Code = ait.SKU_Location_Code)
	WHERE ah.[AH_Document_Type] = 'Order'
		AND ah.[AH_Location_Code] = 'MAG01'
		AND  ah.[AH_Status] = 'Released'
		-- added to make sure we don't add sales orders older than the sales orders days back setting to today's date. 
		AND al.[AL_Due_Date] > (SELECT CAST(DATEADD(DD, -CAST(settingValue AS INT), GETDATE()) AS DATE) 
                                    FROM core.setting 
                                    WHERE settingKey = 'order_logic_sales_orders_days_back')
	GROUP BY 
		ah.[AH_Document_Type], al.[AL_Item_No], al.[AL_Variant_Code], ah.[AH_No], al.[AL_Line_No], ah.[AH_Location_Code], al.[AL_Document_Type], 
		CAST(CASE WHEN ait.sku_item_type_code IN ('VOORRAAD A','VOORRAAD X','BESTEL')
			 THEN GETDATE()
			 ELSE al.[AL_Due_Date] END AS DATE) 
    HAVING SUM(CAST(al.[AL_Remaining_Quantity_Base] AS DECIMAL(18,4))) <> 0



