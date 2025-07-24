

-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

    CREATE VIEW [cus].[v_SALES_HISTORY] AS
       SELECT
            TransNum AS [TRANSACTION_ID],
            CAST(ItemCode AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(Warehouse AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(DocDate AS DATE) AS [DATE],
            CAST(SUM(IIF(TransType = 15, OutQty, 0)) - SUM(IIF(TransType IN (14,16), InQty, 0)) AS DECIMAL(18,4)) AS [SALE],
            CAST(o.CardCode AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(o.Ref1 AS NVARCHAR(255)) AS [REFERENCE_NO],
            CAST(0 AS BIT) AS [IS_EXCLUDED]
   FROM 
		[cus].OINM o
	INNER JOIN
		[cus].OCRD c ON c.CardCode = o.CardCode
	WHERE
		CAST(CreateDate AS DATE) >= '2020-01-01'
	GROUP BY 
		ItemCode, DocDate, Warehouse, TransNum, o.CardCode, Ref1
	HAVING 
		(SUM(IIF(TransType = 15, OutQty, 0)) - SUM(IIF(TransType IN (14,16), InQty, 0))) > 0

