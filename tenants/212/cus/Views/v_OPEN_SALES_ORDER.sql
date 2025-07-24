CREATE VIEW [cus].v_OPEN_SALES_ORDER
             AS
            SELECT
               CAST(NULL AS nvarchar(128)) AS [SALES_ORDER_NO],
               CAST(NULL AS nvarchar(255)) AS [ITEM_NO],
               CAST(NULL AS nvarchar(255)) AS [LOCATION_NO],
               CAST(NULL AS decimal(18,4)) AS [QUANTITY],
               CAST(NULL AS nvarchar(255)) AS [CUSTOMER_NO],
               CAST(NULL AS date) AS [DELIVERY_DATE]
                WHERE 1 = 0;
