CREATE VIEW [cus].v_VENDOR
             AS
            SELECT
        CAST(Supplier AS NVARCHAR(255)) AS [NO],
        CAST(SupplierName AS NVARCHAR(255)) AS [NAME],
        CAST(0 AS SMALLINT) AS LEAD_TIME_DAYS,
        CAST(PaymentIsBlockedForSupplier AS BIT) AS CLOSED
		--SELECT *
		FROM cus.suppliers
		

    --Vendor missing   
    UNION ALL

    SELECT
        CAST(N'vendor_missing' AS NVARCHAR(255)) AS [NO],
        CAST(N'Vendor missing' AS NVARCHAR(255)) AS [NAME],
        CAST(0 AS SMALLINT) AS LEAD_TIME_DAYS,
        CAST(0 AS BIT) AS CLOSED

    --Vendor closed
    UNION ALL

    SELECT
        CAST(N'vendor_closed' AS NVARCHAR(255)) AS [NO],
        CAST(N'Vendor closed' AS NVARCHAR(255)) AS [NAME],
        CAST(0 AS SMALLINT) AS LEAD_TIME_DAYS,
        CAST(0 AS BIT) AS CLOSED

