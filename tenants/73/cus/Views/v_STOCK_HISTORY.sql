

-- ===============================================================================
-- Author:      José Santos
-- Description: Customer mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================
    CREATE VIEW [cus].[v_STOCK_HISTORY] AS
       SELECT
            TransNum AS [TRANSACTION_ID],
            CAST(ItemCode AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(Warehouse AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(CreateDate AS DATE) AS [DATE],
            CAST(SUM(ISNULL(InQty, 0) - ISNULL(OutQty, 0)) AS DECIMAL(18,4)) AS [STOCK_MOVE],
            --CAST(SUM(SUM(ISNULL(InQty, 0) - ISNULL(OutQty, 0))) OVER (PARTITION BY itemcode, warehouse ORDER BY createdate) AS DECIMAL(18,4)) AS [STOCK_LEVEL],
			CAST(NULL AS DECIMAL(18,4)) AS STOCK_LEVEL
       FROM
			[cus].OINM
		GROUP BY
			ItemCode, CreateDate, Warehouse, TransNum
		HAVING CAST(SUM(ISNULL(InQty, 0) - ISNULL(OutQty, 0)) AS DECIMAL(18,4)) <> 0	

