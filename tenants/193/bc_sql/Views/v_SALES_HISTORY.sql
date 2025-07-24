CREATE VIEW [bc_sql_cus].[v_SALES_HISTORY] AS
	
	SELECT
			CAST(NULL AS BIGINT) AS [TRANSACTION_ID],
			CAST(ile.[Item No_] + CASE
                                       WHEN ISNULL(ile.[Variant Code], '') = '' THEN ''
                                       ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO],
             CAST(ile.[Location Code] AS NVARCHAR(255))                                    AS [LOCATION_NO],
             CAST(ile.[Posting Date] AS DATE)                                              AS [DATE],
             CAST(SUM(IIF(ile.[Entry Type] = 1, -ile.[Quantity], 0)) AS DECIMAL(18, 4))    AS [SALE],
             CAST(ISNULL(c.[No_], 'agr_no_customer') AS NVARCHAR(255))                     AS [CUSTOMER_NO],
             ISNULL(ssh.[Order No_], '')                                                   AS [REFERENCE_NO],
             CAST(0 AS BIT)                                                                AS [IS_EXCLUDED]
      FROM bc_sql.ItemLedgerEntry ile
               LEFT JOIN bc_sql.SalesShipmentHeader ssh
                         ON ssh.[No_] = ile.[Document No_] and ile.[company] = ssh.[company]
               LEFT JOIN bc_sql.Customer c ON c.[No_] = ile.[Source No_] and ile.[company] = c.[company]
               JOIN core.setting s ON s.settingKey = 'sale_history_retention_years'
               JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[Location Code]
      WHERE ile.[Entry Type] = 1
        AND CAST(ile.[Posting Date] AS DATE) > DATEADD(YEAR, -CAST(s.settingValue AS INT), CAST(GETDATE() AS DATE))
		AND [Document No_] NOT LIKE 'SIP%' and [Document No_] NOT LIKE 'SCP%' --don't want Sales invoices or Sales Credit Memo
      GROUP BY 
               ile.[Item No_],
               ile.[Variant Code],
               ile.[Location Code],
               ile.[Posting Date],
               c.[No_],
               ssh.[Order No_]

