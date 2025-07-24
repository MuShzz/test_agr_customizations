


-- ===============================================================================
-- Author:      Paulo Marques
-- Description: stock history mapping from raw to adi, Orderwise
--
--  24.09.2024.TO   Altered
-- ===============================================================================


   CREATE VIEW [cus].[v_STOCK_HISTORY] AS
      


	
	SELECT TRANSACTION_ID,ITEM_NO,LOCATION_NO, DATE, STOCK_MOVE,CAST(NULL AS DECIMAL(18,4)) AS [STOCK_LEVEL]
	FROM (
		SELECT 
			main.[transaction_id],
			main.[ITEM_NO], 
			main.[LOCATION_NO], 
			main.[DATE], 
			SUM(main.[STOCK_MOVE]) AS STOCK_MOVE
		FROM (
			SELECT 
				CAST(CONCAT(vth.vth_id,vad.vad_id, CAST(DATEDIFF(DAY, '1899-12-30T00:00:00', vth.vth_transaction_datetime) AS INT)) AS BIGINT) AS [transaction_id],
				CAST(vad.vad_id AS NVARCHAR(266)) AS ITEM_NO, 
				CAST(vth.vth_sl_id AS NVARCHAR(255)) AS LOCATION_NO, 
				CAST(vth.vth_transaction_datetime AS DATE) AS DATE, 
				CAST(vth.vth_quantity AS DECIMAL(18,4)) AS STOCK_MOVE
			FROM 
				cus.variant_detail vad
			LEFT JOIN 
				cus.variant_transaction_header vth ON vth.vth_vad_id = vad.vad_id
			LEFT JOIN 
				cus.transaction_type tt ON tt.tt_id = vth.vth_tt_id
			WHERE 
				 vth.vth_tt_id IN (1,2,4,9,15,19)
        
			UNION ALL
        
			SELECT 
				CAST(CONCAT(vth.vth_id,vad.vad_id,CAST(DATEDIFF(DAY, '1899-12-30T00:00:00', vts.vts_datetime) AS INT)) AS BIGINT) AS [transaction_id],
				CAST(vad.vad_id AS NVARCHAR(255)) AS ITEM_NO, 
				CAST(vth.vth_sl_id AS NVARCHAR(255)) AS LOCATION_NO, 
				CAST(vts.vts_datetime AS DATE) AS DATE, 
				CAST((vts.vts_quantity * -1.0) AS DECIMAL(18,4)) AS STOCK_MOVE
			FROM 
				cus.variant_detail vad
			LEFT JOIN 
				cus.variant_transaction_header vth ON vth.vth_vad_id = vad.vad_id
			LEFT JOIN 
				cus.variant_transaction_split vts ON vts.vts_vth_id = vth.vth_id
			LEFT JOIN 
				cus.transaction_type tt ON tt.tt_id = vts.vts_tt_id
			WHERE 
				vts.vts_tt_id IN (3,5,8,10,11,13,16,20,21) 
      
		) AS main
		GROUP BY 
			main.[DATE], 
			main.[LOCATION_NO], 
			main.[ITEM_NO],
			main.[transaction_id]
	) AS main2
	WHERE main2.STOCK_MOVE <> 0 


