

CREATE VIEW [nav_cus].[v_cc_shortTermLoanQty]
AS

	WITH cte AS (
		SELECT
			i.NO,
			sl.EXPIRE_DATE,
			sl.STOCK_UNITS,
			COALESCE(i.ORDER_FREQUENCY_DAYS,s_freq.settingValue) AS ORDER_FREQUENCY_DAYS,
			COALESCE(i.PURCHASE_LEAD_TIME_DAYS,v.LEAD_TIME_DAYS,s_lea.settingValue) AS LEAD_TIME_DAYS
		FROM adi.ITEM i
		 LEFT JOIN adi.STOCK_LEVEL sl ON sl.ITEM_NO=i.NO
		 LEFT JOIN adi.VENDOR v ON v.NO=i.PRIMARY_VENDOR_NO
		 JOIN core.setting s_freq ON s_freq.settingKey = 'inventory_order_frequency_days_default'
		 JOIN core.setting s_lea ON s_lea.settingKey = 'data_mapping_lead_times_purchase_order_lead_time'
	)
	SELECT
		cte.NO AS ITEM_NO,
		CAST(SUM(cte.STOCK_UNITS) AS INT) AS shortTermLoanQty
	FROM cte
	WHERE cte.EXPIRE_DATE<DATEADD(dd,(cte.ORDER_FREQUENCY_DAYS+cte.LEAD_TIME_DAYS), CAST(GETDATE() AS date))
	GROUP BY cte.NO


