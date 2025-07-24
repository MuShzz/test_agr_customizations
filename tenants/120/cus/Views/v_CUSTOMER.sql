


-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  04.07.2023.TO   Created
-- ===============================================================================
 
CREATE VIEW [cus].[v_CUSTOMER] AS
	SELECT
        CAST(OCRD.[CardCode] AS NVARCHAR(255)) AS [no],
        CAST(OCRD.[CardName] AS NVARCHAR(255)) AS [name],
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO]
    FROM
		[cus].[OCRD]
	WHERE
		CardType = 'C' --c for customer
	AND CardName IS NOT NULL


