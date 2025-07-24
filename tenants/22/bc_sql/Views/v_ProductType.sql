


-- ===============================================================================
-- Author:      VR
-- Description: Custom Column Source Object for Product Type
--
-- ===============================================================================
CREATE VIEW [bc_sql_cus].[v_ProductType]
AS

    SELECT cci.[No_] AS [No_],
		ccd.[Description] AS [Description]
	FROM bc_sql_cus.CustomColumns_Item cci
	INNER JOIN bc_sql_cus.CustomColumns_Designer ccd ON cci.[Item Category Code] = ccd.[Item Category Code] AND cci.[Sub Analysis 1] = ccd.[Code]


