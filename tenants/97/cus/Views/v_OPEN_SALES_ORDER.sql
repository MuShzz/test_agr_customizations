


-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================
 

    CREATE VIEW [cus].[v_OPEN_SALES_ORDER] AS
       SELECT
            CAST([Document No_] AS NVARCHAR(128)) AS [SALES_ORDER_NO],
            CAST(sl.[No_] + CASE WHEN ISNULL([Variant Code], '') = '' THEN '' ELSE '-' + [Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(sl.[Location Code] + '-' + sl.[Company] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(SUM([Outstanding Qty_ (Base)]) AS DECIMAL(18, 4)) AS [QUANTITY],
            CAST(sh.[Sell-to Customer No_] AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST([Shipment Date] AS DATE) AS [DELIVERY_DATE],
			sl.[Company]
        FROM
			[cus].SalesLine sl
			INNER JOIN cus.SalesHeader sh ON  sl.[Document No_] = sh.No_
		WHERE
			sl.[Document Type] = 1
			AND [Drop Shipment] = 0
		GROUP BY
		 [Document No_], sl.[No_], [Variant Code], sl.[Location Code], [Shipment Date], sl.[Company], sh.[Sell-to Customer No_]


