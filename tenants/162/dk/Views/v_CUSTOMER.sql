
-- ===============================================================================
-- Author:      Ágúst Örn Grétarsson
-- Description: Customer mapping from erp to raw format
--
-- 29.04.2021.AOG   Created
-- 14.06.2022.TO    Adapted to data factory erp
-- 07.03.2023.AOG   DEV-6150 - Customer breakdown
-- 13.04.2023.TO    DEV-6354 - Sage 200 data mapping
-- 28.04.2023.TO    DEV-6400 - Fixing BC rest Blocked mapping
-- 10.05.2023.TO    DEV-6390 - VismaNet data mapping
-- 20.09.2023.AOG   DEV-7180 - Adding missing customer
-- 24.10.2024.JOSÉ SUCENA    - ADI VIEWS
-- ===============================================================================

CREATE VIEW [dk_cus].[v_CUSTOMER]
AS

    --SELECT
    --    CAST('agr_no_customer' AS NVARCHAR(255))	AS [no],
    --    CAST('N/A' AS NVARCHAR(255))				AS [name],
    --    CAST(NULL AS NVARCHAR(255))					AS [customer_group_no]

    --UNION

    SELECT
        [Number]						AS [no],
        [Name]							AS [name],
        NULL                            AS [customer_group_no]
    FROM
        [dk].[import_customers] c

