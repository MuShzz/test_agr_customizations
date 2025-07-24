



-- ===============================================================================
-- Author:      José Sucena
-- Description: Customer Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ===============================================================================

CREATE VIEW [cus].[v_CUSTOMER] 
AS
	SELECT DISTINCT
        CAST(c.ACCOUNTNUM AS NVARCHAR(255)) AS [no],
        CAST(c.NAME AS NVARCHAR(255)) AS [name],
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO]
	FROM
		[cus].CUSTOMERVIEW c
    WHERE c.dataareaid = 'rar'


