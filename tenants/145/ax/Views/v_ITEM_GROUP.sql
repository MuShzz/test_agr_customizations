CREATE VIEW [ax_cus].[v_ITEM_GROUP]
AS

SELECT CONVERT(NVARCHAR(30), ecg.Recid) AS NO,
       SUBSTRING(ecg.Name, 1, 50)       AS NAME
FROM ax_cus.ECORESCATEGORY ecg
         INNER JOIN ax_cus.ECORESCATEGORYHIERARCHY ech
                    ON ecg.Partition = ech.Partition AND ech.RecId = ecg.CategoryHierarchy
         INNER JOIN ax_cus.ECORESCATEGORYHIERARCHYROLE echrole ON echrole.CategoryHierarchy = ech.RecId
WHERE echrole.NAMEDCATEGORYHIERARCHYROLE = 4 -- ech.Name = 'Retail Base'-- 'Retail Product Category'

UNION ALL

SELECT CONVERT(NVARCHAR(30), - 99) AS NO,
       'Uncategorized'             AS NAME
