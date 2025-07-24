


-- ===============================================================================
-- Author:      José Sucena
-- Description: VENDOR Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ====================================================================================================

CREATE VIEW [cus].[v_VENDOR] 
AS

    SELECT DISTINCT
			v.[No] AS [NO],
			ISNULL(NULLIF(v.[Name],''), v.[No]  + ' (name missing)') AS [NAME],
			ISNULL([bc_rest].[LeadTimeConvert](v.[LeadTimeCalculation],GETDATE()), 1) AS LEAD_TIME_DAYS,
			CAST(IIF(v.[Blocked] = '',0,1) AS BIT) AS CLOSED,
            v.Company
		FROM
			[cus].vendor v

	--Vendor missing   
	UNION ALL

	SELECT
		CAST(N'vendor_missing' AS NVARCHAR(255)) AS [NO],
		CAST(N'Vendor missing' AS NVARCHAR(255)) AS [NAME],
		CAST(0 AS SMALLINT) AS [LEAD_TIME_DAYS],
		CAST(0 AS BIT) AS [CLOSED],
        CAST(NULL AS CHAR(3)) AS COMPANY

	--Vendor closed
	UNION ALL

	SELECT
		CAST(N'vendor_closed' AS NVARCHAR(255)) AS [NO],
		CAST(N'Vendor closed' AS NVARCHAR(255)) AS [NAME],
		CAST(0 AS SMALLINT) AS [LEAD_TIME_DAYS],
		CAST(0 AS BIT) AS [CLOSED],
        CAST(NULL AS CHAR(3)) AS COMPANY


