



CREATE VIEW [cus].[v_ITEM_GROUP] AS
   SELECT
        CAST(ItmsGrpCod AS NVARCHAR(255)) AS [NO],
        CAST(ItmsGrpNam AS NVARCHAR(255)) AS [NAME]
   FROM
        [cus].OITB


