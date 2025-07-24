-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Purchase order mapping from sage200 to adi format
--
-- 10.01.2025.TO    Created
-- ===============================================================================
CREATE VIEW [sage200_sql_cus].[v_UNDELIVERED_PURCHASE_ORDER]
AS
 
    SELECT
        CAST(po.[document_no] AS NVARCHAR(128))         AS [PURCHASE_ORDER_NO],
        CAST(po.[lines-code] AS NVARCHAR(255))          AS [ITEM_NO],
        CAST(wh.[name] AS NVARCHAR(255))                AS [LOCATION_NO],
        CAST(SUM(po.[lines-line_quantity]-po.[lines-receipt_return_quantity]) AS DECIMAL(18,4)) AS [QUANTITY],
        MIN(CAST(ISNULL(po.[requested_delivery_date],po.[document_date]) AS DATE)) AS [DELIVERY_DATE]
    FROM 
        [sage200_sql_cus].[v_pop_orders] po
    INNER JOIN 
        [sage200_sql].[v_warehouses] wh ON wh.id = po.[lines-warehouse_id]
    WHERE 
        po.[document_status] = 'EnumDocumentStatusLive' AND po.[lines-line_type] = 'EnumLineTypeStandard' 
        AND (po.[lines-line_quantity]-po.[lines-receipt_return_quantity]) > 0 AND  po.analysis_code_5 <> 'YES'
    GROUP BY
        po.[document_no], wh.[name], po.[lines-code]

