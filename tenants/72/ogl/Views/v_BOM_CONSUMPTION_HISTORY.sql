

CREATE VIEW [ogl_cus].[v_BOM_CONSUMPTION_HISTORY] AS
    SELECT
        ROW_NUMBER() OVER (ORDER BY trdate, stcode, depot) AS [TRANSACTION_ID],
        CAST(stcode AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(depot AS NVARCHAR(255)) AS [LOCATION_NO],
        CAST(trdate AS DATE) AS [DATE],
        CAST(SUM(-CAST(amnt AS DECIMAL(18,4))) AS DECIMAL(18,4)) AS [UNIT_QTY]
    FROM [ogl].STStockMovements 
    WHERE mtype = 'ISS' AND (mref LIKE 'ORD%' OR mref LIKE 'WO%')
    GROUP BY uniqueno, stcode, depot, trdate

