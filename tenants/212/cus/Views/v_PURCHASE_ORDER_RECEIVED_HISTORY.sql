CREATE VIEW [cus].v_PURCHASE_ORDER_RECEIVED_HISTORY
             AS
            SELECT
               CAST(NULL AS varchar(128)) AS [PURCHASE_ORDER_NO],
               CAST(NULL AS varchar(128)) AS [AGR_ORDER_ID],
               CAST(NULL AS nvarchar(255)) AS [ITEM_NO],
               CAST(NULL AS nvarchar(255)) AS [LOCATION_NO],
               CAST(NULL AS nvarchar(255)) AS [VENDOR_NO],
               CAST(NULL AS date) AS [ORDER_DATE],
               CAST(NULL AS date) AS [DELIVERY_DATE],
               CAST(NULL AS decimal(18,4)) AS [ORDERED_QTY],
               CAST(NULL AS decimal(18,4)) AS [DELIVERED_QTY],
               CAST(NULL AS decimal(18,4)) AS [PURCHASE_PRICE],
               CAST(NULL AS int) AS [LEAD_TIME_CALCULATION_DAYS]
                WHERE 1 = 0;
