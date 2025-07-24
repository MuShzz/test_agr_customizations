

    CREATE VIEW [cus].[v_STOCK_HISTORY] AS
	SELECT 
 
         
		 ROW_NUMBER() OVER ( ORDER BY TransNum, ItemCode, Warehouse, CreateDate ) AS TRANSACTION_ID,
        CAST(ItemCode AS NVARCHAR(255)) AS ITEM_NO,
        CAST(Warehouse AS NVARCHAR(255)) AS LOCATION_NO,
        CAST(CreateDate AS DATE) AS [DATE],
        CAST(SUM(ISNULL(InQty, 0) - ISNULL(OutQty, 0)) AS DECIMAL(18,4)) AS STOCK_MOVE,
        --CAST(NULL AS DECIMAL(18,4)) AS STOCK_LEVEL,
		CAST(SUM(SUM(ISNULL(InQty, 0) - ISNULL(OutQty, 0))) OVER (PARTITION BY itemcode, warehouse ORDER BY createdate) AS DECIMAL(18,4)) AS STOCK_LEVEL
    FROM
        [cus].OINM
	--where ItemCode = '15PADOA6' and Warehouse = '001'
	--WHERE	
		--CAST(CreateDate AS DATE) >= '2020-01-01' --AND TransType = 20'
	GROUP BY
		ItemCode, CreateDate, Warehouse, TransNum
	HAVING CAST(SUM(ISNULL(InQty, 0) - ISNULL(OutQty, 0)) AS DECIMAL(18,4)) <> 0 


