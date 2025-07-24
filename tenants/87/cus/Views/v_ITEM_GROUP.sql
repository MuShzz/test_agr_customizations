



-- ===============================================================================
-- Author:      José Sucena
-- Description: ITEM_GROUP Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ====================================================================================================

CREATE VIEW [cus].[v_ITEM_GROUP] 
AS

   SELECT
        CAST([Code] AS NVARCHAR(255))			AS [NO],
        CAST([Description] AS NVARCHAR(255))	AS [NAME],
        Company
    FROM
        [cus].item_category


