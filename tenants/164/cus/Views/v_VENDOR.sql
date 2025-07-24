


    CREATE VIEW [cus].[v_VENDOR] AS
       SELECT
		CAST(v.No AS NVARCHAR(255)) AS [NO],
		CAST(ISNULL(NULLIF(v.[Name],''), v.No + ' (name missing)') AS NVARCHAR(255)) AS [NAME],
		CAST(ISNULL([bc_rest].[LeadTimeConvert](v.[LeadTimeCalculation],GETDATE()), 1) AS SMALLINT) AS [LEAD_TIME_DAYS],
		CAST(IIF(v.[Blocked] = '',0,1) AS BIT) AS [CLOSED],
		v.Company
	FROM
		cus.Vendor v

