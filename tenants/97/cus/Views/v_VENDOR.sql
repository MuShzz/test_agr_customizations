



-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

    CREATE VIEW [cus].[v_VENDOR] AS
	WITH erp_vendor
	AS
	(
		--ERP_BC_REST
		SELECT DISTINCT
			v.[No_] + '-' + v.Company AS [NO],
			ISNULL(NULLIF(v.[Name],''), v.[No_]  + ' (name missing)') +'-' + v.Company AS [NAME],
			ISNULL(
				(CASE WHEN ISNUMERIC(REPLACE([Process Period], CHAR(2), '')) = 1 THEN CAST(REPLACE([Process Period], '', '') AS INT) ELSE 0 END) +
				(CASE WHEN ISNUMERIC(REPLACE([Transport Period], CHAR(2), '')) = 1 THEN CAST(REPLACE([Transport Period], '', '') AS INT) ELSE 0 END) +
				(CASE WHEN ISNUMERIC(REPLACE([Receipt Period], CHAR(2), '')) = 1 THEN CAST(REPLACE([Receipt Period], '', '') AS INT) ELSE 0 END)
				,0 ) 
			AS LEAD_TIME_DAYS,
			CAST(IIF(v.[Blocked] = '',0,1) AS BIT) AS CLOSED,
            v.Company
		FROM
			[cus].Vendor v
			--LEFT JOIN [erp_raw].v_vendor_last_transaction t ON v.No = t.vendor_no AND t.company = v.Company
		WHERE
			IIF(v.[Blocked] = '',0,1) IN (0, (SELECT ~CAST('false' AS BIT)))
			AND v.Company = 'BLI'
			AND v.No_ NOT IN ('V-LAN','V-HYU','V-IVF')

		UNION ALL

       SELECT DISTINCT
			v.[No_] + '-' + v.Company AS [NO],
			ISNULL(NULLIF(v.[Name],''), v.[No_]  + ' (name missing)') +'-' + v.Company AS [NAME],
			ISNULL(
				(CASE WHEN ISNUMERIC(REPLACE([Process Period], CHAR(2), '')) = 1 THEN CAST(REPLACE([Process Period], '', '') AS INT) ELSE 0 END) +
				(CASE WHEN ISNUMERIC(REPLACE([Transport Period], CHAR(2), '')) = 1 THEN CAST(REPLACE([Transport Period], '', '') AS INT) ELSE 0 END) +
				(CASE WHEN ISNUMERIC(REPLACE([Receipt Period], CHAR(2), '')) = 1 THEN CAST(REPLACE([Receipt Period], '', '') AS INT) ELSE 0 END)
				,0 ) 
			AS LEAD_TIME_DAYS,
			CAST(IIF(v.[Blocked] = '',0,1) AS BIT) AS CLOSED,
            v.Company
		FROM
			[cus].Vendor v
			--LEFT JOIN [erp_raw].v_vendor_last_transaction t ON v.No = t.vendor_no AND t.company = v.Company
		WHERE
			IIF(v.[Blocked] = '',0,1) IN (0, (SELECT ~CAST('false' AS BIT)))
			AND v.Company = 'HYU'
			AND v.No_ NOT IN ('V-BMW','V-REN','V-NIS','V-SUB','V-MG','V-HONGQI','V-LAN')

		UNION ALL

		SELECT DISTINCT
			v.[No_] + '-' + v.Company AS [NO],
			ISNULL(NULLIF(v.[Name],''), v.[No_]  + ' (name missing)') +'-' + v.Company AS [NAME],
			ISNULL(
				(CASE WHEN ISNUMERIC(REPLACE([Process Period], CHAR(2), '')) = 1 THEN CAST(REPLACE([Process Period], '', '') AS INT) ELSE 0 END) +
				(CASE WHEN ISNUMERIC(REPLACE([Transport Period], CHAR(2), '')) = 1 THEN CAST(REPLACE([Transport Period], '', '') AS INT) ELSE 0 END) +
				(CASE WHEN ISNUMERIC(REPLACE([Receipt Period], CHAR(2), '')) = 1 THEN CAST(REPLACE([Receipt Period], '', '') AS INT) ELSE 0 END)
				,0 ) 
			AS LEAD_TIME_DAYS,
			CAST(IIF(v.[Blocked] = '',0,1) AS BIT) AS CLOSED,
            v.Company
		FROM
			[cus].Vendor v
			--LEFT JOIN [erp_raw].v_vendor_last_transaction t ON v.No = t.vendor_no AND t.company = v.Company
		WHERE
			IIF(v.[Blocked] = '',0,1) IN (0, (SELECT ~CAST('false' AS BIT)))
			AND v.Company = 'JLR'
			AND v.No_ NOT IN ('V-BMW','V-REN','V-NIS','V-SUB','V-MG','V-HONGQI','V-HYU','V-IVF')

			--AND v.[Purchaser Code] = 'AGR'
			--AND ISNULL(t.last_order_date,'1900-01-01') >= (SELECT DATEADD(MONTH, -(SELECT CAST(core.get_setting_value('data_mapping_bc_vendors_stale_vendor_retention_months') AS INT)) , SYSDATETIME()))


	)
	SELECT ev.[NO]
		  ,ev.[NAME]
		  ,ev.[LEAD_TIME_DAYS] AS [LEAD_TIME_DAYS]
		  ,ev.[CLOSED]
          ,ev.Company 
	FROM erp_vendor ev


	--Vendor missing   
	UNION ALL

	SELECT
		CAST(N'vendor_missing' AS NVARCHAR(255)) AS [NO],
		CAST(N'Vendor missing' AS NVARCHAR(255)) AS [NAME],
		CAST(0 AS SMALLINT) AS LEAD_TIME_DAYS,
		CAST(0 AS BIT) AS CLOSED,
        CAST('BLI' AS CHAR(3)) AS COMPANY
	--Vendor closed
	UNION ALL

	SELECT
		CAST(N'vendor_closed' AS NVARCHAR(255)) AS [NO],
		CAST(N'Vendor closed' AS NVARCHAR(255)) AS [NAME],
		CAST(0 AS SMALLINT) AS LEAD_TIME_DAYS,
		CAST(0 AS BIT) AS CLOSED,
        CAST('BLI' AS CHAR(3)) AS COMPANY


