








-- ===============================================================================
-- Author:      HMH
-- Description: Calculation of margin and margin percentage for custom columns
--
--  2024-08-12: HMH Created
-- ===============================================================================
CREATE VIEW [nav_cus].[v_custom_column_margin]
AS
	SELECT 
		sub.[itemNo]
		,sub.[locationNo]
		,LEFT(sub.MARGIN,255) AS margin
		,LEFT(sub.MARGIN_PERCENTAGE,255) AS margin_percentage
	FROM 
	(
		SELECT DISTINCT
			aei.itemNo,
			aei.locationNo,
			SUM(IIF([Entry Type] IN (1, 4) AND [Location Code] = 'G0001', (-ile.[Quantity] * (i.[Unit Price] - i.[Unit Cost])), 0)) AS MARGIN,
		CASE 
			WHEN i.[Unit Cost] = 0 
				OR SUM(IIF([Entry Type] IN (1, 4) AND [Location Code] = 'G0001', -ile.[Quantity], 0)) = 0 
				OR SUM(IIF([Entry Type] IN (1, 4) AND [Location Code] = 'G0001', (-ile.[Quantity] * (i.[Unit Price])), 0)) = 0 
			THEN 0 
			ELSE (
				(SUM(IIF([Entry Type] IN (1, 4) AND [Location Code] = 'G0001', (-ile.[Quantity] * (i.[Unit Price] - i.[Unit Cost])), 0))) / 
				(SUM(IIF([Entry Type] IN (1, 4) AND [Location Code] = 'G0001', (-ile.[Quantity] * (i.[Unit Price])), 0)))
			) * 100 
		END AS MARGIN_PERCENTAGE
		FROM [dbo].[AGREssentials_items] aei
		LEFT JOIN nav.ItemLedgerEntry ile ON aei.itemNo = ile.[Item No_]
		LEFT JOIN nav.Item i on i.No_ = ile.[Item No_]
		WHERE [Posting Date] > (GETDATE() - 365)
		GROUP BY aei.itemNo, aei.locationNo, i.[Unit Cost]
	) sub


