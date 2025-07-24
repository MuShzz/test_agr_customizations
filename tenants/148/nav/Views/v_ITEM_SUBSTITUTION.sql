

-- ===============================================================================
-- Author:      Grétar Magnússon
-- Description: Mapping NAV Item Substition table and setting Substitute Exists column if item matches
--
-- 06.02.2025.GM    Created
-- ===============================================================================

CREATE VIEW [nav_cus].[v_ITEM_SUBSTITUTION]
AS

	--SELECT
	--	CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' 
	--						ELSE '-' + iv.[Code] END AS NVARCHAR(255))					AS [No_],
	--	STRING_AGG(ist.[Substitute No_], '| ')											AS [Substitute_No_],
	--	STRING_AGG(CAST(ISNULL(CAST(sl.STOCK_UNITS AS INT),0) AS NVARCHAR(255)), '| ')	AS [Substitute_Stock]
	--FROM
	--	nav.Item i
	--	LEFT JOIN nav.ItemVariant iv ON iv.[Item No_] = i.No_
	--	LEFT JOIN nav_cus.Item_Substitution ist ON ist.No_ = i.No_
	--	LEFT JOIN adi.STOCK_LEVEL sl ON sl.ITEM_NO = ist.[Substitute No_]
	--WHERE
	--	ist.No_ IS NOT NULL
	--	--AND i.No_ = '84228488'
	--GROUP BY
	--	i.No_, iv.Code

	SELECT
        CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN ''
                            ELSE '-' + iv.[Code] END AS NVARCHAR(255))                  AS [No_],
        STRING_AGG(ist.[Substitute No_], ', ') WITHIN GROUP (ORDER BY ist.[Substitute No_] ASC) AS [Substitute_No_],
        '(' + STRING_AGG(CAST(ISNULL(CAST(sl.STOCK_UNITS AS INT),0) AS NVARCHAR(255)), ', ') WITHIN GROUP (ORDER BY ist.[Substitute No_] ASC) + ')' AS [Substitute_Stock]
    FROM
        nav.Item i
        LEFT JOIN nav.ItemVariant iv ON iv.[Item No_] = i.No_
        LEFT JOIN nav_cus.Item_Substitution ist ON ist.No_ = i.No_
        LEFT JOIN adi.STOCK_LEVEL sl ON sl.ITEM_NO = ist.[Substitute No_]
    WHERE
        ist.No_ IS NOT NULL
        --AND i.No_ = '84228488'
    GROUP BY
        i.No_, iv.Code



