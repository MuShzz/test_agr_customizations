
CREATE VIEW [ax_cus].[v_ITEM_GROUP] 
AS

    SELECT
        CAST(CONVERT(NVARCHAR(30), ecg.Recid) AS NVARCHAR(255)) AS [NO],
        CAST(SUBSTRING(ecg.Name, 1, 50) AS NVARCHAR(255)) AS [NAME]
   FROM    
		ax_cus.ECORESCATEGORY ecg
		INNER JOIN ax_cus.ECORESCATEGORYHIERARCHY ech	
			ON ecg.Partition = ech.Partition
			AND ech.RecId = ecg.CategoryHierarchy
		INNER JOIN ax_cus.ECORESCATEGORYHIERARCHYROLE echrole		
			ON echrole.CategoryHierarchy = ech.RecId
	WHERE 
		echrole.NamedCategoryHierarchyRole = 4

