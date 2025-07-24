-- ===============================================================================
-- Author:      BF
-- Description: View to fetch most recent status for custom column PF-12
--
--  2025.01.06.BF Created
-- ===============================================================================


CREATE VIEW [bc_sql_cus].[v_CustomColumns_Status]
AS

	WITH MaxDate AS (
		SELECT
			[Item No_],
			[Location Code],
			[Status Code],
			[Starting Date],
			ROW_NUMBER() OVER (PARTITION BY [Item No_], [Location Code] ORDER BY [Starting Date] DESC) AS RowNum
		FROM  bc_sql_cus.CustomColumns_Status
	)
	SELECT
		aei.[itemNo] AS [itemNo],
		CAST(st.[Status Code] AS NVARCHAR(50)) AS [status]
	FROM dbo.[AGREssentials_items] aei
		INNER JOIN MaxDate st ON st.[Item No_]=aei.itemNo
	WHERE st.RowNum = 1;


