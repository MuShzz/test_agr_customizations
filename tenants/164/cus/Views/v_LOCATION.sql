


    CREATE VIEW [cus].[v_LOCATION] AS
       SELECT
        CAST([Code] AS NVARCHAR(255)) AS [NO],
        CAST([Name] AS NVARCHAR(255)) AS [NAME],
        Company
    FROM
        [cus].location

