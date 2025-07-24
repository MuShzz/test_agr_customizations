

-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================


    CREATE VIEW [cus].[v_VENDOR] AS
       SELECT
            CAST(Cardcode AS NVARCHAR(255)) AS [NO],
            CAST(CardCode + ISNULL(' - ' + CardName,'') AS NVARCHAR(255)) AS [NAME],
            CAST(1 AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST(IIF(frozenFor = 'Y', 1, 0) AS BIT) AS [CLOSED]
        FROM
			[cus].OCRD
		WHERE
			CardType = 'S' -- 'S' means supplier so we only want to filter on them (also have customers in this table)



