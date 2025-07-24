

-- ===============================================================================
-- Author:			Grétar Magnússon
-- Description:		Cus view 
--
-- 19.05.2025.GM	Removing variant codes
-- ===============================================================================

CREATE VIEW [bc_sql_cus].[v_UNDELIVERED_TRANSFER_ORDER] AS

	SELECT
		CAST([Document No_] + '_' + [Transfer-from Code] AS VARCHAR(128))   AS [TRANSFER_ORDER_NO],
		--CAST([Item No_] + CASE
		--						WHEN ISNULL([Variant Code], '') = '' THEN ''
		--						ELSE '-' + [Variant Code] END AS NVARCHAR(255)) AS [ITEM_NO],
		CAST([Item No_] AS NVARCHAR(255))									AS [ITEM_NO],
		CAST([Transfer-to Code] AS NVARCHAR(255))                           AS [LOCATION_NO],
		CAST([Transfer-from Code] AS NVARCHAR(255))                         AS [ORDER_FROM_LOCATION_NO],
		CAST(SUM([Outstanding Qty_ (Base)]) AS DECIMAL(18, 4))              AS [QUANTITY],
		CAST(IIF([Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(),
				[Receipt Date]) AS DATE)                                    AS DELIVERY_DATE,
		[company]                                                           AS [Company]
	FROM
		bc_sql.TransferLine
	WHERE
		[Outstanding Qty_ (Base)] > 0
	GROUP BY
		[Document No_], [Transfer-from Code], [Item No_], [Transfer-to Code],
		CAST(IIF([Receipt Date] = '1753-01-01 00:00:00.000', GETDATE(), [Receipt Date]) AS DATE), [company]
	HAVING
		SUM([Outstanding Qty_ (Base)]) > 0


