



-- ===============================================================================
-- Author:      José Sucena
-- Description: Location mapping from cus
--
--  24.09.2024.TO   Created
-- ===============================================================================

CREATE VIEW [cus].[v_LOCATION] 
AS
       SELECT
            CAST([INVENLOCATION] AS NVARCHAR(255)) AS [NO],
            CAST([NAME] AS NVARCHAR(255)) AS [NAME]
       FROM [cus].[INVENLOCATION]
	   WHERE [DATASET] = 'DAT'

	   UNION ALL

	   -- HARDCODE THE LOCATION BECAUSE THEY DON'T HAVE IT, IT'S A HIDDEN CHARACTER
	    SELECT
            CAST('' AS NVARCHAR(255)) AS [no],
            CAST('Avant Denmark' AS NVARCHAR(255)) AS [name]


