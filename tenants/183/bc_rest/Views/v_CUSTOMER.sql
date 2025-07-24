


-- ===============================================================================
-- Author:      Thordur Oskarsson
-- Description: Customer mapping from bc rest to adi format
--
-- 26.09.2024.TO    Created
-- 04.06.2025.DRG	Missing Dimension_Value_Code from erp_bc_rest.default_dimensions 
-- ===============================================================================

CREATE VIEW [bc_rest_cus].[v_CUSTOMER]

AS

    SELECT DISTINCT
        CAST(c.[No] AS NVARCHAR(255)) AS NO,
        CAST(c.[Name] AS NVARCHAR(255)) AS NAME,
      --  CAST(NULL AS NVARCHAR(255)) AS CUSTOMER_GROUP_NO
	--	
        CASE 
			WHEN cdd.Dimension_Value_Code = 'B2C' THEN 'E-Commerce'
			WHEN cei.[Country_Region_Code] IN ('CA') THEN 'Canada'
			WHEN cei.[Country_Region_Code] IN ('US') THEN 'USA'
			WHEN cei.[Country_Region_Code] IN ('GB','JE','GG','IE', 'XI','IM') THEN 'UK'
			WHEN cei.[Country_Region_Code] IN ('IS','DK','NO','FI','SE') THEN 'Nordic'
			WHEN cei.[Country_Region_Code] IN ('ES','NL','PT','GR','LU','LT','CY','SI','DE','BE','CH','BG','HR','IT','PL','HU','TR','AT','AX','FR','LV','RU','RO','EE','SK','CZ') THEN 'Europe'
		ELSE 'unknown'
		END AS CUSTOMER_GROUP_NO
   FROM
        bc_rest.customer c
	LEFT JOIN bc_rest_cus.customer_extra_info cei ON cei.No = c.No
	LEFT JOIN [bc_rest_cus].[customer_default_dimensions] cdd ON cdd.[No] = c. [No] AND cdd.Dimension_Value_Code = 'B2C'



/* -- mapping from PLUS customer group setup
SELECT DISTINCT CASE 
 
        WHEN dd.Dimension_Value_Code = 'B2C' THEN 'E-Commerce'
        WHEN [Country_Region_Code] IN ('CA') THEN 'Canada'
		WHEN [Country_Region_Code] IN ('US') THEN 'USA'
		WHEN [Country_Region_Code] IN ('GB','JE','GG','IE', 'XI','IM') THEN 'UK'
		WHEN [Country_Region_Code] IN ('IS','DK','NO','FI','SE') THEN 'Nordic'
		WHEN [Country_Region_Code] IN ('ES','NL','PT','GR','LU','LT','CY','SI','DE','BE','CH','BG','HR','IT','PL','HU','TR','AT','AX','FR','LV','RU','RO','EE','SK','CZ') THEN 'Europe'
		ELSE 'unknown'
	END AS customer_group_no,
	CASE WHEN dd.Dimension_Value_Code = 'B2C' THEN 'E-Commerce'
		WHEN [Country_Region_Code] IN ('CA') THEN 'Canada'
		WHEN [Country_Region_Code] IN ('US') THEN 'USA'
		WHEN [Country_Region_Code] IN ('GB','JE','GG','IE', 'XI', 'IM') THEN 'UK'
		WHEN [Country_Region_Code] IN ('IS','DK','NO','FI','SE') THEN 'Nordic'
		WHEN [Country_Region_Code] IN ('ES','NL','PT','GR','LU','LT','CY','SI','DE','BE','CH','BG','HR','IT','PL','HU','TR','AT','AX','FR','LV','RU','RO','EE','SK','CZ') THEN 'Europe'
		ELSE 'Other'
	END AS name,
	'' AS sales_rep
	FROM erp_cus.customers c
	INNER JOIN erp_bc_rest.default_dimensions dd ON dd.No=c.No
	WHERE dd.Dimension_Code='SALES'
 */


