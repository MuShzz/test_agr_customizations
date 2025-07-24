



CREATE VIEW [cus].[v_cc_item_extra_info] AS

    SELECT
        CAST(cc.[No] AS NVARCHAR(255))		AS Item_no,
		l.Code AS Location_no,
		cc.PG_Device_Series AS deviceSeries,
		cc.PG_Budget_Category AS budgetCategory,
		cc.PG_Production_Status AS productionStatus,
		cc.Company
    FROM
        cus.cc_item_extra_info cc
		LEFT JOIN cus.Location l ON l.Company = cc.Company 
		INNER JOIN core.location_mapping_setup lm ON lm.locationNo = l.Code


