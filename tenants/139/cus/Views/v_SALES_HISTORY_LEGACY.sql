
-- ===============================================================================
-- Author:      Bárbara Ferreira
-- Description: Upload Legacy Sale History
--
-- 10.12.2024.BF    Created
-- 14.03.2025.BF    upload new file with sales history
-- ===============================================================================


CREATE VIEW cus.[v_SALES_HISTORY_LEGACY] AS
     SELECT
          CAST(shl.ITEM_NO AS NVARCHAR(255))			AS [ITEM_NO],
          CAST(shl.LOCATION_NO AS NVARCHAR(255))		AS [LOCATION_NO],
          CAST(shl.DATE AS DATE)						AS [DATE],
		  CAST(shl.CUSTOMER_NO AS NVARCHAR(255))		AS CUSTOMER_NO,
		  CAST(shl.REFERENCE_NO AS NVARCHAR(255))		AS REFERENCE_NO,
          CAST(SUM(shl.SALE) AS DECIMAL(18,4))			AS [SALE]
    FROM
         cus.SALES_HISTORY_LEGACY_20250606 shl 
    GROUP BY
         shl.ITEM_NO,shl.LOCATION_NO,shl.DATE, shl.REFERENCE_NO, shl.CUSTOMER_NO

