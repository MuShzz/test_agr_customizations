




CREATE VIEW [cus].[v_constraintComment]
AS
	SELECT it.ItemCode,
			wh.WhsCode,
			acr.U_Remarks
	FROM cus.OITM it
	INNER JOIN cus.OITW wh ON wh.ItemCode = it.ItemCode
	LEFT JOIN cus.[@ALL_CARRIAGE_RULES] acr ON acr.Code = it.CardCode

