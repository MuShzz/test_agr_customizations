
-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Open Sales Orders mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- 16.06.2025.DRG putting all open SO on today's date. 
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
        --CAST(sl.[ShipmentDate] AS DATE) AS DELIVERY_DATE
		CAST(GETDATE() AS DATE) AS DELIVERY_DATE -- 16.06.2025.DRG putting all open SO on today's date. 
    FROM
        [bc_rest].sales_line sl
		INNER JOIN bc_rest.sales_header sh ON sl.DocumentNo = sh.No AND sl.DocumentType = sh.DocumentType
    WHERE
        sl.[DocumentType] = 'Order'
        AND sl.[DropShipment] = 0
        --AND sh.Status = 'Open'

		-- added to make sure we don't add sales orders older than the sales orders days back setting to today's date. 
		AND sl.ShipmentDate > (SELECT CAST(DATEADD(DD, -CAST(settingValue AS INT), GETDATE()) AS DATE) 
                                    FROM core.setting 
                                    WHERE settingKey = 'order_logic_sales_orders_days_back')
									
    GROUP BY
        sl.[DocumentNo], sl.[No], sl.[VariantCode], ISNULL(sl.[LocationCode],sh.[LocationCode]), sl.[ShipmentDate], sh.SelltoCustomerNo
    HAVING SUM(CAST(sl.[OutstandingQtyBase] AS DECIMAL(18,4))) <> 0



