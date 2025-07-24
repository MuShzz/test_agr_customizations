

-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Visma SQL view for item groups
--
-- 19.11.2024.HMH   Created
-- ====================================================================================================

CREATE VIEW [visma_sql_cus].[v_ITEM_GROUP] AS
   
	SELECT
		CAST(Txt.TxtNo AS NVARCHAR(255)) AS [NO],
		CAST(Txt.Txt AS NVARCHAR(255)) AS [NAME]
	FROM
		[visma_sql].Txt
	WHERE 1=0
		--Txt.Lang = 47 --and (Txt.TxtTp = 58 or Txt.TxtTp = 44 or Txt.TxtTp = 19)

