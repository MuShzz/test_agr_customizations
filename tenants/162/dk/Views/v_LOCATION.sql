
-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Location order route mapping from dk
--
--  24.10.2024.TO   Created
-- ===============================================================================


CREATE VIEW [dk_cus].[v_LOCATION]
AS

	SELECT
		CAST(iw.[Code] AS NVARCHAR(255)) 						AS [no],
		CAST(COALESCE(iw.[Name],iw.[Code]) AS NVARCHAR(255)) 	AS [name]
	FROM
		[dk].[import_warehouses] iw
	WHERE iw.[Code] IS NOT NULL

	UNION ALL
	
	SELECT
		CAST('tom_stadsetning' AS NVARCHAR(255)) 						AS [no],
		CAST('tom_stadsetning' AS NVARCHAR(255)) 	AS					 [name]



