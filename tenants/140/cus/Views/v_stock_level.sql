CREATE VIEW [cus].[v_stock_level]
AS

    SELECT
            CAST(CONCAT(RTRIM(ITEMNMBR), ' - ', [Company]) AS NVARCHAR(255))        AS [ITEM_NO],
            CAST(LOCNCODE AS NVARCHAR(255))                                         AS [LOCATION_NO],
            CAST(DATEFROMPARTS(2100, 1, 1) AS DATE)                                 AS [EXPIRE_DATE],
            SUM(CAST(QTYONHND AS DECIMAL(18, 4)))                                   AS [STOCK_UNITS],
            NULL AS [Company]
    FROM
        [cus].[IV00102]
	GROUP BY ITEMNMBR, LOCNCODE, [Company] 



