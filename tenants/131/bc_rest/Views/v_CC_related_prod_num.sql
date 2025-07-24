
-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom columns for info about related product numbers
--
-- 19.03.2025.BF	Created
-- ===============================================================================


CREATE VIEW [bc_rest_cus].[v_CC_related_prod_num]
AS

 SELECT
        it.NO																						AS [ITEM_NO],
		lm.locationNo																				AS [LOCATION_NO],
		CAST(
				CONCAT( [Substitute_1], 
						IIF([Substitute_2] <> '', CONCAT(' - ', [Substitute_2]), NULL), 
						IIF([Substitute_3] <> '', CONCAT(' - ', [Substitute_3]), NULL)) 
			AS NVARCHAR(255))																		AS TengdVoruNr,

		CAST(CONCAT( IIF(1 = (		SELECT il2.CLOSED
										FROM adi.ITEM_LOCATION il2
										WHERE il2.ITEM_NO = [Substitute_1] AND il.LOCATION_NO = il2.LOCATION_NO
								), [Substitute_1], NULL) , 
						IIF(1 = (		SELECT il2.CLOSED 
										FROM adi.ITEM_LOCATION il2
										WHERE il2.ITEM_NO = [Substitute_2] AND il.LOCATION_NO = il2.LOCATION_NO
								), CONCAT(' - ', [Substitute_2]), NULL) ,
						IIF(1 = (		SELECT il2.CLOSED 
										FROM adi.ITEM_LOCATION il2
										WHERE il2.ITEM_NO = [Substitute_3] AND il.LOCATION_NO = il2.LOCATION_NO
								), CONCAT(' - ', [Substitute_3]), NULL) 
					) AS NVARCHAR(255))																AS TengdVoruNrLokud,

		CAST(CONCAT( IIF(0 = (		SELECT il2.CLOSED 
										FROM adi.ITEM_LOCATION il2
										WHERE il2.ITEM_NO = [Substitute_1] AND il.LOCATION_NO = il2.LOCATION_NO
								), [Substitute_1], NULL) , 
						IIF(0 = (		SELECT il2.CLOSED 
										FROM adi.ITEM_LOCATION il2
										WHERE il2.ITEM_NO = [Substitute_2] AND il.LOCATION_NO = il2.LOCATION_NO
								), CONCAT(' - ', [Substitute_2]), NULL) ,
						IIF(0 = (		SELECT il2.CLOSED 
										FROM adi.ITEM_LOCATION il2
										WHERE il2.ITEM_NO = [Substitute_3] AND il.LOCATION_NO = il2.LOCATION_NO
								), CONCAT(' - ', [Substitute_3]), NULL) 
					) AS NVARCHAR(255))																AS TengdVoruNrOpin,

		CAST(CONCAT( (Select COST_PRICE from adi.ITEM WHERE [NO] = [Substitute_1])  , 
						IIF((Select COST_PRICE from adi.ITEM WHERE [NO] = [Substitute_2]) IS NOT NULL, 
									CONCAT(' - ', (Select CAST(COST_PRICE AS DECIMAL(18,2)) from adi.ITEM WHERE [NO] = [Substitute_2])), NULL) ,
						IIF((Select COST_PRICE from adi.ITEM WHERE [NO] = [Substitute_3]) IS NOT NULL, 
									CONCAT(' - ', (Select CAST(COST_PRICE AS DECIMAL(18,2)) from adi.ITEM WHERE [NO] = [Substitute_3])), NULL) 
					) AS NVARCHAR(255))																AS VerdTengdraVnr,

		CAST(iei.Unit_Price AS DECIMAL(18,2))														AS Vh2,
		CAST(CONCAT(CAST(iei.Foreign_Purchase_price AS DECIMAL(18,2)), ' ', iei.Currency_Code) AS NVARCHAR(255))  AS Vh4,
		CAST(iei.[Item_subject_1] AS NVARCHAR(255))													AS Vidfangsefnaflokkur1,
		CAST(iei.[Item_subject_2] AS NVARCHAR(255))													AS Vidfangsefnaflokkur2,
		CAST(IIF(iei.[Substitute_1]='', NULL, iei.[Substitute_1]) AS NVARCHAR(255)) AS Substitute_1,
		CAST(IIF(iei.[Substitute_2]='', NULL, iei.[Substitute_2]) AS NVARCHAR(255)) AS Substitute_2,
		CAST(IIF(iei.[Substitute_3]='', NULL, iei.[Substitute_3]) AS NVARCHAR(255)) AS Substitute_3,
		CAST(iei.LastPurchaseDate  AS DATE) AS LastPurchaseDate
    FROM
        adi.ITEM_LOCATION il
        INNER JOIN adi.item it ON it.NO=il.ITEM_NO
        INNER JOIN core.location_mapping_setup lm ON lm.locationNo=il.LOCATION_NO
		INNER JOIN bc_rest_cus.item_extra_info iei ON iei.[NO] = it.NO
	--WHERE it.NO='HBJ3311043'



