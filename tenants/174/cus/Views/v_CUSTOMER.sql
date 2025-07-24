


-- 2025.06.18.DFS AF-23 - Change customer mapping to use groups for certain customers

CREATE VIEW [cus].[v_CUSTOMER]
AS

    SELECT
        CAST(ACCOUNTNUM AS NVARCHAR(255))     AS [NO],
        CAST(NAME AS NVARCHAR(255))   AS [NAME],
        CAST(STATISTICSGROUP AS NVARCHAR(255))     AS [CUSTOMER_GROUP_NO]
    FROM [cus].CUSTTABLE
	WHERE STATISTICSGROUP  NOT IN ('Bónus','Hagkaup','Olís','Stórkaup')
	
	UNION ALL
	
	SELECT
        CAST('Bónus' AS NVARCHAR(255))     AS [NO],
        CAST('Bónus' AS NVARCHAR(255))   AS [NAME],
        CAST('Bónus' AS NVARCHAR(255))     AS [CUSTOMER_GROUP_NO]
	
	UNION ALL

	SELECT
        CAST('Hagkaup' AS NVARCHAR(255))     AS [NO],
        CAST('Hagkaup' AS NVARCHAR(255))   AS [NAME],
        CAST('Hagkaup' AS NVARCHAR(255))     AS [CUSTOMER_GROUP_NO]
	
	UNION ALL
	
	SELECT
        CAST('Olís' AS NVARCHAR(255))     AS [NO],
        CAST('Olís' AS NVARCHAR(255))   AS [NAME],
        CAST('Olís' AS NVARCHAR(255))     AS [CUSTOMER_GROUP_NO]

	UNION ALL

	SELECT
        CAST('Stórkaup' AS NVARCHAR(255))     AS [NO],
        CAST('Stórkaup' AS NVARCHAR(255))   AS [NAME],
        CAST('Stórkaup' AS NVARCHAR(255))     AS [CUSTOMER_GROUP_NO]





