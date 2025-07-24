



-- ===============================================================================
-- Author:      JOSE, Jose e Paulo
-- Description: Customer sale transaction mapping
--
--  20.09.2024.TO   Created
-- ===============================================================================

    CREATE VIEW [cus].[v_SALES_HISTORY] AS

	WITH DateConverted AS (
    SELECT 
        [dh_datetime],
        CONVERT(VARCHAR, CAST([dh_datetime] AS DATE), 112) AS [oh_date],
        [oli_vad_id],
        [oli_sl_id],
        [oli_qty_required],
		[oh_cd_id],
		[oh_order_number]
    FROM cus.Sales_History
	)
       SELECT
            CAST(CONCAT([oh_date], 100000000 + (ROW_NUMBER() OVER (PARTITION BY [oh_date] ORDER BY [dh_datetime], [oli_vad_id], [oli_sl_id]))) AS NVARCHAR(255)) AS [TRANSACTION_ID],
            CAST(oli_vad_id AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(oli_sl_id AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST([dh_datetime] AS DATE) AS [DATE],
            CAST(oli_qty_required AS DECIMAL(18, 4)) AS [SALE],
            CAST(oh_cd_id AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(oh_order_number AS NVARCHAR(255)) AS [REFERENCE_NO],
            CAST(0 AS BIT) AS [IS_EXCLUDED]
       FROM DateConverted;


