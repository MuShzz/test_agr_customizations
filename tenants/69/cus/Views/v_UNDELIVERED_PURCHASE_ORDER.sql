CREATE VIEW [cus].v_UNDELIVERED_PURCHASE_ORDER
AS
SELECT CAST(purchase_order_no AS varchar(128)) AS [PURCHASE_ORDER_NO],
       CAST(product_item_no AS nvarchar(255))  AS [ITEM_NO],
       CAST(location_no AS nvarchar(255))      AS [LOCATION_NO],
       CAST(delivery_date AS date)             AS [DELIVERY_DATE],
       CAST(quantity AS decimal(18, 4))        AS [QUANTITY]
FROM cus.purchase_order_line
where deliv_status = 0
