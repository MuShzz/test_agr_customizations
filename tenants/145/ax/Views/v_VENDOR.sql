CREATE VIEW [ax_cus].[v_VENDOR] 
AS

       SELECT
            CAST(v.ACCOUNTNUM AS NVARCHAR(255))   AS [NO],
            CAST(dpt.NAME AS NVARCHAR(255))       AS [NAME],
            CAST(0 AS SMALLINT)                   AS [LEAD_TIME_DAYS],
            CAST(v.BLOCKED AS BIT)                AS [CLOSED],
            CAST(v.DATAAREAID AS NVARCHAR(4))    AS [COMPANY]
       FROM [ax_cus].VENDTABLE v
	   INNER JOIN [ax].DIRPARTYTABLE dpt ON v.PARTY = dpt.RECID AND v.PARTITION = dpt.PARTITION
	   WHERE (LEN(v.ACCOUNTNUM) <> 10 OR v.ACCOUNTNUM LIKE '4%' OR v.ACCOUNTNUM LIKE '5%' OR v.ACCOUNTNUM LIKE '6%' OR v.ACCOUNTNUM LIKE '7%' OR v.ACCOUNTNUM LIKE '%.%') 
		AND v.VENDGROUP NOT LIKE 'Starfsmenn' 
		AND dpt.name <> 'eyða'
		AND dpt.name NOT LIKE '%hætt%' 
	   
