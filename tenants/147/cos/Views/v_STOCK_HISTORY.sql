

-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Customer mapping from COS
--
--  12.03.2023.HMH   Created
--	19.02.2025.GM	 Adding join with cos_cus.AGR_LOCATION to get location grouping based on ERP data.
-- ===============================================================================
CREATE VIEW [cos_cus].[v_STOCK_HISTORY]
AS


   --SELECT
   --     CAST(TRANSACTION_ID AS BIGINT)      AS [TRANSACTION_ID],
   --     CAST(ITEM_NO AS NVARCHAR(255))      AS [ITEM_NO],
   --     CAST(LOCATION_NO AS NVARCHAR(255))  AS [LOCATION_NO],
   --     CAST(DATE AS DATE)                  AS [DATE],
   --     CAST(STOCK_MOVE AS DECIMAL(18,4))   AS [STOCK_MOVE],
   --     CAST(STOCK_LEVEL AS DECIMAL(18,4))  AS [STOCK_LEVEL]
   -- FROM
   --     [cos].[AGR_STOCK_HISTORY]

	SELECT
		CAST(TRANSACTION_ID AS BIGINT)       AS [TRANSACTION_ID],
		CAST(ITEM_NO AS NVARCHAR(255))       AS [ITEM_NO],
		CAST(
			CASE
				WHEN loc.STOCK_LOCATION_NO = '0259'
				THEN '0259'
				ELSE
				s.LOCATION_NO
			END
		AS NVARCHAR(255))                    AS [LOCATION_NO],
		CAST([DATE] AS DATE)                AS [DATE],
		CAST(SUM(STOCK_MOVE) AS DECIMAL(18,4))  AS [STOCK_MOVE],
		CAST(SUM(STOCK_LEVEL) AS DECIMAL(18,4)) AS [STOCK_LEVEL]
	FROM [cos].[AGR_STOCK_HISTORY] s
	INNER JOIN cos_cus.AGR_LOCATION loc ON loc.NO = s.LOCATION_NO
	WHERE [DATE] <> '1900-01-01'
	--and ITEM_NO = 'TGM16000-239'
	GROUP BY
		CAST(TRANSACTION_ID AS BIGINT),
		CAST(ITEM_NO AS NVARCHAR(255)),
		CASE
				WHEN loc.STOCK_LOCATION_NO = '0259'
				THEN '0259'
				ELSE
				s.LOCATION_NO
			END,
		CAST([DATE] AS DATE);


