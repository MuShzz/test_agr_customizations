CREATE VIEW [cUs].[v_VENDOR]
AS

    SELECT
        CAST([NO] AS NVARCHAR(255))                 AS [NO],
        CAST([NAME] AS NVARCHAR(255))               AS [NAME],
        CAST(ISNULL(LEAD_TIME_DAYS,0) AS SMALLINT)  AS [LEAD_TIME_DAYS],
        CAST(CLOSED AS BIT)                         AS [CLOSED]
    FROM
        [cUs].[VENDOR]
