

-- ===============================================================================
-- Author:      Paulo Marques
-- Description: transfer history mapping from raw to adi, Orderwise
--
--  24.09.2024.TO   Altered
-- ===============================================================================


    CREATE VIEW [cus].[v_TRANSFER_HISTORY] AS

	SELECT
            CAST(NULL AS BIGINT) AS [TRANSACTION_ID],
            CAST(NULL AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(NULL AS NVARCHAR(255)) AS [FROM_LOCATION_NO],
            CAST(NULL AS NVARCHAR(255)) AS [TO_LOCATION_NO],
            CAST(NULL AS DATE) AS [DATE],
            CAST(NULL AS DECIMAL(18, 4)) AS [TRANSFER]
       WHERE 1 = 0;
	-- old view for customer sales transaction no tranfers
   --    SELECT
   --         CAST(vts.vts_id AS BIGINT) AS [TRANSACTION_ID],
   --         CAST(vad.vad_id AS NVARCHAR(255)) AS [ITEM_NO],
   --         CAST(vth.vth_sl_id AS NVARCHAR(255)) AS [FROM_LOCATION_NO],
   --         CAST(NULL AS NVARCHAR(255)) AS [TO_LOCATION_NO],
   --         CAST(vts.vts_datetime AS DATE) AS [DATE],
   --         CAST(0 AS DECIMAL(18, 4)) AS [TRANSFER]
   --    FROM 
			--	cus.variant_detail vad
			--LEFT JOIN 
			--	cus.variant_transaction_header vth ON vth.vth_vad_id = vad.vad_id
			--LEFT JOIN 
			--	cus.variant_transaction_split vts ON vts.vts_vth_id = vth.vth_id
			--LEFT JOIN 
			--	cus.transaction_type tt ON tt.tt_id = vts.vts_tt_id
			--WHERE 
			--	tt.tt_id = 8 


