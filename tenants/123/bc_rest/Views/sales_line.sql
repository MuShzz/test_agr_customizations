




CREATE VIEW [bc_rest_cus].[sales_line]
AS
    --ERP_BC_REST
    SELECT [DocumentType],
		   [DocumentNo],
		   [LineNo],
		   [Quantity],
		   [VariantCode],
		   [ItemReferenceNo],
		   [LocationCode],
		   [No],
		   [OutstandingQtyBase],
		   [PurchaseOrderNo],
		   [PurchOrderLineNo],
		   [ShipmentDate],
		   [DropShipment]
      FROM bc_rest.[sales_line]

    UNION ALL

	SELECT DISTINCT [Ledger_Entry_Type] AS [DocumentType],
		   [Ledger_Entry_No] AS [DocumentNo],
		   [Line_No] AS [LineNo],
		   [Quantity],
		   [Variant_Code] AS [VariantCode],
		   '' AS [ItemReferenceNo],
		   [Location_Code] AS [LocationCode],
		   [No] AS [No],
		   [Remaining_Qty] AS [OutstandingQtyBase],
		   '' AS [PurchaseOrderNo],
		   0 AS [PurchOrderLineNo],
		   [Planned_Delivery_Date] AS [ShipmentDate],
		   0 AS [DropShipment]
      FROM [bc_rest_cus].project_planning_lines
	  WHERE Document_No <> '' AND Line_No <> ''

