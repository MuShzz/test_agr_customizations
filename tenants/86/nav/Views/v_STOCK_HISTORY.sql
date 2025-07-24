-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Stock transactions from nav to adi format
--
-- 09.10.2024.TO    Created
-- 07.03.2025.BF	added filtering on nav.v_item to reduce the items based on settings like exclude closed items
-- ===============================================================================
create VIEW [nav_cus].[v_STOCK_HISTORY]
AS


   SELECT
        CAST([Entry No_] AS NVARCHAR(255)) AS [TRANSACTION_ID],
        CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(ile.[Location Code] AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(ile.[Posting Date] AS DATE) AS [DATE],
        CAST(SUM([Quantity]) AS DECIMAL(18, 4)) AS [STOCK_MOVE],
        CAST(NULL AS DECIMAL(18,4)) AS STOCK_LEVEL
    FROM
        nav.ItemLedgerEntry ile
        JOIN core.location_mapping_setup lm ON lm.locationNo = ile.[Location Code] --AND include = 1
	WHERE EXISTS (
		SELECT 1 FROM nav_cus.v_item i WHERE i.NO = CAST(ile.[Item No_] + CASE WHEN ISNULL(ile.[Variant Code], '') = '' THEN '' ELSE '-' + ile.[Variant Code] END AS NVARCHAR(255)))
    GROUP BY
          [Entry No_],[Item No_], [Variant Code], [Location Code], CAST([Posting Date] AS DATE)


