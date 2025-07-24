




-- ===============================================================================
-- Author:      José Sucena
-- Description: Item Location Data mapping from CUS
--
--  23.09.2024.HMH   Created
-- ===============================================================================

CREATE VIEW [cus].[v_ITEM_LOCATION] 
AS
  SELECT DISTINCT
       CAST(it.ITEMID AS NVARCHAR(255))           AS [ITEM_NO],
       CAST(id.INVENTLOCATIONID AS NVARCHAR(255))           AS [LOCATION_NO],

        CAST(rit.MinInventOnhand AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS],
        CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK],

       CAST(NULL AS DECIMAL(18,4))           AS [MAX_STOCK],
       CAST(NULL AS BIT)                     AS [CLOSED_FOR_ORDERING],
       CAST(NULL AS NVARCHAR(255))           AS [RESPONSIBLE],
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
       CAST(ips.stopped AS BIT)                     AS [CLOSED],
	   CAST(NULL AS BIT)   AS [SPECIAL_ORDER]
  FROM [cus].INVENTTABLE it
	INNER JOIN [cus].ReqItemTable rit ON it.ITEMID = rit.ITEMID AND rit.DATAAREAID = it.DATAAREAID-- Changed by DFS 06.02.2024
	LEFT JOIN [cus].INVENTDIM id ON id.DATAAREAID = it.DATAAREAID AND id.PARTITION = it.PARTITION AND rit.covinventdimid = id.INVENTDIMID -- Changed by DFS 06.02.2024
	LEFT JOIN [cus].INVENTITEMPURCHSETUP ips ON ips.ITEMID = it.ITEMID AND ips.PARTITION = it.PARTITION AND ips.DATAAREAID = it.DATAAREAID
	LEFT JOIN [cus].INVENTITEMINVENTSETUP iis ON iis.ITEMID = it.ITEMID AND iis.PARTITION = it.PARTITION AND iis.DATAAREAID = it.DATAAREAID

   WHERE ips.INVENTDIMID = 'AllBlank'
	  --AND rit.inventlocationidreqmain IN ('860','600')
	  AND it.dataareaid = 'rar'
      AND ISNULL(iis.stopped,0) = 0 -- Exclude items were "Stöðvið í birgðum" (Closed fur stock move) active
	  AND it.ITEMID NOT LIKE '6%' --Added by DFS 31.01.2024
	  --AND it.ITEMID NOT LIKE '7%' --Added by DFS 31.01.2024
	  AND it.ITEMID NOT LIKE 'Þ%' --Added by DFS 31.01.2024
	  AND it.ITEMID NOT LIKE 'TR%' --Added by DFS 31.01.2024
	  AND it.ITEMID NOT LIKE 'Hlutd%' --Added by DFS 31.01.2024
	  AND it.ITEMID NOT LIKE 'N%' --Added by DFS 31.01.2024
	  AND it.ITEMID NOT LIKE 'S%' --Added by DFS 31.01.2024
	  AND it.ITEMID NOT LIKE 'Þ%' --Added by DFS 31.01.2024



