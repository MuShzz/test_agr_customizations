-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Open Sales Orders mapping from nav to adi format
--
-- 09.10.2024.TO    Created
-- 12.05.2025.BF	Adding reserved orders to the standard open sales orders view
-- ===============================================================================
CREATE VIEW [nav_cus].[v_OPEN_SALES_ORDER]
AS
 
     --ERP_nav
    SELECT
        CAST(sl.[Document No_] AS NVARCHAR(128)) AS SALES_ORDER_NO,
        CAST(sl.[No_] + CASE WHEN ISNULL(sl.[Variant Code], '') = '' THEN '' ELSE '-' + sl.[Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(ISNULL(sl.[Location Code],sh.[Location Code]) AS NVARCHAR(255)) AS LOCATION_NO,
        SUM(CAST(sl.[Outstanding Qty_ (Base)] AS DECIMAL(18,4))) AS QUANTITY,
        CAST(sh.[Sell-to Customer No_] AS NVARCHAR(255)) AS CUSTOMER_NO,
        CAST(sl.[Shipment Date] AS DATE) AS DELIVERY_DATE
    FROM
        [nav].SalesLine sl
        INNER JOIN nav.SalesHeader sh ON sl.[Document No_] = sh.[No_] AND sl.[Document Type] = sh.[Document Type]
    WHERE
        sh.[Document Type] = 1
        AND sl.[Drop Shipment] = 0
        --AND sh.[Status] = 0
    GROUP BY
        sl.[Document No_], sl.[No_], sl.[Variant Code], ISNULL(sl.[Location Code],sh.[Location Code]), sl.[Shipment Date], sh.[Sell-to Customer No_]
    having SUM(CAST(sl.[Outstanding Qty_ (Base)] AS DECIMAL(18,4))) <> 0

	UNION ALL

	--Plus cusotmisation brought over
	-- Reserved orders added as open sales orders
	SELECT
        CAST(psol.[Order No_] AS NVARCHAR(128)) AS SALES_ORDER_NO,
        CAST(psol.[Item No_] + CASE WHEN ISNULL(psol.[Variant Code], '') = '' THEN '' ELSE '-' + psol.[Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO],
        CAST('INN' AS NVARCHAR(255)) AS LOCATION_NO,
        SUM((CAST(psol.Quantity AS DECIMAL(18,4))+CAST(iei.[Reserved Inventory] AS DECIMAL(18,4)))) AS QUANTITY,
        CAST('' AS NVARCHAR(255)) AS CUSTOMER_NO,
        CAST(GETDATE() AS DATE) AS DELIVERY_DATE
    FROM
        nav_cus.PendingSalesOrderLine psol
		INNER JOIN nav_cus.ItemExtraInfo iei ON iei.No_=psol.[Item No_]
		LEFT JOIN [nav].ItemVariant iv ON iv.[Item No_] = iei.No_ AND psol.[Variant Code]=iv.Code
    WHERE
        psol.Released=0
    GROUP BY
        psol.[Item No_], psol.[Variant Code],psol.[Order No_]
    having SUM(CAST(psol.Quantity AS DECIMAL(18,4))) <> 0



