

-- ===============================================================================
-- Author:      José Sucena
-- Description: VENDOR Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ===============================================================================

CREATE VIEW [cus].[v_VENDOR] 
AS

       SELECT
            CAST(v.ACCOUNTNUM AS NVARCHAR(255)) AS [NO],
            CAST(dpt.NAME AS NVARCHAR(255)) AS [NAME],
            CAST(0 AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST(v.BLOCKED AS BIT) AS [CLOSED]
       FROM [cus].VENDTABLE v
	   --inner JOIN  [cus].INVENTBUYERGROUP ib ON v.ItemBuyerGroupId = ib.GROUP_ AND v.DATAAREAID = ib.DATAAREAID
	   INNER JOIN [cus].DirPartyTable dpt ON v.PARTY = dpt.RECID AND v.PARTITION = dpt.PARTITION
	   WHERE 
	   [ACCOUNTNUM] IN (SELECT DISTINCT [PRIMARYVENDORID] FROM [cus].[INVENTTABLE])
       AND v.dataareaid = 'rar'
       --GROUP BY CAST(v.ACCOUNTNUM AS NVARCHAR(255)), CAST(v.BLOCKED AS BIT)


