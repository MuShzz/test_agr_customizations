

CREATE VIEW [cus].[v_BOM_CONSUMPTION_HISTORY] AS


    WITH DateConverted AS (
    SELECT 
        [vts_datetime],
        CONVERT(VARCHAR, CAST([vts_datetime] AS DATE), 112) AS [vts_date],
        [vth_vad_id],
        [vth_sl_id],
        [vts_quantity]
    FROM cus.BOM_Consumption_History
	)
    SELECT
			CAST(CONCAT([vts_date], 100000000 + (ROW_NUMBER() OVER (PARTITION BY [vts_date] ORDER BY [vts_datetime], [vth_vad_id], [vth_sl_id]))) AS BIGINT) AS TRANSACTION_ID,
			CAST(vth_vad_id AS NVARCHAR(255))		AS ITEM_NO,
			CAST(vth_sl_id AS NVARCHAR(255))		AS LOCATION_NO,
			CAST([vts_datetime] AS DATE)			AS [DATE],
			CAST(vts_quantity AS DECIMAL(18,4))		AS [UNIT_QTY]
	FROM DateConverted;


