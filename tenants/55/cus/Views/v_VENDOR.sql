


    CREATE VIEW [cus].[v_VENDOR] AS
       SELECT
            CAST(A.SupNo AS NVARCHAR(255)) AS [NO],
            CAST(ISNULL(NULLIF(A.Nm,''), CAST(A.SupNo AS NVARCHAR(30))  + ' (name missing)') AS NVARCHAR(255)) AS [NAME],
            CAST(0 AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST(0 AS BIT) AS [CLOSED]
       FROM 
        [cus].[Actor] A 
		WHERE A.SupNo > 0 AND A.SupNo IN (SELECT DISTINCT GR5 FROM cus.Prod)

