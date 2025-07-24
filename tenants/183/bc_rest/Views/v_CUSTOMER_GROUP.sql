
CREATE VIEW [bc_rest_cus].[v_CUSTOMER_GROUP] AS
	
SELECT DISTINCT 
CAST (CASE 
			WHEN cdd.Dimension_Value_Code = 'B2C' THEN 'E-Commerce'
			WHEN cei.[Country_Region_Code] IN ('CA') THEN 'Canada'
			WHEN cei.[Country_Region_Code] IN ('US') THEN 'USA'
			WHEN cei.[Country_Region_Code] IN ('GB','JE','GG','IE', 'XI','IM') THEN 'UK'
			WHEN cei.[Country_Region_Code] IN ('IS','DK','NO','FI','SE') THEN 'Nordic'
			WHEN cei.[Country_Region_Code] IN ('ES','NL','PT','GR','LU','LT','CY','SI','DE','BE','CH','BG','HR','IT','PL','HU','TR','AT','AX','FR','LV','RU','RO','EE','SK','CZ') THEN 'Europe'
		ELSE 'unknown'
		END AS NVARCHAR(255)) AS [NO],
		CAST(
		CASE 
			WHEN cdd.Dimension_Value_Code = 'B2C' THEN 'E-Commerce'
			WHEN cei.[Country_Region_Code] IN ('CA') THEN 'Canada'
			WHEN cei.[Country_Region_Code] IN ('US') THEN 'USA'
			WHEN cei.[Country_Region_Code] IN ('GB','JE','GG','IE', 'XI','IM') THEN 'UK'
			WHEN cei.[Country_Region_Code] IN ('IS','DK','NO','FI','SE') THEN 'Nordic'
			WHEN cei.[Country_Region_Code] IN ('ES','NL','PT','GR','LU','LT','CY','SI','DE','BE','CH','BG','HR','IT','PL','HU','TR','AT','AX','FR','LV','RU','RO','EE','SK','CZ') THEN 'Europe'
		ELSE 'unknown'
		END AS NVARCHAR(255)) AS [NAME]
   FROM
        bc_rest.customer c
	LEFT JOIN bc_rest_cus.customer_extra_info cei ON cei.No = c.No
	LEFT JOIN [bc_rest_cus].[customer_default_dimensions] cdd ON cdd.[No] = c. [No] AND cdd.Dimension_Value_Code = 'B2C'


