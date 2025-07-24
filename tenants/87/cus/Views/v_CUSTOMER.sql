


-- ===============================================================================
-- Author:      José Sucena
-- Description: CUSTOMER Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ====================================================================================================

CREATE VIEW [cus].[v_CUSTOMER] AS

	SELECT
        CAST('agr_no_customer' AS NVARCHAR(255)) AS [no],
        CAST('N/A' AS NVARCHAR(255)) AS [name],
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO],
        CAST(NULL AS CHAR(3)) AS Company
    
	UNION

	SELECT
        CAST([No] AS NVARCHAR(255)) AS [no],
        CAST([Name] AS NVARCHAR(255)) AS [name],
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO],
        Company
	FROM
        [cus].customer c


