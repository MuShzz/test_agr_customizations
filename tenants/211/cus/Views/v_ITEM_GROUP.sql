CREATE VIEW [cus].v_ITEM_GROUP
 AS
 SELECT
     CAST(categoryId AS nvarchar(255)) AS [NO],
     CAST(name AS nvarchar(255)) AS [NAME]
FROM cus.Categories
