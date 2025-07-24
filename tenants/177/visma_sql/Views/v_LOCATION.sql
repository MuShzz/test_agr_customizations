CREATE VIEW [visma_sql_cus].[v_LOCATION] AS

	SELECT
		CAST(Stc.StcNo AS NVARCHAR(255)) AS [NO],
		CAST(Stc.Nm AS NVARCHAR(255)) AS [NAME]
	FROM
		[visma_sql].Stc


