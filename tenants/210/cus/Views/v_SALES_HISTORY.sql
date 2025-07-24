CREATE VIEW [cus].v_SALES_HISTORY AS
    
	SELECT
        CAST(NULL AS bigint)                                                    AS [TRANSACTION_ID],
        CAST(cid.ItemCode AS nvarchar(255))                                     AS [ITEM_NO],
        CAST(cid.WarehouseCode AS nvarchar(255))                                AS [LOCATION_NO],
        CAST(ci.InvoiceDate AS date)                                            AS [DATE],
        CAST(CASE WHEN ci.Type='Credit Memo' 
                        THEN SUM(-cid.QuantityShipped*cid.UnitMeasureQty)
				  ELSE SUM(cid.QuantityShipped*cid.UnitMeasureQty) END 
             AS decimal(18,4))                                                  AS [SALE],
        CAST(ci.BillToCode AS nvarchar(255))                                    AS [CUSTOMER_NO],
        CAST(ci.InvoiceCode AS nvarchar(255))                                   AS [REFERENCE_NO],
        CAST(0 AS bit)                                                          AS [IS_EXCLUDED]
	FROM cus.CustomerInvoice ci
        INNER JOIN cus.CustomerInvoiceDetail cid        ON cid.InvoiceCode=ci.InvoiceCode
        INNER JOIN core.location_mapping_setup lms      ON lms.locationNo=cid.WarehouseCode
	WHERE ci.IsVoided<>1 --excluding voided sales
	--AND cid.ItemCode='ITEM-005395'
	GROUP BY 
		cid.ItemCode,
		cid.WarehouseCode,
		ci.InvoiceDate,
		ci.BillToCode,
		ci.InvoiceCode,
		ci.Type
