


-- ===============================================================================
-- Author:      VR
-- Description: Custom Column Source Object for Designer
--
-- ===============================================================================
CREATE VIEW [bc_sql_cus].[v_Designer]
AS

    SELECT cci.[No_] AS [No_],
		ccp2.[Description] AS [Description]
	FROM bc_sql_cus.CustomColumns_Item cci
	INNER JOIN bc_sql_cus.CustomColumns_ProductType ccp ON cci.[No_] = ccp.[No_]
	INNER JOIN bc_sql_cus.CustomColumns_ProductType2 ccp2 ON ccp.[EVS Item Analysis 1] = ccp2.[Code]


