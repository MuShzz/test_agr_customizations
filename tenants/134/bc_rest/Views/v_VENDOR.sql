
-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Vendor mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- 28.02.2025.DFS	Filtering out vendors with no products
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_VENDOR]
AS
 
		SELECT
			v.[No] AS [NO],
			ISNULL(NULLIF(v.[Name],''), v.[No]  + ' (name missing)') AS [NAME],
			ISNULL(bc_rest.LeadTimeConvert(v.[LeadTimeCalculation],GETDATE()), 1) AS LEAD_TIME_DAYS,
			CAST(IIF(v.[Blocked] = '',0,1) AS BIT) AS CLOSED
			--,COUNT(i.No)
		FROM
			[bc_rest].vendor v
		JOIN 
			bc_rest.item i ON i.VendorNo = v.No
		GROUP BY ISNULL(NULLIF(v.[Name], ''), v.[No] + ' (name missing)'),
                 ISNULL(bc_rest.LeadTimeConvert(v.[LeadTimeCalculation], GETDATE()), 1),
                 CAST(IIF(v.[Blocked] = '', 0, 1) AS BIT),
                 v.No
		HAVING COUNT(i.No) > 0
		--ORDER BY COUNT(i.No) DESC

