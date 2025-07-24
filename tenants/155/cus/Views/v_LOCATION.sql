CREATE VIEW [cus].[v_LOCATION] AS
       SELECT
        CAST([NO] AS NVARCHAR(255))     AS [NO],
        CAST([NAME] AS NVARCHAR(255))   AS [NAME]
    FROM
        [cus].[AGR_LOCATION]
