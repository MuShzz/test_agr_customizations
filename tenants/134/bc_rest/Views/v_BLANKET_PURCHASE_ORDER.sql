
-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Blanket Purchase order mapping from bc rest to adi format
--
-- 25.11.2024.BF    Created
-- ===============================================================================
CREATE VIEW [bc_rest_cus].[v_BLANKET_PURCHASE_ORDER]
AS
 
    SELECT
        CAST([DocumentNo] AS NVARCHAR(128))                                 AS PURCHASE_ORDER_NO,
        CAST([No]			 AS NVARCHAR(255))                               AS [ITEM_NO],
        CAST([LocationCode] AS NVARCHAR(255))                               AS LOCATION_NO,
        SUM(CAST([OutstandingQtyBase] AS DECIMAL(18,4)))                    AS QUANTITY,
        CAST([ExpectedReceiptDate] AS DATE)                                 AS DELIVERY_DATE
    FROM
        [bc_rest].purchase_line
    WHERE
        [DocumentType] IN ('Blanket Order') AND  [ExpectedReceiptDate] <> '0001-01-01 00:00:00.000'
        AND [DropShipment] = 0
    GROUP BY
        [DocumentNo], [No], CAST([ExpectedReceiptDate] AS DATE), [LocationCode]
    HAVING SUM([OutstandingQtyBase]) > 0

