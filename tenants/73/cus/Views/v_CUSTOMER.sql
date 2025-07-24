


-- ===============================================================================
-- Author:      José Santos
-- Description: Customer mapping erp raw to adi
--
--  04.07.2023.TO   Created
-- ===============================================================================

CREATE VIEW [cus].[v_CUSTOMER] AS
	SELECT
        CAST(c.CardCode AS NVARCHAR(255)) AS [no],
        CAST(c.CardName AS NVARCHAR(255)) AS [name],
        CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_GROUP_NO]
    FROM
		[cus].[OCRD] c
	WHERE
		c.CardType = 'C' --c for customer
	AND c.CardName IS NOT NULL

