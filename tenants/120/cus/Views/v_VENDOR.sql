




-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

    CREATE VIEW [cus].[v_VENDOR] AS
       SELECT
            CAST(OCRD.[Cardcode] AS NVARCHAR(255)) AS [NO],
            CAST(OCRD.[Cardname] AS NVARCHAR(255)) AS [NAME],
            ISNULL(CAST(OCRD.[U_LeadTime] AS SMALLINT)*7, 30) AS [LEAD_TIME_DAYS],
            CAST(IIF(OCRD.[FrozenFor]='Y', 1, 0) AS BIT) AS [CLOSED]
       FROM cus.OCRD
		WHERE OCRD.[CardType] = 'S'


