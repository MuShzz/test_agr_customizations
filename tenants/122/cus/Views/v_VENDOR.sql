




CREATE VIEW [cus].[v_VENDOR] AS
       SELECT
            CAST(Cardcode AS NVARCHAR(255)) AS [NO],
            CAST(CardCode + ISNULL(' - ' + CardName,'') AS NVARCHAR(255)) AS [NAME],
            CAST(ISNULL(U_Leadtime,1) AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST(IIF(frozenFor = 'Y', 1, 0) AS BIT) AS [CLOSED]
       FROM
        [cus].OCRD
	WHERE
		CardType = 'S' 
		AND GroupCode='101'


