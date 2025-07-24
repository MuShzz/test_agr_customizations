CREATE VIEW [cus].[v_ITEM_GROUP] AS
   SELECT
        CAST(CategoryName AS NVARCHAR(255)) AS [NO],
        CAST(CategoryName AS NVARCHAR(255)) AS [NAME]
   FROM cus.ProductCategories
