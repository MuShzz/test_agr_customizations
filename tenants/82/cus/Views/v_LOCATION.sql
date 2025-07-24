


-- ===============================================================================
-- Author:      José Sucena
-- Description: Location Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ===============================================================================

CREATE VIEW [cus].[v_LOCATION] 
AS

WITH erp_locations AS
    (
        SELECT DISTINCT
            CAST(il.INVENTLOCATIONID AS NVARCHAR(255)) AS [NO],
            CAST((il.INVENTLOCATIONID + ' - ' + il.NAME) AS NVARCHAR(255)) AS [NAME], -- 22.02.2024.DFS Rarik Asked to add inn
            NULL AS [GROUP],
            CASE WHEN il.INVENTLOCATIONID IN ('600', '860') THEN 'warehouse'
            ELSE 'store' END AS [TYPE],
            CAST(0 AS BIT) AS CLOSED,
            CAST(NULL AS DATE) AS OPENING_DATE,
            CAST(NULL AS DATE) AS CLOSING_DATE
		FROM [cus].INVENTLOCATION il
       WHERE il.dataareaid = 'rar'
         AND il.INVENTLOCATIONID NOT IN ('110','210','211','213','220','222','998','Bid','Flut') -- Rarik specific
         --AND il.INVENTLOCATIONID NOT LIKE '%M%'-- Rarik specific -- 22.02.2024.DFS Rarik Asked to add inn
    )

       SELECT
            loc_list.[NO] AS [NO],
            loc_list.[NAME] AS [NAME],
			loc_list.[GROUP],
			CAST(COALESCE(clms.location_type, loc_list.[TYPE]) AS NVARCHAR(255)) AS [TYPE],
			loc_list.CLOSED,
			loc_list.OPENING_DATE,
			loc_list.CLOSING_DATE

       FROM
       (SELECT
            l.[NO], l.[NAME], l.[GROUP], l.[TYPE], l.CLOSED, l.OPENING_DATE, l.CLOSING_DATE
        FROM
            erp_locations l) loc_list
        LEFT JOIN [cus].location_mapping_setup clms ON clms.location_no = loc_list.[NO]


