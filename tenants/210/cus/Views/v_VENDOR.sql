CREATE VIEW [cus].v_VENDOR AS
    
	SELECT
        CAST(s.SupplierCode AS nvarchar(255))                                       AS [NO],
        CAST(s.SupplierName AS nvarchar(255))                                       AS [NAME],
        CAST(ISNULL(s.LeadTimeCalendarDays_C,s_lead_ven.settingValue) AS smallint)  AS [LEAD_TIME_DAYS],
        CAST(0 AS bit)                                                              AS [CLOSED]
	FROM cus.Supplier s
	INNER JOIN core.setting s_lead_ven ON s_lead_ven.settingKey='data_mapping_lead_times_vendor_default_lead_time'
    where s.IsActive=1
