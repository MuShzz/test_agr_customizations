

   CREATE VIEW [cus].[v_ITEM_GROUP] 
	AS
	   WITH ITEM_GROUP AS (
   
			SELECT DISTINCT
				CAST(pd.[Category.Code] AS NVARCHAR(255)) AS [NO],
				CAST(pd.[Category.Description] AS NVARCHAR(255)) AS [NAME]
			FROM cus.ProductDetails pd

			UNION 

			SELECT DISTINCT
				CAST('D' + pd.[Department.Code] AS NVARCHAR(255)) AS [NO],
				CAST(pd.[Department.Description] AS NVARCHAR(255)) AS [NAME]
			FROM cus.ProductDetails pd)

	   SELECT NO,NAME FROM ITEM_GROUP WHERE NO IS NOT NULL

