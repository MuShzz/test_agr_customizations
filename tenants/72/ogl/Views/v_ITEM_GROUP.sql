




CREATE VIEW [ogl_cus].[v_ITEM_GROUP]
AS

    SELECT DISTINCT
        CAST(code+'-Group' AS NVARCHAR(255)) AS [NO],
        CAST(desc_ AS NVARCHAR(255)) AS [NAME]
    FROM
        [ogl].STStockGroups
	UNION 
	SELECT DISTINCT
        CAST(code+'-Type' AS NVARCHAR(255)) AS [NO],
        CAST(desc_ AS NVARCHAR(255)) AS [NAME]
	FROM [ogl].STStockTypes


