





-- ===============================================================================
-- Author:      JOSÉ SUCENA
-- Description: Item location mapping from nav to adi format
--
-- 09.10.2024.TO    Created
-- 02.12.2024.AEK BEL-7, BEL-6
-- ===============================================================================


CREATE VIEW [nav_cus].[v_ITEM_LOCATION]
AS

     SELECT distinct
		CAST(i.[No_] AS NVARCHAR(255)) AS [ITEM_NO]
        ,CAST(lm.locationNo AS NVARCHAR(255)) AS LOCATION_NO
        ,CAST([Reorder Point] AS DECIMAL(18,4)) AS [REORDER_POINT]
        ,CAST([Safety Stock Quantity] AS DECIMAL(18,4)) AS [SAFETY_STOCK_UNITS]
        ,CAST(NULL AS DECIMAL(18,4)) AS [MIN_DISPLAY_STOCK]
        ,CAST([Maximum Inventory] AS DECIMAL(18,4)) AS [MAX_STOCK]
     --   ,CAST(NULL AS BIT) AS [CLOSED]
		,CASE WHEN re.[xReplen_ Method NOT USED] = 1
			THEN CAST(ISNULL(rev.[Block Transferring],0) AS BIT)
			ELSE CAST(ISNULL(rev.[Block Purchasing],0) AS BIT)
		END AS [CLOSED]
        ,CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING]
        ,CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE]
        ,CAST(NULL AS NVARCHAR(255)) AS [NAME]
        ,CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION]
        ,CAST(NULLIF([Vendor No_],'') AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO]
        ,CAST(IIF(
                i.[Replenishment System] = 0
                AND LEN(i.[Lead Time Calculation]) > 0,
                nav.LeadTimeConvert(i.[Lead Time Calculation]),
                NULL) AS SMALLINT) AS PURCHASE_LEAD_TIME_DAYS
        ,CAST(IIF(
                i.[Replenishment System] <> 0
                AND LEN(i.[Lead Time Calculation]) > 0,
                nav.LeadTimeConvert(i.[Lead Time Calculation]),
                NULL) AS SMALLINT) AS TRANSFER_LEAD_TIME_DAYS
        ,CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS]
        ,CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS]
        ,CAST([Minimum Order Quantity] AS DECIMAL(18,4)) AS [MIN_ORDER_QTY]
        ,CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO]
        ,CAST(NULL AS DECIMAL(18,4)) AS [SALE_PRICE]
        ,CAST([Unit Cost] AS DECIMAL(18,4)) AS [COST_PRICE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE]
        ,CASE WHEN re.[xReplen_ Method NOT USED] = 1
			THEN CAST(tm.[Transfer Multiple] AS DECIMAL(18,4))
			ELSE CAST(i.[Order Multiple] AS DECIMAL(18,4))
		END AS [ORDER_MULTIPLE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET]
        ,CAST(NULL AS DECIMAL(18,4)) AS [VOLUME]
        ,CAST(NULL AS DECIMAL(18,4)) AS [WEIGHT]
        ,CAST(IIF(re.[Exclude from Replenishment] = 0,1,0) AS BIT) AS [INCLUDE_IN_AGR]
		,CAST(NULL AS BIT)   AS [SPECIAL_ORDER]
	FROM nav.Item i
	inner join [nav_cus].[Replen_ Item Store Rec] re on re.[Item No_] = i.No_
    INNER JOIN core.location_mapping_setup lm ON lm.locationNo = re.[Location Code]
	LEFT JOIN  [nav_cus].[cc_transfer_multiple] tm on tm.No_ = i.No_ 
	LEFT JOIN [nav_cus].[Replen_ Item Store Rec View] rev on rev.[Item No_] = i.No_ AND rev.[Location Code] = lm.locationNo AND re.[xReplen_ Method NOT USED]=rev.[xReplen_ Method NOT USED]
	--WHERE CAST(i.[No_] AS NVARCHAR(255))='16389' AND CAST(lm.locationNo AS NVARCHAR(255))='1'

	


