



-- ===============================================================================
-- Author:      José Sucena
-- Description: CUSTOMER Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ====================================================================================================

CREATE VIEW [cus].[v_CUSTOMER] AS
	SELECT
        CAST([ACCOUNT] AS NVARCHAR(255)) AS [no],
        CAST([NAME] AS NVARCHAR(255)) AS [name],
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO]
    FROM [cus].[CUSTTABLE]
	WHERE DATASET ='DAT'
	AND BLOCKED = 0


