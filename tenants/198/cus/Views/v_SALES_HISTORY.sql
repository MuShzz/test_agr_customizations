
CREATE VIEW [cus].[v_SALES_HISTORY]
             AS
 SELECT
 CAST(NULL AS BIGINT) AS [TRANSACTION_ID],
 T.ITEM_NO AS ITEM_NO,
 T.LOCATION_NO AS LOCATION_NO,
 T.DATE AS DATE,
 SUM(ISNULL(T.SALE,0)) AS SALE,
 CAST('agr_no_customer' AS NVARCHAR(255)) AS [CUSTOMER_NO],
 CAST('' AS NVARCHAR(255)) AS [REFERENCE_NO],
 CAST(0 AS BIT) AS [IS_EXCLUDED]
 FROM 
 (

  SELECT
        CAST([Material] AS NVARCHAR(255)) AS ITEM_NO,
		CAST(Plant AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(dh.[DocumentDate] AS DATE) AS DATE,
		SUM(CAST([QuantityInBaseUnit] AS DECIMAL(18,4))) AS SALE

		FROM 
		cus.[DocumentItem] doci
		INNER JOIN [cus].[DocumentHeaders] dh ON dh.MaterialDocument=doci.materialdocument
		WHERE doci.GoodsMovementType IN ('601','621','961','633','997')
		AND doci.Plant NOT IN ('7090','7505')
		AND doci.StorageLocation NOT IN ('0002', '2')


		GROUP BY material, plant, dh.DocumentDate

		UNION ALL

		  SELECT
        CAST([Material] AS NVARCHAR(255)) AS ITEM_NO,
		CAST(Plant AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(dh.[DocumentDate] AS DATE) AS DATE,
		SUM(CAST([QuantityInBaseUnit] AS DECIMAL(18,4))) AS SALE

		FROM 

		cus.[DocumentItem] doci
		INNER JOIN [cus].[DocumentHeaders] dh ON dh.MaterialDocument=doci.materialdocument
		WHERE doci.GoodsMovementType IN ('601','621','961','633','997')
		AND doci.Plant='7090'
		GROUP BY material, plant, dh.DocumentDate

		UNION ALL

		SELECT
        CAST([Material] AS NVARCHAR(255)) AS ITEM_NO,
		CAST(Plant AS NVARCHAR(255)) AS LOCATION_NO,
		CAST(dh.[DocumentDate] AS DATE) AS DATE,
		SUM(CAST([QuantityInBaseUnit] AS DECIMAL(18,4))) AS SALE

		FROM 

		cus.[DocumentItem] doci
		INNER JOIN [cus].[DocumentHeaders] dh ON dh.MaterialDocument=doci.materialdocument
		WHERE doci.GoodsMovementType IN ('601','921')
		AND doci.Plant='7505'
		AND doci.StorageLocation<>'0002'
		AND ISNULL(doci.InventorySpecialStockType,'')=''
		GROUP BY material, plant, dh.DocumentDate


		) T
		GROUP BY
		T.ITEM_NO,
		T.LOCATION_NO,
		T.DATE






