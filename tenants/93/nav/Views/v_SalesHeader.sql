
-- ===============================================================================
-- Author:      Ágúst Örn Grétarsson
-- Description: Sales order mapping from erp 
--
-- 06.05.2024.RJ Created
-- ===============================================================================

CREATE VIEW [nav_cus].[v_SalesHeader]
AS

		WITH cte AS (
		SELECT 
			sales_no,
			c.item_no,
			c.location_no,
			CASE WHEN  c.reserved_date  < cast(getdate() AS DATE) THEN  CAST(GETDATE() AS DATE) ELSE c.reserved_date END  AS reserved_date,
			(c.units) AS units,
			CAST('' AS NVARCHAR(255)) AS description
		FROM [nav_cus].[v_SalesOrderLineExtraDetails] c 
		WHERE c.units > 0

		)
		SELECT 
			DISTINCT 
			1 AS [Document Type],
			CAST(sales_no AS NVARCHAR(128)) AS [No_],
			CAST(location_no AS NVARCHAR(255)) AS [Location Code],
			CAST('' AS NVARCHAR(255)) AS [Sell-to Customer No_],
			CAST(reserved_date AS DATE) AS [Requested Delivery Date],
			CAST(reserved_date AS DATE) AS [Promised Delivery Date],
			CAST(0 AS TINYINT) AS status
		FROM cte c


