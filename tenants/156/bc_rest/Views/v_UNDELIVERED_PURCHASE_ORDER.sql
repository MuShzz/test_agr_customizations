
-- ===============================================================================
-- Author:      Astros Eir Kristinsdottir
-- Description: Purchase order mapping from bc rest to adi format, adding custom table
--
-- 11.04.2025.TO    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_UNDELIVERED_PURCHASE_ORDER]
AS
 
    SELECT
        CAST([DocumentNo] AS NVARCHAR(128)) AS PURCHASE_ORDER_NO,
        CAST([No] + CASE WHEN ISNULL([VariantCode], '') = '' THEN '' ELSE '-' + [VariantCode] END AS NVARCHAR(255)) AS [ITEM_NO],
        CAST([LocationCode] AS NVARCHAR(255)) AS LOCATION_NO,
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

	UNION ALL

	SELECT 
		CAST([OrderNo] AS NVARCHAR(128)) AS PURCHASE_ORDER_NO,
		CAST([ItemNo] AS NVARCHAR(255)) AS [ITEM_NO],
		CAST([LocationCode] AS NVARCHAR(255)) AS LOCATION_NO,
		SUM(CAST([QtyToReceive] AS DECIMAL(18,4))) AS QUANTITY,
		CAST([ExpectedReceiptDate] AS DATE) AS DELIVERY_DATE
	FROM 
		[bc_rest_cus].[UndeliveredCDI]
	WHERE 
		[QtyToReceive] <> 0
	GROUP BY 
		[OrderNo], [ItemNo], [LocationCode], [ExpectedReceiptDate]

