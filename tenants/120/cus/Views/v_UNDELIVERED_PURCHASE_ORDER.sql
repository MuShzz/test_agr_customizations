



-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

    CREATE VIEW [cus].[v_UNDELIVERED_PURCHASE_ORDER] AS
       SELECT
            CAST(p.DocNum AS VARCHAR(128)) AS [PURCHASE_ORDER_NO],
            CAST(pl.ItemCode AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(pl.WhsCode AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(p.DocDueDate AS DATE) AS [DELIVERY_DATE],
            CAST(SUM(pl.OpenInvQty) AS DECIMAL(18, 4)) AS [QUANTITY]
       FROM
			[cus].POR1 pl
			INNER JOIN [cus].OPOR p ON p.DocEntry = pl.DocEntry
		WHERE
			pl.LineStatus = 'O' AND pl.ItemCode IS NOT NULL AND pl.WhsCode IS NOT NULL
		GROUP BY
			p.DocNum, pl.ItemCode, p.DocDueDate, pl.WhsCode



