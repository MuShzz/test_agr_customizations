CREATE VIEW [cus].v_ITEM_GROUP
             AS
            SELECT
        CAST([MaterialGroup] AS NVARCHAR(255)) AS [NO],
        CAST([MaterialGroupName] AS NVARCHAR(255)) AS [NAME]
    FROM
        [cus].ProductGroupText
		WHERE LANGUAGE='EN'

