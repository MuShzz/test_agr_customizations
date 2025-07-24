




CREATE VIEW [cus].[v_categoryManagerIdentification]
AS
	SELECT it.ItemCode,
		CAST(CASE WHEN it.QryGroup6 = 'Y' THEN 'A'
			WHEN it.QryGroup8 = 'Y' THEN 'C'
			WHEN it.QryGroup9 = 'Y' THEN 'D' 
			ELSE ' ' END AS NVARCHAR(255)) AS CategoryIdentification
	FROM cus.OITM it
        

