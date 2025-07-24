

-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Custom Column to map purchasing code for items
--
--  14.03.2025.BF   Created
-- ===============================================================================

CREATE VIEW [bc_sql_cus].[v_CC_PurchasingCode] AS
   
	SELECT
        CAST(No_ AS NVARCHAR(255)) AS [NO],
        CAST(IIF([Purchasing Code]='HRÁEFNI',1,0) AS BIT) AS [hraefni],
		CAST(IIF([Purchasing Code]='SÉRPÖNTUN',1,0) AS BIT) AS [serpontun],
		CAST(IIF([Purchasing Code]='TRANSIT',1,0) AS BIT) AS [adfongTransit],
		CAST(IIF([Purchasing Code]='KÆLIVARA',1,0) AS BIT) AS [adfongKaelivara]
	FROM
		bc_sql_cus.ItemExtraInfo





