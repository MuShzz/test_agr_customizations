CREATE VIEW [ax_cus].[v_ITEM_GROUP] 
AS

   SELECT 
        CAST(ecg.Recid AS NVARCHAR(255))		AS [NO],
        CAST(ecg.NAME AS NVARCHAR(255))			AS [NAME],
        CAST(c.company_id AS NVARCHAR(4))		AS [COMPANY]
   FROM    
		ax_cus.ECORESCATEGORY ecg
		INNER JOIN ax_cus.ECORESCATEGORYHIERARCHY ech			ON ecg.Partition = ech.Partition AND ech.RecId = ecg.CategoryHierarchy
		INNER JOIN ax_cus.ECORESCATEGORYHIERARCHYROLE echrole	ON echrole.CategoryHierarchy = ech.RecId
		LEFT JOIN ax.Companies c								ON c.company_id = 'byko'
	WHERE 
		echrole.NamedCategoryHierarchyRole = 4
		AND ecg.RECID <>'5637144576' --all products not a real group level

	UNION ALL

	SELECT 
		CONVERT(NVARCHAR(30), - 99)				AS NO,
		'Uncategorized'							AS NAME,
		CAST(c.company_id AS NVARCHAR(4))    AS [COMPANY]
	FROM  ax.Companies c
	WHERE c.company_id = 'byko'

