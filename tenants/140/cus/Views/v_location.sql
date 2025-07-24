CREATE VIEW [cus].[v_location]
  AS
  SELECT
            CAST([LOCNCODE] AS NVARCHAR(255)) AS [NO],
            CAST([LOCNDSCR] AS NVARCHAR(255)) AS [NAME],
            [Company]
        FROM
            [cus].[IV40700]

