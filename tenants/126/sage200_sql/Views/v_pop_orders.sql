CREATE VIEW [sage200_sql_cus].[v_pop_orders]
AS

    SELECT 
        CAST(PORL.POPOrderReturnID                              AS BIGINT)          AS [id], 
        CAST(PORL.POPOrderReturnLineID                          AS BIGINT)          AS [lines-id],  
        CAST(POR.DocumentNo                                     AS NVARCHAR(30))    AS [document_no], 
        CAST(POR.DocumentDate                                   AS DATETIME)        AS [document_date], 
        CAST('EnumDocumentStatusLive'                           AS NVARCHAR(30))    AS [document_status],
        CAST(POR.SupplierDocumentNo                             AS NVARCHAR(100))   AS [supplier_document_no], 
        CAST(POR.RequestedDeliveryDate                          AS DATETIME)        AS [requested_delivery_date], 
        CAST(PORL.PrintSequenceNumber                           AS INT)             AS [lines-line_number], 
        CASE WHEN LineTypeID = 0 THEN 'EnumLineTypeStandard'
            WHEN LineTypeID = 1 THEN 'EnumLineTypeFreeText'
            WHEN LineTypeID = 2 THEN 'EnumLineTypeCharge' 
            WHEN LineTypeID = 3 THEN 'EnumLineTypeComment' END                      AS [lines-line_type], 
        CAST(PORL.ItemCode                                      AS NVARCHAR(40))    AS [lines-code], 
        CAST(PORL.LineQuantity                                  AS DECIMAL(15, 5))  AS [lines-line_quantity],
        CAST(PORL.ReceiptReturnQuantity                         AS DECIMAL(15, 5))  AS [lines-receipt_return_quantity], 
        CAST(PORL.InvoiceCreditQuantity                         AS DECIMAL(15, 5))  AS [lines-invoice_credit_quantity],
        CAST(PORL.BuyingUnitDescription                         AS NVARCHAR(60))    AS [lines-buying_unit_description], 
        CAST(POR.SupplierID                                     AS BIGINT)          AS [supplier_id], 
        CAST(si.ItemID                                          AS BIGINT)          AS [lines-product_id], 
        CAST(PORL.WarehouseID                                   AS BIGINT)          AS [lines-warehouse_id],
        CAST(POR.AnalysisCode5                                  AS NVARCHAR(30))    AS [analysis_code_5]
    FROM 
        [sage200_sql].[POPOrderReturnLine] PORL 
    INNER JOIN 
        [sage200_sql].[POPOrderReturn]  POR  ON POR.POPOrderReturnID = PORL.POPOrderReturnID
    INNER JOIN 
        [sage200_sql].[StockItem] si ON PORL.ItemCode = si.Code 
