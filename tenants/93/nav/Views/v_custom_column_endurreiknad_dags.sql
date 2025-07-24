






-- ===============================================================================
-- Author:      HMH
-- Description: Endurreiknad dags generation for custom columns
--
--  2024-08-12: HMH Created
-- ===============================================================================
CREATE VIEW [nav_cus].[v_custom_column_endurreiknad_dags]
AS
	SELECT 
    sub.[itemNo]
    ,sub.[locationNo]
    ,sub.DATE AS endurreiknad
	FROM 
	(
		SELECT DISTINCT
			aei.itemNo,
			aei.locationNo,
			CAST(ci.[Endurreiknað dags_] as DATE) AS [DATE]
		FROM [dbo].[AGREssentials_items] aei
		JOIN nav_cus.Custom_Item ci ON aei.itemNo = ci.No_
	) sub

