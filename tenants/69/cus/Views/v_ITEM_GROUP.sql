CREATE VIEW [cus].v_ITEM_GROUP
AS
SELECT CAST(No AS nvarchar(255)) AS [NO],
       CAST(Name AS nvarchar(255)) AS [NAME]
FROM [cus].product_group
