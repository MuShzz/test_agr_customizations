







-- ===============================================================================
-- Author:      HMH
-- Description: Sales order no generation for custom columns
--
--  2024-08-12: HMH Created
--	2025-02-20: BF removed the join of
-- ===============================================================================
CREATE VIEW [nav_cus].[v_custom_column_sales_order]
AS
	--SELECT 
	--	sub.[itemNo]
	--	,sub.[locationNo]
	--	,LEFT(sub.columnValue, 255) AS sales_order_no
	--FROM 
	--(
	--	SELECT DISTINCT 
	--		aei.[itemNo]
	--		,aei.[locationNo]
	--		,STRING_AGG(cust.[Document No_], ', ') AS columnValue
	--	FROM [dbo].[AGREssentials_items] aei
	--	INNER JOIN [nav].[SalesLine] cust 
	--		ON aei.[itemNo] = cust.[No_]
	--		AND aei.[locationNo] = cust.[Location Code]
	--	WHERE cust.[Document No_] IS NOT NULL AND cust.[Document No_] <> ''
	--	AND cust.Quantity > 0
	--	GROUP BY aei.[itemNo], aei.[locationNo]
	--) sub;

	SELECT 
		so.No_ AS [itemNo],
		so.[Location Code] AS [locationNo],
		LEFT(STRING_AGG(so.[Document No_], ', '), 255) AS sales_order_no
	FROM nav.SalesLine so
	WHERE so.[Document No_] IS NOT NULL AND so.[Document No_] <> ''
		AND so.Quantity > 0
	GROUP BY so.No_,so.[Location Code]


