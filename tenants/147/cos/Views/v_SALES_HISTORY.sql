
-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Customer mapping from COS
--
--  12.03.2023.HMH   Created
--	19.02.2025.GM	 Adding join with cos_cus.AGR_LOCATION to get location grouping based on ERP data.
-- ===============================================================================
CREATE VIEW [cos_cus].[v_SALES_HISTORY]
AS

    --SELECT 
    --    CAST(TRANSACTION_ID AS BIGINT)                      AS [TRANSACTION_ID],
    --    CAST(ITEM_NO AS NVARCHAR(255))                      AS [ITEM_NO],
    --    CAST(LOCATION_NO AS NVARCHAR(255))                  AS [LOCATION_NO],
    --    CAST([DATE] AS DATE)                                AS [DATE],
    --    CAST(ISNULL(SALE, 0) AS DECIMAL(18,4))              AS [SALE],
    --    CAST(ISNULL(CUSTOMER_NO,'') AS NVARCHAR(255))       AS [CUSTOMER_NO],
    --    CAST(ISNULL(REFERENCE_NO,'') AS NVARCHAR(255))      AS [REFERENCE_NO],
    --    CAST(0 AS BIT)                                      AS [IS_EXCLUDED]
    --FROM
    --    [cos].[AGR_SALES_HISTORY]

	SELECT
		CAST(TRANSACTION_ID AS BIGINT)                         AS [TRANSACTION_ID],
		CAST(ITEM_NO        AS NVARCHAR(255))                  AS [ITEM_NO],
		CAST(
			CASE
				WHEN loc.STOCK_LOCATION_NO = '0259'
				THEN '0259'
				ELSE
				s.LOCATION_NO
			END
			AS NVARCHAR(255)
		) AS [LOCATION_NO],
		CAST([DATE] AS DATE)                                   AS [DATE],
		/* Summation for SALE */
		CAST(SUM(ISNULL(SALE, 0)) AS DECIMAL(18,4))            AS [SALE],

		/* Choose an aggregator for CUSTOMER_NO, e.g. MAX or MIN */
		CAST(MAX(ISNULL(CUSTOMER_NO, '')) AS NVARCHAR(255))    AS [CUSTOMER_NO],

		/* Same for REFERENCE_NO */
		CAST(MAX(ISNULL(REFERENCE_NO, '')) AS NVARCHAR(255))   AS [REFERENCE_NO],

		CAST(0 AS BIT)                                         AS [IS_EXCLUDED]
	FROM [cos].[AGR_SALES_HISTORY] s
	INNER JOIN cos_cus.AGR_LOCATION loc ON loc.NO = s.LOCATION_NO
	GROUP BY
		CAST(TRANSACTION_ID AS BIGINT),
		CAST(ITEM_NO        AS NVARCHAR(255)),
		/* Group by the same CASE expression used in SELECT */
		CASE
			WHEN loc.STOCK_LOCATION_NO = '0259'
			THEN '0259'
			ELSE
			s.LOCATION_NO
		END,
		CAST([DATE] AS DATE);


