
-- ===============================================================================
-- Author:      Ástrós Eir Kristinsdóttir
-- Description: Purchase order mapping from NAV to adi format
--
-- 09.10.2024.TO    Created
-- ===============================================================================
CREATE   VIEW [nav_cus].[v_UNDELIVERED_PURCHASE_ORDER]
AS
 
    SELECT
        CAST([Document No_] AS NVARCHAR(128)) AS PURCHASE_ORDER_NO,
        CAST([No_] + CASE WHEN ISNULL([Variant Code], '') = '' THEN '' ELSE '-' + [Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO],
        CAST([Location Code] AS NVARCHAR(255)) AS LOCATION_NO,
        SUM(CAST([Outstanding Qty_ (Base)] AS DECIMAL(18,4))) AS QUANTITY,
        CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE) AS DELIVERY_DATE
    FROM
        [nav].PurchaseLine
    WHERE
        [Document Type] IN (1)
        AND [Drop Shipment] = 0
    GROUP BY
        [Document No_], [No_], [Variant Code], [Location Code], CAST(IIF([Expected Receipt Date]='1753-01-01 00:00:00.000', GETDATE(),[Expected Receipt Date]) AS DATE)
	HAVING SUM([Outstanding Qty_ (Base)]) > 0

	UNION 

	SELECT 
		CAST([Order No_] AS NVARCHAR(128)) AS PURCHASE_ORDER_NO,
		CAST([Item No_] AS NVARCHAR(255)) AS [ITEM_NO],
		CAST([Location Code] AS NVARCHAR(255)) AS LOCATION_NO,
		SUM(CAST([Qty_ to Receive] AS DECIMAL(18,4))) AS QUANTITY,
		CAST([Expected Receipt Date] AS DATE) AS DELIVERY_DATE
	FROM 
		[nav_cus].[Item Undelivered CDI View]
	WHERE 
		[Qty_ to Receive] <> 0
	GROUP BY 
		[Order No_], [Item No_], [Location Code], [Expected Receipt Date]



