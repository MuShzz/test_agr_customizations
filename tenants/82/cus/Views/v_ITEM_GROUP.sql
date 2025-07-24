

-- ===============================================================================
-- Author:      José Sucena
-- Description: Bom Component Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ===============================================================================

CREATE VIEW [cus].[v_ITEM_GROUP] 
AS

   SELECT DISTINCT
        CAST(itemgroupid AS NVARCHAR(255)) AS [NO],
        CAST(NAME AS NVARCHAR(255)) AS [NAME]
   FROM [cus].INVENTITEMGROUP it
	WHERE name <> 'Þjónustunúmer'


