




CREATE VIEW [cus].[v_vendorName]
AS
	SELECT it.ItemCode,
			wh.WhsCode,
			ve.CardName
	FROM cus.OITM it
	INNER JOIN cus.OITW wh ON wh.ItemCode = it.ItemCode
	INNER JOIN cus.OCRD ve ON ve.CardCode = it.CardCode
        

