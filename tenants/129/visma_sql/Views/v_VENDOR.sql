-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Visma SQL view for vendors
--
-- 19.11.2024.HMH   Created
-- ====================================================================================================
CREATE VIEW [visma_sql_cus].[v_VENDOR] AS

		SELECT
			CAST(Actor.SupNo AS NVARCHAR(255)) AS [NO],
			CAST(Actor.Nm AS NVARCHAR(255)) AS [NAME],
			CAST(Actor.AdmTm + Actor.ProdTm + Actor.DelTm + Actor.TanspTm AS SMALLINT) AS [LEAD_TIME_DAYS],
			CAST(CASE WHEN Actor.Gr10 = 99 THEN 1 ELSE 0 END AS BIT) AS [CLOSED]
		FROM
			[visma_sql].Actor
		WHERE
			Actor.SupNo > 0

