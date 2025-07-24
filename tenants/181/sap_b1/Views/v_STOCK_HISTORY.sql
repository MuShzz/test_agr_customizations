CREATE VIEW [sap_b1_cus].[v_STOCK_HISTORY] AS
       SELECT
            CAST(TransNum AS NVARCHAR(255)) AS [TRANSACTION_ID],
            CAST(ItemCode AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(Warehouse AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(CreateDate AS DATE) AS [DATE],
            CAST((SUM(ISNULL(InQty, 0) - ISNULL(OutQty, 0))) AS DECIMAL(18, 4)) AS [STOCK_MOVE],
            CAST(NULL AS DECIMAL(18, 4)) AS [STOCK_LEVEL]
       FROM
            [sap_b1].OINM
	   GROUP BY
		    ItemCode, CreateDate, Warehouse, TransNum
	   HAVING CAST(SUM(ISNULL(InQty, 0) - ISNULL(OutQty, 0)) AS DECIMAL(18,4)) <> 0
