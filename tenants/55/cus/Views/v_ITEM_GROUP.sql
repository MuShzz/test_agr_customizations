


CREATE VIEW [cus].[v_ITEM_GROUP] AS
   SELECT DISTINCT
        CAST(P.ProdPrGr AS NVARCHAR(255)) AS [NO],
        CAST(txt.Txt AS NVARCHAR(255)) AS [NAME]
   FROM
        [cus].[Txt] txt 
		INNER JOIN [cus].[Prod] P ON txt.TxtNo = P.ProdPrGr
    WHERE TxtTp = 13 AND LANG=47--product type

