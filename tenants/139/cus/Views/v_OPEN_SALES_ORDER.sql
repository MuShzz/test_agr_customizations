

    CREATE VIEW [cus].[v_OPEN_SALES_ORDER] AS
       SELECT
            CAST([DocumentNo] AS NVARCHAR(128)) AS [SALES_ORDER_NO],
            CAST([No] + CASE WHEN ISNULL([VariantCode], '') = '' THEN '' ELSE '-' + [VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO],
            CAST([LocationCode] AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST(SUM([OutstandingQtyBase]) AS DECIMAL(18,4)) AS [QUANTITY],
            CAST(NULL AS NVARCHAR(255)) AS [CUSTOMER_NO],
            CAST([ShipmentDate] AS DATE) AS [DELIVERY_DATE],
			[Company]
       FROM
        [cus].sales_line
    WHERE
        [DocumentType] = 'Order'
        AND [DropShipment] = 0
    GROUP BY
        [DocumentNo], [No], [VariantCode], [LocationCode], [ShipmentDate], [Company]
    having SUM(CAST([OutstandingQtyBase] AS DECIMAL(18,4))) <> 0

