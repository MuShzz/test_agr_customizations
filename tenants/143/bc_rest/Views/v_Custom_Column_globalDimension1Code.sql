
-- ===============================================================================
-- Author:      Daniel Freyr Snorrason
-- Description: Custom culomn data for globalDimension1Code
--
-- 05.03.2025.DFS    Created
-- ===============================================================================


CREATE VIEW [bc_rest_cus].[v_Custom_Column_globalDimension1Code]
AS


	SELECT
		number as itemNo
		,globaldimension1Code AS customColumnValue
	FROM bc_rest_cus.CustomColumnItem

	

