

-- ===============================================================================
-- Author:      Daniel Freyr Snorrason
-- Description: Custom Column mapping
--
--  19.02.2025.DFS   Created
-- ===============================================================================
CREATE VIEW [cos_cus].[v_custom_column_total_sale_6M]
AS
	SELECT i.itemNo,
		   SUM(   CASE
					  WHEN sh.DATE
						   BETWEEN DATEADD(MONTH, -6, GETDATE()) AND DATEADD(DAY, -1, GETDATE()) THEN
						  sh.SALE
					  ELSE
						  0
				  END
			  ) AS total_sale_last_6M
	FROM dbo.AGREssentials_items i
		JOIN adi.SALES_HISTORY sh
			ON sh.ITEM_NO = i.itemNo
			   AND sh.LOCATION_NO = i.locationNo
	--WHERE i.itemNo = '20027-1150'
	GROUP BY i.itemNo;

