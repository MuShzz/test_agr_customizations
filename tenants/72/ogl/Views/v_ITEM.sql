



CREATE VIEW [ogl_cus].[v_ITEM] AS
    SELECT
        CAST(it.stcode AS NVARCHAR(255))                                    AS [NO],
        CAST(ISNULL(it.desc_,'') AS NVARCHAR(255))                          AS [NAME],
        CAST('' AS NVARCHAR(1000))                                          AS [DESCRIPTION],
        CAST(ISNULL(CASE 
                    WHEN it.sref1 <> '' THEN it.sref1 
                    WHEN it.sref2 <> '' THEN it.sref2 
                    WHEN it.sref3 <> '' THEN it.sref3 
                    ELSE 'vendor_missing' 
                    END, 'vendor_missing') AS NVARCHAR(255))                AS [PRIMARY_VENDOR_NO],
        CAST(CASE WHEN it.sref1 <> '' AND it.leadtime1 <> 0 THEN it.leadtime1
		WHEN it.sref2 <> '' AND it.leadtime2 <> 0 THEN it.leadtime2
		WHEN it.sref3 <> '' AND it.leadtime3 <> 0 THEN it.leadtime3
		ELSE NULL END AS SMALLINT)											AS [PURCHASE_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT)                                              AS [TRANSFER_LEAD_TIME_DAYS],
        CAST(NULL AS SMALLINT )                                             AS [ORDER_FREQUENCY_DAYS],
        CAST(NULL AS SMALLINT )                                             AS [ORDER_COVERAGE_DAYS],
        CAST(it.normord1 AS DECIMAL(18,4))                                  AS [MIN_ORDER_QTY],
        CAST(it.stcode AS NVARCHAR(50))                                     AS [ORIGINAL_NO],
        CAST(CASE WHEN it.obsoleteind = 'N'  THEN 0 ELSE 1 END AS BIT)      AS [CLOSED_FOR_ORDERING],
        CAST(NULL AS NVARCHAR(255))                                         AS [RESPONSIBLE],
        CAST(it.sellprc1_1 AS DECIMAL(18,4))                                AS [SALE_PRICE],
        CAST(CASE WHEN CAST(it.unit AS DECIMAL(18,4)) > 1 THEN
                CAST(it.costprc AS DECIMAL(18,4))/CAST(it.unit AS DECIMAL(18,4))
            ELSE 
                CAST(it.costprc AS DECIMAL(18,4))
            END  AS DECIMAL(18,4))                                          AS [COST_PRICE],
        CAST(CASE WHEN CAST(it.unit AS DECIMAL(18,4)) > 1 THEN
				 CAST(it.costsup1 AS DECIMAL(18,4))/CAST(it.unit AS DECIMAL(18,4))
			ELSE 
				 CAST(it.costsup1 AS DECIMAL(18,4))
			END AS DECIMAL(18,4))                                           AS [PURCHASE_PRICE],
        CAST(it.ordincr1 AS DECIMAL(18,4))                                  AS [ORDER_MULTIPLE],
        CAST(NULL AS DECIMAL(18,4))                                         AS [QTY_PALLET],
        CAST(it.volume AS DECIMAL(18,6))                                    AS [VOLUME],
        CAST(it.weight AS DECIMAL(18,6))                                    AS [WEIGHT],
        CAST(NULL AS DECIMAL(18,4))                                         AS [MAX_STOCK],
	    CAST(NULL AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],
        CAST(it.pgroup+'-Group' AS NVARCHAR(255))                           AS [ITEM_GROUP_NO_LVL_1],
        CAST(IIF(it.ptype = '', NULL, it.ptype+'-Type') AS NVARCHAR(255))   AS [ITEM_GROUP_NO_LVL_2],
        CAST(NULL AS NVARCHAR(255))                                         AS [ITEM_GROUP_NO_LVL_3],
        CAST(it.iunitdesc AS NVARCHAR(50))                                  AS [BASE_UNIT_OF_MEASURE],
        CAST(it.unitdesc AS NVARCHAR(50))                                   AS [PURCHASE_UNIT_OF_MEASURE],
		CAST(ISNULL(NULLIF(it.unit / NULLIF(it.issunit, 0), 0), 1) AS DECIMAL(18,4)) AS [QTY_PER_PURCHASE_UNIT],
        CAST(IIF(it.specord = 'N',0,1) AS BIT) AS [SPECIAL_ORDER],
        CAST(0 AS DECIMAL(18,4)) AS [REORDER_POINT],
        CAST(0 AS BIT) AS [INCLUDE_IN_AGR],
        CAST(CASE WHEN it.obsoleteind = 'N'  THEN 0 ELSE 1 END AS BIT) AS [CLOSED]
    FROM [ogl].[STStockDetails] it
	WHERE it.category <> 'XXX'
	    AND it.pgroup NOT IN ('12','994','995','996','997','998','999') -- removed group 1 from filter AL-17

