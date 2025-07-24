



-- ===============================================================================
-- Author:      José Sucena
-- Description: ITEM_GROUP Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ====================================================================================================

CREATE VIEW [cus].[v_ITEM_GROUP] AS
   SELECT
        CAST([GROUP_] AS NVARCHAR(255)) AS [NO],
        CAST([GROUPNAME] AS NVARCHAR(255)) AS [NAME]
   FROM [cus].[INVENITEMGROUP]
  WHERE [DATASET] = 'DAT'


