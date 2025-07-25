CREATE VIEW [cus].[v_BOM_CONSUMPTION_HISTORY] AS

    SELECT
		TRANSACTION_ID AS TRANSACTION_ID,
        [ITEM_NO],
        [LOCATION_NO],
        [DATE],
        CAST([UNIT_QTY] AS DECIMAL) AS UNIT_QTY
    FROM [cus].[BOM_CONSUMPTION_HISTORY]

