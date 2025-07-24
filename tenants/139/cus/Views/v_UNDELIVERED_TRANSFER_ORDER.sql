

    CREATE VIEW [cus].[v_UNDELIVERED_TRANSFER_ORDER] AS
       SELECT
        CAST([DocumentNo] + '_' + [TransferfromCode] AS NVARCHAR(128)) AS TRANSFER_ORDER_NO,
        CAST([ItemNo] + CASE WHEN ISNULL([VariantCode], '') = '' THEN '' ELSE '-' + [VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO],
        CAST([TransfertoCode] AS NVARCHAR(255)) AS LOCATION_NO,
        CAST([TransferfromCode] AS NVARCHAR(255)) AS ORDER_FROM_LOCATION_NO,
        CAST(SUM([OutstandingQtyBase]) AS DECIMAL(18,4)) AS QUANTITY,
        CAST(IIF([ReceiptDate]='0001-01-01 00:00:00.000', GETDATE(),[ReceiptDate]) AS DATE) AS DELIVERY_DATE,
		Company
    FROM
        cus.transfer_line
    WHERE
        [OutstandingQtyBase] > 0 
    GROUP BY
        [DocumentNo], [TransferfromCode], [ItemNo], [VariantCode], [TransfertoCode], Company, CAST(IIF([ReceiptDate]='0001-01-01 00:00:00.000', GETDATE(),[ReceiptDate]) AS DATE)
	HAVING SUM([OutstandingQtyBase]) > 0

