
CREATE VIEW [ax_cus].[v_VENDOR] 
AS
	WITH cte AS (
		SELECT  DISTINCT   
			v.ACCOUNTNUM											AS NO,
			dpt.NAME												AS NAME,
			CAST(IIF(bk.LEADTIME > 0, bk.LEADTIME, 1) AS SMALLINT)	AS LEAD_TIME_DAYS,
			CAST(0 AS BIT)											AS CLOSED,
			CAST(c.company_id AS NVARCHAR(255))						AS COMPANY,
			ROW_NUMBER() OVER (PARTITION BY v.ACCOUNTNUM ORDER BY v.ACCOUNTNUM) AS rn
		FROM         
			ax.VendTable v
			LEFT OUTER JOIN  ax_cus.INVENTBUYERGROUP ib    ON v.ITEMBUYERGROUPID = ib.GROUP_ AND v.DATAAREAID = ib.DATAAREAID
			INNER JOIN ax_cus.DirPartyTable dpt            ON v.Party = dpt.RecId AND v.Partition = dpt.PARTITION  
			LEFT JOIN ax_cus.BYKVENDLEADTIME bk			ON bk.VENDACCOUNT = v.ACCOUNTNUM
			LEFT JOIN ax.Companies c ON c.company_id = 'byko'
		WHERE v.ACCOUNTNUM NOT IN ('229','339')
	)
	SELECT 
		cte.NO,
		cte.NAME,
		cte.LEAD_TIME_DAYS,
		cte.CLOSED,
		cte.COMPANY
	FROM cte
	WHERE rn = 1

	UNION ALL

	SELECT
		CAST(N'vendor_missing' AS NVARCHAR(255))	AS [NO],
		CAST(N'Vendor missing' AS NVARCHAR(255))	AS [NAME],
		CAST(0 AS SMALLINT)							AS LEAD_TIME_DAYS,
		CAST(0 AS BIT)								AS CLOSED,
		CAST(c.company_id AS NVARCHAR(255))			AS COMPANY
	FROM  ax.Companies c
	WHERE c.company_id = 'byko'

	UNION ALL

	SELECT
		CAST(N'vendor_closed' AS NVARCHAR(255)) AS [NO],
		CAST(N'Vendor closed' AS NVARCHAR(255)) AS [NAME],
		CAST(0 AS SMALLINT)						AS LEAD_TIME_DAYS,
		CAST(0 AS BIT)							AS CLOSED,
		CAST(c.company_id AS NVARCHAR(255))		AS COMPANY
	FROM  ax.Companies c
	WHERE c.company_id = 'byko'

