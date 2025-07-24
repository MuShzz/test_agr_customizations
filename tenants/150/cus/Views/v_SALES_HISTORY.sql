
CREATE VIEW [cus].[v_SALES_HISTORY] AS
       SELECT
		CAST(CONCAT(CONVERT(VARCHAR, CAST([DATE] AS DATE), 112),100000000+(ROW_NUMBER() OVER (PARTITION BY [DATE] ORDER BY MODIFIEDDATETIME))) AS BIGINT)	AS TRANSACTION_ID,
		CAST(t.ITEM_NO AS NVARCHAR(255))																													AS [ITEM_NO],
		CAST(t.LOCATION_NO AS NVARCHAR(255))																												AS LOCATION_NO,
		CAST(t.DATE AS DATE) 																																AS [DATE],
		CAST(t.SALE AS DECIMAL(18, 4))																														AS SALE,
		CAST(t.CUSTOMER_NO AS NVARCHAR(255))																															AS [CUSTOMER_NO],
        CAST('' AS NVARCHAR(255))																															AS [REFERENCE_NO],
        CAST(0 AS BIT)																																		AS [IS_EXCLUDED]


			
	FROM (
			SELECT 
				CAST(IIF(sii.[$Product.Code] IS NULL, '',sii.[$Product.Code]) AS NVARCHAR(255)) AS [ITEM_NO],
				CAST(si.[Branch.Code] AS NVARCHAR(255)) AS [LOCATION_NO],
				CAST(si.Date AS DATE) AS [DATE],
				CAST(SUM(sii.[$Quantity]) AS DECIMAL(18, 4)) AS [SALE],
				CAST(si.[DeliveryAccount.Code] AS NVARCHAR(255)) AS [CUSTOMER_NO],
				CAST('' AS NVARCHAR(255)) AS [REFERENCE_NO],
				CAST(0 AS BIT) AS [IS_EXCLUDED],
				MAX(si.UpdatedOn)					AS MODIFIEDDATETIME
			FROM cus.SalesInvoice si
			LEFT JOIN cus.SalesInvoiceItems sii ON si.ID = sii.ID
			WHERE si.[$Items] != '[]' AND CAST(si.Date AS DATE) >= '2022-05-01'
			GROUP BY si.Number, sii.[$Product.Code],si.[Branch.Code],si.[DeliveryAccount.Code],si.Date,si.[$Items],sii.[$ID]
			) t 

