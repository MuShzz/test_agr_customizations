create VIEW [bc_sql_cus].[v_STOCK_LEVEL] AS
     SELECT
        CAST(ile.[Item No_] + CASE WHEN ISNULL([Variant Code], '') = '' THEN '' ELSE '-' + [Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(ile.[Location Code] AS NVARCHAR(255)) AS [LOCATION_NO],
        --CAST(IIF(ile.[Expiration Date]='1753-01-01 00:00:00.0000000', DATEFROMPARTS(2100, 1, 1),ile.[Expiration Date]) AS DATE) AS EXPIRE_DATE,
		CAST(DATEFROMPARTS(2100, 1, 1) AS DATE) AS EXPIRE_DATE,
        CAST(SUM(ile.[Quantity]) AS DECIMAL(18,4)) AS [STOCK_UNITS]
    FROM
        [bc_sql].ItemLedgerEntry ile
        JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[Location Code]
    GROUP BY
        ile.[Item No_], ile.[Variant Code], ile.[Location Code]--, ile.[Expiration Date]
    HAVING SUM(ile.Quantity)<>0


