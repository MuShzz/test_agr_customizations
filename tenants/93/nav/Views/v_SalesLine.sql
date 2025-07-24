   -- ===============================================================================
-- Author:      Ágúst Örn Grétarsson
-- Description: Sales line mapping from erp 
--
-- 06.05.2014.RJ  Created
-- ===============================================================================

CREATE VIEW [nav_cus].[v_SalesLine]
AS

		with cte  as (
		select 
			sales_no,
			c.item_no,
			c.location_no,
			case when c.reserved_date  < cast(getdate() as date) then  cast(getdate() as date) else c.reserved_date end    AS reserved_date,
			(c.units) AS units,
			CAST('' AS NVARCHAR(255)) AS description
		 From [nav_cus].[v_SalesOrderLineExtraDetails] c 
		where c.units > 0 

		)

		select 
			distinct 
			1 AS [Document Type],
			CAST(sales_no AS NVARCHAR(128)) AS [Document No_],
			(ROW_NUMBER() OVER (PARTITION BY sales_no ORDER BY item_no))*10000 AS [Line No_],
			0 as [Type],
			CAST(item_no AS NVARCHAR(20)) AS [No_],
			CAST(location_no AS NVARCHAR(20)) AS [Location Code],
			CAST(SUM(units) AS DECIMAL(38,20)) AS [Quantity],
			CAST(SUM(units) AS DECIMAL(38,20)) AS [Outstanding Qty_ (Base)],
			CAST(reserved_date AS DATE) AS [Shipment Date],
			'' as [Variant Code],
			0 as [Drop Shipment]
			from cte
			group by sales_no, item_no, location_no, reserved_date




