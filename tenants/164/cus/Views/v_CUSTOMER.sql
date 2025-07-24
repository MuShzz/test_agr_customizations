

-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Customer mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- ===============================================================================

CREATE VIEW [cus].[v_CUSTOMER]
AS

    SELECT
        CAST([No] AS NVARCHAR(255)) AS NO,
        CAST([Name] AS NVARCHAR(255)) AS NAME,
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO],
		[Company]
    FROM
        cus.customer c

