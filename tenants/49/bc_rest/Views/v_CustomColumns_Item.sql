
-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom Columns Item Extra info
--
-- 26.11.2024.BF    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_CustomColumns_Item] AS
(
	  SELECT 
		  cci.no												AS No,
		  CAST(CASE WHEN cci.discontinued = 'False' THEN 0 
					ELSE 1 
					END AS INT)									AS discontinued
	  FROM bc_rest_cus.CustomColumns_Item cci


)

