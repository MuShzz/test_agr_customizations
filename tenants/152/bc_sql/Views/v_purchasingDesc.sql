

-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom Column to map for purchasing code description
--
--  14.03.2025.BF   Created
-- ===============================================================================

CREATE VIEW [bc_sql_cus].[v_purchasingDesc] AS
   
	SELECT
        CAST(i.itemNo AS NVARCHAR(255)) AS [NO],
        CAST(p.Description AS NVARCHAR(100)) AS [purchasingDesc]
	FROM
		dbo.AGREssentials_items i
		inner JOIN bc_sql_cus.ItemExtraInfo ix ON ix.No_=i.itemNo
		LEFT JOIN bc_sql_cus.Purchasing p ON p.Code=ix.[Purchasing Code]


