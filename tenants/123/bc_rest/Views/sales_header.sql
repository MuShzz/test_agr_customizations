CREATE VIEW [bc_rest_cus].[sales_header]
AS

    SELECT distinct
			[Ledger_Entry_Type] AS [DocumentType],
			[Ledger_Entry_No] AS [No],
			[Location_Code] AS [LocationCode],
			'' AS [SelltoCustomerNo],
			MAX(Planned_Delivery_Date) AS [RequestedDeliveryDate],
			'0001-01-01 00:00:00' AS [PromisedDeliveryDate],
			'Open' AS [Status]
    FROM
        [bc_rest_cus].project_planning_lines s
    WHERE s.Location_Code <> '' AND [Document_No] <> ''
	GROUP BY [Ledger_Entry_Type], [Ledger_Entry_No], [Location_Code]

