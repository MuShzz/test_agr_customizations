


-- ===============================================================================
-- Author:      José Sucena
-- Description: UNDELIVERED_TRANSFER_ORDER Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ====================================================================================================

    CREATE VIEW [cus].[v_UNDELIVERED_TRANSFER_ORDER] AS
       SELECT
            CAST([DocumentNo] + '_' + [TransferfromCode] AS NVARCHAR(128)) AS [TRANSFER_ORDER_NO],
            CAST([ItemNo] + CASE WHEN ISNULL([VariantCode], '') = '' THEN '' ELSE '-' + [VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO],
            CAST(CASE WHEN [TransfertoCode] = 'BRING 3PL' THEN 'BJOA' ELSE [TransfertoCode] END AS NVARCHAR(255)) AS [LOCATION_NO],
            CAST([ReceiptDate] AS DATE) AS [DELIVERY_DATE],
            CAST(SUM([OutstandingQtyBase]) AS DECIMAL(18,4)) AS [QUANTITY],
            CAST([TransferfromCode] AS NVARCHAR(255)) AS [ORDER_FROM_LOCATION_NO],
			Company
       FROM
        [cus].transfer_line
       WHERE
        [OutstandingQtyBase] > 0 
       GROUP BY
        [DocumentNo], [TransferfromCode], [ItemNo], [VariantCode], [TransfertoCode], CAST([ReceiptDate] AS DATE), [Company]
		HAVING SUM([OutstandingQtyBase]) > 0


