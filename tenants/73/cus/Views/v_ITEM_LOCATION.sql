



-- ===============================================================================
-- Author:      José Santos
-- Description: Customer mapping erp raw to adi
--
--  04.07.2023.TO   Created
-- ===============================================================================


CREATE VIEW [cus].[v_ITEM_LOCATION] AS
    SELECT 
	   CAST(it.ItemCode AS NVARCHAR(255))    AS [ITEM_NO],
       CAST(wh.WhsCode AS NVARCHAR(255))     AS [LOCATION_NO],

        CAST(it.MinLevel AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],

       CAST(it.MaxLevel AS DECIMAL(18,4))           AS [MAX_STOCK],
       CAST(NULL AS BIT)                     AS [CLOSED_FOR_ORDERING],
       CAST(re.SlpName AS NVARCHAR(255))           AS [RESPONSIBLE],
       CAST(NULL AS NVARCHAR(255))           AS [NAME],
       CAST(NULL AS NVARCHAR(1000))          AS [DESCRIPTION],
       CAST(NULL AS NVARCHAR(255))           AS [PRIMARY_VENDOR_NO],
       CAST(NULL AS SMALLINT)                AS [PURCHASE_LEAD_TIME_DAYS],
       CAST(NULL AS SMALLINT)                AS [TRANSFER_LEAD_TIME_DAYS],
       CAST(NULL AS SMALLINT)                AS [ORDER_FREQUENCY_DAYS],
       CAST(NULL AS SMALLINT)                AS [ORDER_COVERAGE_DAYS],
       CAST(NULL AS DECIMAL(18,4))           AS [MIN_ORDER_QTY],
       CAST(NULL AS NVARCHAR(50))            AS [ORIGINAL_NO],
       CAST(NULL AS DECIMAL(18,4))           AS [SALE_PRICE],
       CAST(NULL AS DECIMAL(18,4))           AS [COST_PRICE],
       CAST(NULL AS DECIMAL(18,4))           AS [PURCHASE_PRICE],
       CAST(NULL AS DECIMAL(18,4))           AS [ORDER_MULTIPLE],
       CAST(NULL AS DECIMAL(18,4))           AS [QTY_PALLET],
       CAST(NULL AS DECIMAL(18,4))           AS [VOLUME],
       CAST(NULL AS DECIMAL(18,4))           AS [WEIGHT],
       CAST(0 AS DECIMAL(18,4))           AS [REORDER_POINT],
       CAST(1 AS BIT)                     AS [INCLUDE_IN_AGR],
       CAST(IIF(it.PrchseItem = 'Y' AND it.InvntItem = 'Y' AND it.frozenFor = 'N', 0, 1) AS BIT)                     AS [CLOSED]
	    , CAST(NULL AS BIT)   AS [SPECIAL_ORDER]
    FROM [cus].OITM it
		LEFT JOIN [cus].OITW wh ON  wh.ItemCode = it.ItemCode
		LEFT JOIN [cus].OCRD ve ON ve.CardCode = it.CardCode
		LEFT JOIN [cus].OSLP re ON re.SlpCode = ve.SlpCode
	WHERE it.PrchseItem = 'Y' AND it.InvntItem = 'Y' AND (it.frozenFor = 'N' OR (it.frozenFor = 'Y' AND QryGroup10 = 'Y'))

