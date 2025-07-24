




    CREATE VIEW [cus].[v_LOCATION] AS
       SELECT
            CAST(OWHS.[WhsCode] AS NVARCHAR(255)) AS [NO],
            CAST(OWHS.[WhsName] AS NVARCHAR(255)) AS [NAME]
	FROM cus.OWHS

