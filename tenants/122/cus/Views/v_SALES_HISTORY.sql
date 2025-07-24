
 CREATE VIEW [cus].[v_SALES_HISTORY] AS
	--WITH customer_sales_union AS (
	
	--	SELECT
	--		CAST(ItemCode AS NVARCHAR(255))									AS ITEM_NO,
	--		CAST(Warehouse AS NVARCHAR(255))									AS LOCATION_NO,
	--		CAST(DocDate AS DATE)												AS [DATE],
	--		CAST(-SUM(InQty) AS DECIMAL(18,4))								AS SALE,
	--		CONVERT(VARCHAR, CAST(DocDate AS DATE), 112)						AS [DATE_INT],
	--		CAST(CardCode AS NVARCHAR(255))									AS CUSTOMER_NO,  
	--		CAST(-SUM(InQty) AS DECIMAL(18,4))								AS QUANTITY,
	--		CAST(Ref1 AS NVARCHAR(255))										AS [REFERENCE_NO],
	--		CAST(0 AS BIT)														AS is_sales_order,
	--		CAST(0 AS BIT)														AS is_excluded
	--	FROM 
	--		[cus].OINM 
	
	--	WHERE
	--		CAST(CreateDate AS DATE) >= '2020-01-01'
	--		AND TransType IN (14,16) -- 14 - Credit & 16 - Returns
	--	GROUP BY 
	--		ItemCode, DocDate, Warehouse, TransType, ref1, cardCode
	--	HAVING 
	--		SUM(IIF(o.TransType IN (14,16), 1, 0)) > 0
		
	--	UNION

	--	SELECT
		
	--		CAST(ol.ItemCode AS NVARCHAR(255))										AS ITEM_NO,
	--		CAST(ol.WhsCode AS NVARCHAR(255))										AS LOCATION_NO,
	--		CAST(ol.DocDate AS DATE)												AS [DATE],
	--		CONVERT(VARCHAR, CAST(ol.DocDate AS DATE), 112)							AS [DATE_INT],
	--		CAST(o.CardCode AS NVARCHAR(255))										AS CUSTOMER_NO,
	--		SUM(CAST(ol.Quantity AS DECIMAL(18,4)))									AS SALE,
	--		SUM(CAST(ol.Quantity AS DECIMAL(18,4)))									AS QUANTITY,
	--		CAST(o.DocNum AS NVARCHAR(255))											AS [REFERENCE_NO],
	--		CAST(0 AS BIT)															AS is_sales_order,
	--		CAST(0 AS BIT)															AS is_excluded
	--	FROM
	--		[cus].RDR1 ol
	--		JOIN [cus].ORDR o ON o.DocEntry = ol.DocEntry
	--	WHERE
	--		o.CANCELED = 'N' 
	--		AND o.CardCode <> '440010'
	--	GROUP BY
	--		ol.ItemCode, ol.WhsCode, ol.DocDate,o.CardCode,o.DocNum
	--	HAVING 
	--		SUM(ol.Quantity) > 0
	--)
 --      SELECT
			
 --           CAST(CONCAT([DATE_INT], 100000000 + (ROW_NUMBER() OVER (PARTITION BY [DATE] ORDER BY [DATE]))) AS BIGINT) AS [TRANSACTION_ID],
 --           CAST([ITEM_NO] AS NVARCHAR(255)) AS [ITEM_NO],
 --           CAST([LOCATION_NO] AS NVARCHAR(255)) AS [LOCATION_NO],
 --           CAST([DATE] AS DATE) AS [DATE],
 --           CAST([SALE] AS DECIMAL(18, 4)) AS [SALE],
 --           CAST([CUSTOMER_NO] AS NVARCHAR(255)) AS [CUSTOMER_NO],
 --           CAST([REFERENCE_NO] AS NVARCHAR(255)) AS [REFERENCE_NO],
 --           CAST(0 AS BIT) AS [IS_EXCLUDED]
 --      FROM customer_sales_union
	--   --inner JOIN [cus].OINM oi N c.ITEM_NO = oi.ItemCode

	   WITH customer_sales_union AS (
		-- Credit & Returns
		SELECT
			CAST(o.ItemCode AS NVARCHAR(255))									AS PRODUCT_ITEM_NO,
			CAST(o.Warehouse AS NVARCHAR(255))									AS LOCATION_NO,
			CAST(o.DocDate AS DATE)												AS [DATE],
			CONVERT(VARCHAR, CAST(DocDate AS DATE), 112)						AS [DATE_INT],
			CAST(o.CardCode AS NVARCHAR(255))									AS CUSTOMER_NO,  
			CAST(-SUM(o.InQty) AS DECIMAL(18,4))								AS SALE,
			CAST(o.Ref1 AS NVARCHAR(255))										AS [REFERENCE_NO],
			CAST(0 AS BIT)														AS is_sales_order,
			CAST(0 AS BIT)														AS is_excluded
		FROM 
			[cus].OINM o
		INNER JOIN
			[cus].OCRD c ON c.CardCode = o.CardCode
		WHERE
			CAST(CreateDate AS DATE) >= '2020-01-01'
			AND o.TransType IN (14,16) -- 14 - Credit & 16 - Returns
		GROUP BY 
			o.ItemCode, o.DocDate, o.Warehouse, o.TransType, o.ref1, o.cardCode
		HAVING 
			SUM(IIF(o.TransType IN (14,16), 1, 0)) > 0
		
		UNION

		-- Sales Order
		SELECT
			CAST(ol.ItemCode AS NVARCHAR(255))										AS PRODUCT_ITEM_NO,
			CAST(ol.WhsCode AS NVARCHAR(255))										AS LOCATION_NO,
			CAST(ol.DocDate AS DATE)												AS [DATE],
			CONVERT(VARCHAR, CAST(ol.DocDate AS DATE), 112)							AS [DATE_INT],
			CAST(o.CardCode AS NVARCHAR(255))										AS CUSTOMER_NO,
			SUM(CAST(ol.Quantity AS DECIMAL(18,4)))									AS SALE,
			CAST(o.DocNum AS NVARCHAR(255))											AS [REFERENCE_NO],
			CAST(0 AS BIT)															AS is_sales_order,
			CAST(0 AS BIT)															AS is_excluded
		FROM
			[cus].RDR1 ol
			JOIN [cus].ORDR o ON o.DocEntry = ol.DocEntry
		WHERE
			o.CANCELED = 'N' 
			AND o.CardCode <> '440010'
		GROUP BY
			ol.ItemCode, ol.WhsCode, ol.DocDate,o.CardCode,o.DocNum
		HAVING 
			SUM(ol.Quantity) > 0
	)
	SELECT CAST(CONCAT(sh.[DATE_INT], 100000000 + (ROW_NUMBER() OVER (PARTITION BY [DATE] ORDER BY [DATE]))) AS BIGINT) AS TRANSACTION_ID,
		    CAST(sh.PRODUCT_ITEM_NO AS NVARCHAR(255)) AS ITEM_NO,
			CAST(sh.LOCATION_NO AS NVARCHAR(255)) AS LOCATION_NO,
			CAST(sh.[DATE] AS DATE) AS DATE,
			CAST(sh.CUSTOMER_NO AS NVARCHAR(255)) AS CUSTOMER_NO,
			CAST(sh.SALE AS DECIMAL(18,4)) AS SALE,
			CAST(sh.REFERENCE_NO AS NVARCHAR(255)) AS REFERENCE_NO,
			CAST(sh.is_excluded AS BIT) AS IS_EXCLUDED
	   FROM customer_sales_union sh


