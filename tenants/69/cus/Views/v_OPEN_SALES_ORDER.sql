CREATE VIEW [cus].v_OPEN_SALES_ORDER
AS
SELECT CAST(sol.sales_order_no AS nvarchar(128))  AS [SALES_ORDER_NO],
       CAST(sol.product_item_no AS nvarchar(255)) AS [ITEM_NO],
       CAST(sol.location_no AS nvarchar(255))     AS [LOCATION_NO],
       CAST(sol.quantity AS decimal(18, 4))       AS [QUANTITY],
       CAST(so.customer_no AS nvarchar(255))      AS [CUSTOMER_NO],
       CAST(so.delivery_date AS date)             AS [DELIVERY_DATE]
FROM [cus].sales_order_line sol
         INNER JOIN cus.sales_order so on sol.sales_order_no = so.no
