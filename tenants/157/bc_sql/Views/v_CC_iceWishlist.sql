




-- ===============================================================================
-- Author:			Grétar Magnússon
-- Description:		Custom columns 
--
-- 05.05.2025.GM	Created
-- ===============================================================================


CREATE VIEW [bc_sql_cus].[v_CC_iceWishlist]
AS

    SELECT
		CAST([Item No_] AS NVARCHAR(255)) AS ITEM_NO,
		CAST(IIF([Location Code] = 'VEFVERSLUN', 'BÍLDSHÖFÐI',[Location Code]) AS NVARCHAR(255)) AS LOCATION_NO, --VEFVERSLUN should map onto BÍLDSHÖFÐI
		CAST(SUM(Quantity) AS INT) AS iceWishlist
	FROM
		bc_sql_cus.ICEWishlist
	WHERE
		ISNULL([Date SMS sent],'1753-01-01 00:00:00.000') = '1753-01-01 00:00:00.000'
		AND CAST([Item No_] AS NVARCHAR(255)) <> ''
		AND [Location Code] NOT IN ('VÖRUHÚS')
	GROUP BY
		[Item No_], [Location Code]

	UNION ALL  --sum up wishlist on all locations onto the warehouse

	SELECT
		CAST([Item No_] AS NVARCHAR(255)) AS ITEM_NO,
		CAST('VÖRUHÚS' AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(SUM(Quantity) AS INT) AS iceWishlist
	FROM
		bc_sql_cus.ICEWishlist
	WHERE
		ISNULL([Date SMS sent],'1753-01-01 00:00:00.000') = '1753-01-01 00:00:00.000'
		AND CAST([Item No_] AS NVARCHAR(255)) <> ''
	GROUP BY
		[Item No_]


