
CREATE VIEW [bc_sql_cus].[v_ITEM_GROUP] AS

	SELECT
		CAST([Code] AS NVARCHAR(255)) AS [NO],
        CAST([Description] AS NVARCHAR(255)) AS [NAME]
	FROM
		bc_sql.ItemCategory

	UNION 

	SELECT
		CAST(Code AS NVARCHAR(255)) AS [NO],
        CAST([Description] AS NVARCHAR(255)) AS [NAME]
    FROM
		bc_sql_cus.LSCProductGroup


