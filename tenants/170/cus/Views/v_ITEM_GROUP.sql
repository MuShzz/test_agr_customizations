CREATE VIEW [cus].[v_ITEM_GROUP]
AS

    SELECT DISTINCT
        CAST([NO] AS NVARCHAR(255))                 AS [NO],
        CAST(ISNULL([NAME],'') AS NVARCHAR(255))    AS [NAME]
    FROM
       [cus].[ITEM_GROUP]

