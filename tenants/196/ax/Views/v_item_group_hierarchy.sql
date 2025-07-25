
CREATE VIEW [ax_cus].[v_item_group_hierarchy]
AS
SELECT 
	ecg.RECID AS category,
	IIF(ecg.PARENTCATEGORY=0, CAST(NULL AS BIGINT), ecg.PARENTCATEGORY) AS parent_category
FROM
	ax_cus.ECORESCATEGORY ecg
    JOIN ax_cus.ECORESCATEGORYHIERARCHY ech ON ecg.PARTITION=ech.PARTITION AND ech.RECID=ecg.CATEGORYHIERARCHY
    JOIN ax_cus.ECORESCATEGORYHIERARCHYROLE echrole ON echrole.CATEGORYHIERARCHY=ech.RECID
WHERE
	echrole.NAMEDCATEGORYHIERARCHYROLE=4; -- ech.Name = 'Retail Base'-- 'Retail Product Category'

