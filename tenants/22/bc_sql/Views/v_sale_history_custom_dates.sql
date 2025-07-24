



-- ===============================================================================
-- Author:      José Mendes
-- Description: Sale aggregates for older dates - used in custom columns
--
-- 10.09.2019.TO    Created
-- ===============================================================================

CREATE VIEW [bc_sql_cus].[v_sale_history_custom_dates]
AS

    SELECT CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255)) AS PRODUCT_ITEM_NO,
               l.[Code] AS LOCATION_NO,
               ISNULL(sale_agg.SALE_QTY_18,0) AS SALE_QTY_18, 
               ISNULL(sale_agg.SALE_QTY_24,0) AS SALE_QTY_24,
               ISNULL(sale_agg.SALE_QTY_36,0) AS SALE_QTY_36,
               CAST(i.[Unit Price]*ISNULL(sale_agg.SALE_QTY_18,0) AS DECIMAL(18,2)) AS SALE_VALUE_18,
               CAST(i.[Unit Price]*ISNULL(sale_agg.SALE_QTY_24,0) AS DECIMAL(18,2)) AS SALE_VALUE_24,
               CAST(i.[Unit Price]*ISNULL(sale_agg.SALE_QTY_36,0) AS DECIMAL(18,2)) AS SALE_VALUE_36
          FROM [bc_sql].Item i
    LEFT JOIN [bc_sql].ItemVariant iv ON iv.[Item No_] = i.[No_]
    INNER JOIN bc_sql.Location l ON CAST(l.[Code] AS NVARCHAR(255)) IN ('HMV','MAIN')
    LEFT JOIN (
              SELECT CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS PRODUCT_ITEM_NO,
                     CAST(ile.[Location Code] AS NVARCHAR(255)) AS LOCATION_NO,
                     SUM(IIF(CAST(ile.[Posting Date] AS DATE) > DATEADD(MONTH,-18,CAST(GETDATE() AS DATE)), CAST(-ile.[Quantity] AS DECIMAL(18,4)), 0)) AS SALE_QTY_18,
                     SUM(IIF(CAST(ile.[Posting Date] AS DATE) > DATEADD(MONTH,-24,CAST(GETDATE() AS DATE)), CAST(-ile.[Quantity] AS DECIMAL(18,4)), 0)) AS SALE_QTY_24,
                     SUM(CAST(-ile.[Quantity] AS DECIMAL(18,4))) AS SALE_QTY_36
                FROM [bc_sql].ItemLedgerEntry ile
          INNER JOIN bc_sql.Item i ON ile.[Item No_] = i.[No_]
               WHERE CAST(ile.[Posting Date] AS DATE) > DATEADD(MONTH,-36,CAST(GETDATE() AS DATE))
                 AND ile.[Entry Type] = 1
            GROUP BY CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)), 
                     CAST(ile.[Location Code] AS NVARCHAR(255))) sale_agg
        ON sale_agg.PRODUCT_ITEM_NO = CAST(i.[No_] + CASE WHEN iv.[Code] IS NULL OR iv.[Code] = '' THEN '' ELSE '-' + iv.[Code] END AS NVARCHAR(255))
       AND sale_agg.LOCATION_NO = l.[Code]

