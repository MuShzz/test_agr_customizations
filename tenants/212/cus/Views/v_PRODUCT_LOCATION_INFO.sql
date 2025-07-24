-- ===============================================================================
-- Author:      Ágúst Örn Grétarsson
-- Description: Product location info mapping from erp to raw format
--
-- 31.10.2023.AOG   Created
-- 02.01.2024.AOG   DEV-7905 - Fix variants
-- 10.01.2024.AOG   DEV-8012 - Location setup refactoring
-- 24.01.2024.AOG   DEV-7810 - Adding closed for ordering
-- 26.01.2024.TO    DEV-8148 - Adding SafetyStockQuantity as min stock for BC
-- ===============================================================================
CREATE VIEW [cus].[v_PRODUCT_LOCATION_INFO]
AS

    SELECT CAST(NULL AS NVARCHAR(255)) AS [PRODUCT_ITEM_NO]
        ,CAST(NULL AS NVARCHAR(255)) AS [LOCATION_NO]
        ,CAST(NULL AS DECIMAL(18,4)) AS [REORDER_POINT]
        ,CAST(NULL AS DECIMAL(18,4)) AS [MIN_STOCK]
        ,CAST(NULL AS DECIMAL(18,4)) AS [MAX_STOCK]
        ,CAST(0 AS BIT) AS [CLOSED]
        ,CAST(NULL AS BIT) AS [CLOSED_FOR_ORDERING]
        ,CAST(NULL AS NVARCHAR(255)) AS [RESPONSIBLE]
        ,CAST(NULL AS NVARCHAR(255)) AS [NAME]
        ,CAST(NULL AS NVARCHAR(1000)) AS [DESCRIPTION]
        ,CAST(NULL AS NVARCHAR(255)) AS [PRIMARY_VENDOR_NO]
        ,CAST(NULL AS SMALLINT) AS [PURCHASE_LEAD_TIME_DAYS]
        ,CAST(NULL AS SMALLINT) AS [TRANSFER_LEAD_TIME_DAYS]
        ,CAST(NULL AS SMALLINT) AS [ORDER_FREQUENCY_DAYS]
        ,CAST(NULL AS SMALLINT) AS [ORDER_COVERAGE_DAYS]
        ,CAST(NULL AS DECIMAL(18,4)) AS [MIN_ORDER_QTY]
        ,CAST(NULL AS NVARCHAR(50)) AS [ORIGINAL_NO]
        ,CAST(NULL AS DECIMAL(18,4)) AS [SALE_PRICE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [COST_PRICE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [PURCHASE_PRICE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [ORDER_MULTIPLE]
        ,CAST(NULL AS DECIMAL(18,4)) AS [QTY_PALLET]
        ,CAST(NULL AS DECIMAL(18,4)) AS [VOLUME]
        ,CAST(NULL AS DECIMAL(18,4)) AS [WEIGHT]
		WHERE 1=0
