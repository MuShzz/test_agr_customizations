

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: sales order line mapping from raw to adi, Netsuite
--
--  29.09.2024.TO   Altered
-- ===============================================================================


    CREATE VIEW [cus].[v_UNDELIVERED_TRANSFER_ORDER] AS
       SELECT
            CAST(tro.[tranid]+'-'+tro.[location_name] AS VARCHAR(128)) AS [TRANSFER_ORDER_NO],
            CAST(tro.[item_code] AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(tro.[transferlocation_name] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(MIN(CONVERT(DATE,ISNULL(tro.[expectedreceiptdate], GETDATE()), 103)) AS DATE) AS [DELIVERY_DATE],
            CAST(SUM(-tro.[quantity]-tro.quantityshiprecv) AS DECIMAL(18, 4)) AS [QUANTITY],
            CAST(tro.[location_name] AS NVARCHAR(255)) AS [ORDER_FROM_LOCATION_NO]
       FROM [cus].[TransferOrders]  tro
	   GROUP BY tro.[tranid],tro.[transferlocation_name],tro.[location_name],tro.[item_code]
	   HAVING CAST(SUM(-tro.[quantity]-tro.quantityshiprecv) AS DECIMAL(18,4)) <> 0


