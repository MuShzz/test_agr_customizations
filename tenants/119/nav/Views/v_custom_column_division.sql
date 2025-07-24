



-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Division Description custom column
--
-- 08.10.2024.BF    Created
-- ===============================================================================

CREATE VIEW [nav_cus].[v_custom_column_division]
AS

 
  SELECT
		No_,
		d.Description
  FROM nav_cus.OverrideRawData_Item ori
  INNER JOIN nav_cus.Division d ON d.Code=ori.[Division Code]



