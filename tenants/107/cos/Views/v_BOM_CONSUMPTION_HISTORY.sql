CREATE VIEW [cos_cus].[v_BOM_CONSUMPTION_HISTORY] AS
	SELECT
        ROW_NUMBER() over (order by date, item_no, location_no) AS [TRANSACTION_ID],
        [ITEM_NO],
        [LOCATION_NO],
        CAST([DATE] as date) AS [DATE],
        [UNIT_QTY]
    FROM [cos_cus].[AGR_BOM_CONSUMPTION_HISTORY]
