
-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Visma SQL view for locations
--
-- 19.11.2024.HMH   Created
-- ====================================================================================================


CREATE VIEW [visma_sql_cus].[v_LOCATION] AS

	SELECT
		CAST(Stc.StcNo AS NVARCHAR(255)) AS [NO],
		CAST(Stc.Nm AS NVARCHAR(255)) AS [NAME]
	FROM
		[visma_sql].Stc
	--WHERE
		--Stc.Fax = 'ST' or Stc.Fax = 'WH'

