



-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

    CREATE VIEW [cus].[v_UNDELIVERED_PURCHASE_ORDER] AS
       SELECT
            CAST([Document No_] AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
            CAST([No_] + CASE WHEN ISNULL([Variant Code], '') = '' THEN '' ELSE '-' + [Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO],
            CAST([Location Code] + '-' + [Company] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST([Expected Receipt Date] AS DATE) AS [DELIVERY_DATE],
            SUM(CAST([Outstanding Qty_ (Base)] AS DECIMAL(18,4))) AS [QUANTITY],
			Company
		FROM
			[cus].PurchaseLine
		WHERE
			[Document Type] IN (1) AND  [Expected Receipt Date] <> '0001-01-01 00:00:00.000'
			AND [Drop Shipment] = 0
		GROUP BY
			[Document No_], [No_], [Variant Code], CAST([Expected Receipt Date] AS DATE), [Location Code], Company


