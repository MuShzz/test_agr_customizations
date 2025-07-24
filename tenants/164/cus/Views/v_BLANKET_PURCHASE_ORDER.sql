
-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Blanket Purchase order mapping from bc rest to adi format
--
-- 25.11.2024.BF    Created
-- ===============================================================================
CREATE VIEW [cus].[v_BLANKET_PURCHASE_ORDER]
AS
 
    SELECT
        CAST([DocumentNo] AS NVARCHAR(128))                                 AS PURCHASE_ORDER_NO,
        CAST([No] + CASE WHEN ISNULL([VariantCode], '') = '' THEN '' 
                        ELSE '-' + [VariantCode] 
                        END AS NVARCHAR(255))                               AS [ITEM_NO],
        CAST([LocationCode] AS NVARCHAR(255))                               AS LOCATION_NO,
        SUM(CAST([OutstandingQtyBase] AS DECIMAL(18,4)))                    AS QUANTITY,
        CAST([ExpectedReceiptDate] AS DATE)                                 AS DELIVERY_DATE,
		[Company]
    FROM
        [cus].purchase_line
    WHERE
        [DocumentType] IN ('Blanket Order') AND  [ExpectedReceiptDate] <> '0001-01-01 00:00:00.000'
        AND [DropShipment] = 0
    GROUP BY
        [DocumentNo], [No], [VariantCode], CAST([ExpectedReceiptDate] AS DATE), [LocationCode], [Company]
    HAVING SUM([OutstandingQtyBase]) > 0


