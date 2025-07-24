




-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Blanket Purchase order mapping from bc sql to adi format
--
-- 25.11.2024.BF    Created
-- ===============================================================================

    CREATE VIEW [cus].[v_BLANKET_PURCHASE_ORDER] AS
       SELECT
            CAST([Document No_] AS VARCHAR(128))									AS [PURCHASE_ORDER_NO],
            CAST([No_] + CASE WHEN ISNULL([Variant Code], '') = '' THEN '' 
							ELSE '-' + [Variant Code] 
							END AS NVARCHAR(255))									AS [ITEM_NO],
            CAST([Location Code] + '-' + [Company] AS NVARCHAR(255))				AS [LOCATION_NO],
            CAST([Expected Receipt Date] AS DATE)									AS [DELIVERY_DATE],
            SUM(CAST([Outstanding Qty_ (Base)] AS DECIMAL(18,4)))					AS [QUANTITY],
			Company
		FROM
			[cus].PurchaseLine
		WHERE
			[Document Type] IN (4) AND  [Expected Receipt Date] <> '0001-01-01 00:00:00.000'
			AND [Drop Shipment] = 0
		GROUP BY
			[Document No_], [No_], [Variant Code], CAST([Expected Receipt Date] AS DATE), [Location Code], Company


