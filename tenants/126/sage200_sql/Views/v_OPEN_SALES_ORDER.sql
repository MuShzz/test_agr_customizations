-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Open Sales Orders mapping from sage200 to adi format
--
-- 10.01.2025.TO    Created
-- ===============================================================================
CREATE VIEW [sage200_sql_cus].[v_OPEN_SALES_ORDER]
AS
 
    SELECT
        CAST([sop_order_document_no]+'-'+[warehouse_name] AS NVARCHAR(128))             AS [SALES_ORDER_NO],
        CAST([product_code] AS NVARCHAR(255))                                           AS [ITEM_NO],
        CAST([warehouse_name] AS NVARCHAR(255))                                         AS [LOCATION_NO],
        CAST(SUM([sop_order_line_quantity]-[sop_order_line_despatch_receipt_quantity])  AS DECIMAL(18,4)) AS [QUANTITY],
        CAST([customer_reference] AS NVARCHAR(255))                                     AS [CUSTOMER_NO],
        CAST(COALESCE([sop_order_line_promised_delivery_date], 
            [sop_order_line_requested_delivery_date], 
            [sop_order_document_date]) AS DATE)                                         AS [DELIVERY_DATE]
    FROM
        [sage200_sql].[v_sop_order_line_views]
    WHERE
        [sop_order_line_type] = 0 AND [sop_order_document_status] IN (0,1) AND [sop_order_line_quantity] - [sop_order_line_despatch_receipt_quantity] > 0
		AND customer_reference <>'207818'
    GROUP BY
        CAST([sop_order_document_no]+'-'+[warehouse_name] AS NVARCHAR(128))
        , [product_code]
        , [warehouse_name]
        , [customer_reference]
        , COALESCE([sop_order_line_promised_delivery_date]
        , [sop_order_line_requested_delivery_date]
        , [sop_order_document_date])
    
    UNION ALL

    SELECT
        CAST('ALLOC-'+pv.code+'-'+wh.warehouse_name AS NVARCHAR(128))   AS [SALES_ORDER_NO],
        CAST(pv.code AS NVARCHAR(255))                                AS [ITEM_NO],
        CAST(wh.warehouse_name AS NVARCHAR(255))                      AS [LOCATION_NO],
        CAST(wh.quantity_allocated_stock  AS DECIMAL(18,4))             AS [QUANTITY],
        CAST(NULL AS NVARCHAR(255))                                     AS [CUSTOMER_NO],
        CAST(GETDATE() AS DATE)                                         AS [DELIVERY_DATE]
    FROM 
        [sage200_sql].[v_warehouse_holdings] wh
    INNER JOIN 
        [sage200_sql].[v_product_views] pv ON pv.id = wh.product_id
    WHERE 
        pv.traceable_type_id = 0 AND wh.quantity_allocated_stock <> 0



