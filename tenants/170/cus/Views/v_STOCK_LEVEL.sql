CREATE VIEW [cus].[v_STOCK_LEVEL]
AS

    SELECT 
        CAST(ITEM_NO AS NVARCHAR(255))              AS ITEM_NO,
        CAST(LOCATION_NO AS NVARCHAR(255))          AS LOCATION_NO,
        CAST(DATEFROMPARTS(2100, 1, 1) AS DATE)     AS EXPIRE_DATE,
        SUM(CAST(STOCK_UNITS AS DECIMAL(18,4)))     AS STOCK_UNITS
    FROM [cus].[STOCK_LEVEL]
	GROUP BY ITEM_NO, LOCATION_NO
