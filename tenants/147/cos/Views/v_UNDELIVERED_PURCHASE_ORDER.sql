

-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Customer mapping from COS
--
--  12.03.2023.HMH   Created
--	19.02.2025.GM	 Adding join with cos_cus.AGR_LOCATION to get location grouping based on ERP data.
--  19.03.20025.GM	 Added in case when location is empty then set on 0259
-- ===============================================================================
CREATE VIEW [cos_cus].[v_UNDELIVERED_PURCHASE_ORDER]
AS
	 --SELECT
		--CAST(PURCHASE_ORDER_NO AS NVARCHAR(128))              AS [PURCHASE_ORDER_NO],
		--CAST(ITEM_NO AS NVARCHAR(255))                        AS [ITEM_NO],
		--CAST(LOCATION_NO AS NVARCHAR(255))                    AS [LOCATION_NO],
		--MIN(CAST(ISNULL(DELIVERY_DATE, GETDATE()) AS DATE))   AS [DELIVERY_DATE],
		--CAST(SUM(QUANTITY) AS DECIMAL(18,4))                  AS [QUANTITY]
	 -- FROM [cos].[AGR_UNDELIVERED_PURCHASE_ORDERS]
		--GROUP BY 
		--PURCHASE_ORDER_NO, ITEM_NO, LOCATION_NO, DELIVERY_DATE

	SELECT
		CAST(s.PURCHASE_ORDER_NO AS NVARCHAR(128))				AS [PURCHASE_ORDER_NO],
		CAST(s.ITEM_NO AS NVARCHAR(255))						AS [ITEM_NO],
		CAST(
			CASE
				WHEN loc.STOCK_LOCATION_NO = '0259'
				THEN '0259'
				WHEN s.LOCATION_NO = ''
				THEN '0259'
				ELSE
				s.LOCATION_NO
			END
		AS NVARCHAR(255))										AS [LOCATION_NO],
		MIN(CAST(ISNULL(s.DELIVERY_DATE, GETDATE()) AS DATE))	AS [DELIVERY_DATE],
		CAST(SUM(s.QUANTITY) AS DECIMAL(18,4))					AS [QUANTITY]
	FROM
		[cos].[AGR_UNDELIVERED_PURCHASE_ORDERS] s
		INNER JOIN cos_cus.AGR_LOCATION loc ON loc.NO = s.LOCATION_NO
	--WHERE
	--	CAST(s.PURCHASE_ORDER_NO AS NVARCHAR(128)) = '32021'
	GROUP BY
		CAST(s.PURCHASE_ORDER_NO AS NVARCHAR(128)),
		CAST(s.ITEM_NO AS NVARCHAR(255)),
		CASE
			WHEN loc.STOCK_LOCATION_NO = '0259'
			THEN '0259'
			WHEN s.LOCATION_NO = ''
			THEN '0259'
			ELSE
			s.LOCATION_NO
		END;


