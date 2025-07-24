
 CREATE VIEW [cus].[v_LOCATION] AS
       SELECT
            CAST(Code AS NVARCHAR(255)) AS [NO],
            CAST(IIF(Description IS NULL,Code,Description) AS NVARCHAR(255)) AS [NAME]
      FROM	 cus.Branch

