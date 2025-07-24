
CREATE VIEW [sap_b1_cus].[v_SALES_HISTORY] AS
SELECT
            CAST(o.TransNum AS BIGINT) AS [TRANSACTION_ID],
            CAST(o.ItemCode AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(o.Warehouse AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(o.DocDate AS DATE) AS [DATE],
            CAST(SUM(OutQty - o.InQty) AS DECIMAL(18,4)) AS [SALE],
            CAST(o.CardCode AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST(o.Ref1 AS NVARCHAR(255)) AS [REFERENCE_NO],
            CAST(0 AS BIT) AS [IS_EXCLUDED]
   FROM 
		[sap_b1].OINM o
	WHERE
		CAST(o.CreateDate AS DATE) >= '2020-01-01'
		AND [TransType] IN (13,14,15,16) 
	GROUP BY 
		o.ItemCode, o.DocDate, o.Warehouse, o.TransNum, o.CardCode, o.Ref1
	HAVING 
		SUM(OutQty - o.InQty) <> 0

