




-- ===============================================================================
-- Author:      Dana Rut 
-- Description: View to map custom columns. 
--
-- 06.06.2025.DRG    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_cc_item]
AS


		SELECT DISTINCT 
			CAST(No AS NVARCHAR(255)) AS ITEM_NO,
			CAST(bc1_calcItemStatGroupDesc AS NVARCHAR(100)) AS bc1_calcItemStatGroupDesc,
			CAST(bc1_calcItemStatGroup2Desc AS NVARCHAR(100)) AS bc1_calcItemStatGroup2Desc,
			CAST(bc1_calcItemStatGroup4desc	AS NVARCHAR(100)) AS bc1_calcItemStatGroup4desc,
			CAST(bc1_calcItemStatGroup3Desc	AS NVARCHAR(100)) AS bc1_calcItemStatGroup3Desc,
			CAST(bc1_calcItemStatGroup5Desc	AS NVARCHAR(100)) AS bc1_calcItemStatGroup5Desc
		FROM [bc_rest_cus].item_extra_info
		WHERE Inventory_Posting_Group = 'FINISHED'
		AND LEN(No) > 8
		AND CAST(No AS NVARCHAR(255)) <> ''

		UNION 

		SELECT DISTINCT 
			CAST(bc1_ItemHeaderID+bc1_ItemVariant1ID AS NVARCHAR(255)) AS ITEM_NO,
			--CAST(bc1_calcItemStatGroupDesc AS NVARCHAR(100)) AS bc1_calcItemStatGroupDesc,
			CAST(NULL AS NVARCHAR(100)) AS bc1_calcItemStatGroupDesc,
			CAST(NULL AS NVARCHAR(100)) AS bc1_calcItemStatGroup2Desc,
			--CAST(bc1_calcItemStatGroup2Desc AS NVARCHAR(100)) AS bc1_calcItemStatGroup2Desc,
			CAST(bc1_calcItemStatGroup4desc	AS NVARCHAR(100)) AS bc1_calcItemStatGroup4desc,
			CAST(bc1_calcItemStatGroup3Desc	AS NVARCHAR(100)) AS bc1_calcItemStatGroup3Desc,
			CAST(bc1_calcItemStatGroup5Desc	AS NVARCHAR(100)) AS bc1_calcItemStatGroup5Desc
		FROM [bc_rest_cus].item_extra_info
		WHERE Inventory_Posting_Group = 'FINISHED'
		 AND LEN(No) > 8
		AND CAST(bc1_ItemHeaderID+bc1_ItemVariant1ID AS NVARCHAR(255)) <> ''


