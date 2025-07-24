CREATE VIEW [cus].v_STOCK_LEVEL
             AS
SELECT CAST(product_item_no AS nvarchar(255)) AS [ITEM_NO],
       CAST(location_no AS nvarchar(255))     AS [LOCATION_NO],
       CAST(expire_date AS date)              AS [EXPIRE_DATE],
       CAST(stock_units AS decimal(18, 4))    AS [STOCK_UNITS]
FROM cus.stock_level
