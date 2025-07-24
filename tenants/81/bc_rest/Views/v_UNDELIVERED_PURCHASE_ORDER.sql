

-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Purchase order mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_UNDELIVERED_PURCHASE_ORDER]
AS
 
    SELECT
        CAST([DocumentNo] AS NVARCHAR(128)) AS PURCHASE_ORDER_NO,
        CAST([No] + CASE WHEN ISNULL([VariantCode], '') = '' THEN '' ELSE '-' + [VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO],
        CAST(CASE
		WHEN LocationCode = '' THEN 'VARAHLUTIR'
		ELSE
			LocationCode
		END AS NVARCHAR(255)) AS LOCATION_NO,
        SUM(CAST([OutstandingQtyBase] AS DECIMAL(18,4))) AS QUANTITY,
        CAST(IIF([ExpectedReceiptDate]='0001-01-01 00:00:00.000', GETDATE(),[ExpectedReceiptDate]) AS DATE) AS DELIVERY_DATE
    FROM
        [bc_rest].purchase_line
    WHERE
        [DocumentType] IN ('Order')
        AND [DropShipment] = 0
    GROUP BY
        [DocumentNo], [No], [VariantCode], [LocationCode], CAST(IIF([ExpectedReceiptDate]='0001-01-01 00:00:00.000', GETDATE(),[ExpectedReceiptDate]) AS DATE)
    HAVING SUM([OutstandingQtyBase]) > 0

