



-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

CREATE VIEW [cus].[v_CUSTOMER] AS
	SELECT
        CAST('agr_no_customer' AS NVARCHAR(255)) AS NO,
        CAST('N/A' AS NVARCHAR(255)) AS NAME,
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO],
        CAST(NULL AS CHAR(3)) AS Company

    UNION
	SELECT
        CAST([No_] AS NVARCHAR(255)) AS [no],
        CAST([Name] AS NVARCHAR(255)) AS [name],
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO],
        Company
    FROM
        cus.customer c


