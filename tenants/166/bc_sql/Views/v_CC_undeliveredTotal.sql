

-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns last days sale amount
--
-- 19.03.2025.BF	Created
-- ===============================================================================


CREATE VIEW [bc_sql_cus].[v_CC_undeliveredTotal]
AS

	WITH CTE_UPO AS (
		SELECT  
			upo.ITEM_NO,  
			SUM(upo.QUANTITY) AS total_upo  
		FROM  
			adi.UNDELIVERED_PURCHASE_ORDER upo  
			JOIN core.location_mapping_setup lm ON upo.LOCATION_NO = lm.locationNo  
		GROUP BY upo.ITEM_NO  
	),  
	CTE_UTO AS (
		SELECT  
			uto.ITEM_NO,  
			SUM(uto.QUANTITY) AS total_uto  
		FROM  
			adi.UNDELIVERED_TRANSFER_ORDER uto  
			JOIN core.location_mapping_setup lm ON uto.LOCATION_NO = lm.locationNo  
		GROUP BY uto.ITEM_NO  
	)  
	SELECT  
		CAST(it.NO AS NVARCHAR(255)) AS ITEM_NO,  
		CAST(ISNULL(upo.total_upo, 0) + ISNULL(uto.total_uto, 0) AS INT) AS undeliveredTotal  
	FROM  
		adi.ITEM it  
		LEFT JOIN CTE_UPO upo ON it.NO = upo.ITEM_NO  
		LEFT JOIN CTE_UTO uto ON it.NO = uto.ITEM_NO  
	GROUP BY it.NO, upo.total_upo, uto.total_uto




