

CREATE VIEW [cus].[v_ITEM_GROUP] AS
   SELECT
        CAST([Code] AS NVARCHAR(255))			AS [NO],
        CAST([Description] AS NVARCHAR(255))	AS [NAME],
        Company
    FROM
        [cus].item_category

