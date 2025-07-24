
-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Customer mapping from COS
--
--  12.03.2023.HMH   Created
--	19.02.2025.GM	 Adding join with cos_cus.AGR_LOCATION to get location grouping based on ERP data.
-- ===============================================================================
CREATE VIEW [cos_cus].[v_STOCK_LEVEL]
AS

 --   SELECT
 --       CAST(ITEM_NO AS NVARCHAR(255))              AS ITEM_NO,
 --       CAST(LOCATION_NO AS NVARCHAR(255))          AS LOCATION_NO,
 --       CAST(DATEFROMPARTS(2100, 1, 1) AS DATE)     AS EXPIRE_DATE,
 --       CAST(SUM(STOCK_UNITS) AS DECIMAL(18,4))     AS STOCK_UNITS
 --   FROM [cos].[AGR_STOCK_LEVEL]
	--GROUP BY ITEM_NO, LOCATION_NO

	SELECT
		CAST(ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
		CAST(
			CASE
				WHEN loc.STOCK_LOCATION_NO = '0259'
				THEN '0259'
				ELSE
				s.LOCATION_NO
			END
		AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(DATEFROMPARTS(2100, 1, 1) AS DATE) AS EXPIRE_DATE,
		CAST(SUM(STOCK_UNITS) AS DECIMAL(18,4)) AS STOCK_UNITS
	FROM [cos].[AGR_STOCK_LEVEL] s
	INNER JOIN cos_cus.AGR_LOCATION loc ON loc.NO = s.LOCATION_NO
	GROUP BY
		CAST(ITEM_NO AS NVARCHAR(255)),
		CASE
			WHEN loc.STOCK_LOCATION_NO = '0259'
			THEN '0259'
			ELSE
			s.LOCATION_NO
		END


