CREATE VIEW [cus].v_BLANKET_PURCHASE_ORDER
             AS
            SELECT
               CAST(NULL AS varchar(128)) AS [PURCHASE_ORDER_NO],
               CAST(NULL AS nvarchar(255)) AS [ITEM_NO],
               CAST(NULL AS nvarchar(255)) AS [LOCATION_NO],
               CAST(NULL AS date) AS [DELIVERY_DATE],
               CAST(NULL AS decimal(18,4)) AS [QUANTITY]
                WHERE 1 = 0;
