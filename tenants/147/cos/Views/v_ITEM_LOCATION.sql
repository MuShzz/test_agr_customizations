

-- ===============================================================================
-- Author:      Halla Maria Hjartardottir
-- Description: Customer mapping from COS
--
--  12.03.2023.HMH   Created
-- ===============================================================================
CREATE VIEW [cos_cus].[v_ITEM_LOCATION]
AS

--Warehouse

    SELECT 
        CAST(NO AS NVARCHAR(255))                  AS [ITEM_NO],
        CAST('0259' AS NVARCHAR(255))              AS [LOCATION_NO],
        CAST(MIN_STOCK AS DECIMAL(18,4))                AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4))                     AS [MIN_DISPLAY_STOCK],
        CAST(MAX_STOCK AS DECIMAL(18,4))                AS [MAX_STOCK],
        CAST(CLOSED_FOR_ORDERING AS BIT)                AS [CLOSED],
        CAST(CLOSED_FOR_ORDERING AS BIT)                AS [CLOSED_FOR_ORDERING],
        CAST(RESPONSIBLE AS NVARCHAR(255))              AS [RESPONSIBLE],
        CAST(NAME AS NVARCHAR(255))                     AS [NAME],
        CAST(DESCRIPTION AS NVARCHAR(1000))             AS [DESCRIPTION],
        CAST(PRIMARY_VENDOR_NO AS NVARCHAR(255))        AS [PRIMARY_VENDOR_NO],
        CAST(LEAD_TIME_DAYS AS SMALLINT)                AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT)                          AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(ORDER_FREQUENCY_DAYS AS SMALLINT)          AS [ORDER_FREQUENCY_DAYS],
        CAST(ORDER_COVERAGE_DAYS AS SMALLINT)           AS [ORDER_COVERAGE_DAYS],
        CAST(MIN_ORDER_QTY AS DECIMAL(18,4))            AS [MIN_ORDER_QTY],
        CAST(ORIGINAL_NO AS NVARCHAR(50))               AS [ORIGINAL_NO],
        CAST(SALE_PRICE AS DECIMAL(18,4))               AS [SALE_PRICE],
        CAST(COST_PRICE AS DECIMAL(18,4))               AS [COST_PRICE],
        CAST(PURCHASE_PRICE AS DECIMAL(18,4))           AS [PURCHASE_PRICE],
        CAST(MIN_ORDER_QTY AS DECIMAL(18,4))           AS [ORDER_MULTIPLE],
        CAST(QTY_PALLET AS DECIMAL(18,4))               AS [QTY_PALLET],
        CAST(VOLUME AS DECIMAL(18,4))                   AS [VOLUME],
        CAST(WEIGHT AS DECIMAL(18,4))                   AS [WEIGHT],
        CAST(ISNULL(REORDER_POINT,0) AS DECIMAL(18,4))  AS [REORDER_POINT],
        CAST(1 AS BIT)                                  AS [INCLUDE_IN_AGR],
		CAST(NULL AS BIT)								AS [SPECIAL_ORDER]
    FROM 
        [cos].[AGR_ITEM]
		--WHERE NO = '51777-525'
	
	UNION ALL

-- Stores

SELECT 
    CAST(il.NO AS NVARCHAR(255))					AS [ITEM_NO],
    CAST(l.LOCATION_NO AS NVARCHAR(255))			AS [LOCATION_NO],
    CAST(NULL AS DECIMAL(18,4))						AS [SAFETY_STOCK_UNITS],
    CAST(NULL AS DECIMAL(18,4))                     AS [MIN_DISPLAY_STOCK],
    CAST(MAX_STOCK AS DECIMAL(18,4))                AS [MAX_STOCK],
    CAST(CLOSED_FOR_ORDERING AS BIT)                AS [CLOSED],
    CAST(CLOSED_FOR_ORDERING AS BIT)                AS [CLOSED_FOR_ORDERING],
    CAST(RESPONSIBLE AS NVARCHAR(255))              AS [RESPONSIBLE],
    CAST(il.NAME AS NVARCHAR(255))                  AS [NAME],
    CAST(DESCRIPTION AS NVARCHAR(1000))             AS [DESCRIPTION],
    CAST(PRIMARY_VENDOR_NO AS NVARCHAR(255))        AS [PRIMARY_VENDOR_NO],
    CAST(il.LEAD_TIME_DAYS AS SMALLINT)             AS [PURCHASE_LEAD_TIME_DAYS],
    CAST(NULL AS SMALLINT)                          AS [TRANSFER_LEAD_TIME_DAYS],
    CAST(2 AS SMALLINT)								AS [ORDER_FREQUENCY_DAYS],
    CAST(ORDER_COVERAGE_DAYS AS SMALLINT)           AS [ORDER_COVERAGE_DAYS],
    CAST(1 AS DECIMAL(18,4))						AS [MIN_ORDER_QTY],
    CAST(ORIGINAL_NO AS NVARCHAR(50))               AS [ORIGINAL_NO],
    CAST(SALE_PRICE AS DECIMAL(18,4))               AS [SALE_PRICE],
    CAST(COST_PRICE AS DECIMAL(18,4))               AS [COST_PRICE],
    CAST(PURCHASE_PRICE AS DECIMAL(18,4))           AS [PURCHASE_PRICE],
    CAST(1 AS DECIMAL(18,4))						AS [ORDER_MULTIPLE],
    CAST(QTY_PALLET AS DECIMAL(18,4))               AS [QTY_PALLET],
    CAST(VOLUME AS DECIMAL(18,4))                   AS [VOLUME],
    CAST(WEIGHT AS DECIMAL(18,4))                   AS [WEIGHT],
    CAST(ISNULL(REORDER_POINT,0) AS DECIMAL(18,4))  AS [REORDER_POINT],
    CAST(1 AS BIT)                                  AS [INCLUDE_IN_AGR],
	CAST(NULL AS BIT)								AS [SPECIAL_ORDER]
FROM 
    [cos].[AGR_ITEM] il
CROSS JOIN 
    (SELECT '0300' AS LOCATION_NO UNION ALL
     SELECT '0400' UNION ALL
     SELECT '0701' UNION ALL
     SELECT '3601' UNION ALL
     SELECT '7009' UNION ALL
     SELECT '8009' UNION ALL
     SELECT 'ZSKU-60') l;




