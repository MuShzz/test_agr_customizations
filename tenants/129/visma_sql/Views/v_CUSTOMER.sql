-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Visma SQL view for customers
--
-- 19.11.2024.HMH   Created
-- ====================================================================================================


CREATE VIEW [visma_sql_cus].[v_CUSTOMER] AS
	
	SELECT
		CAST(Actor.CustNo AS NVARCHAR(255)) AS [NO],
		CAST(Actor.Nm AS NVARCHAR(255)) AS [NAME],
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO]
	FROM
		[visma_sql].Actor
	WHERE
		Actor.CustNo > 0

