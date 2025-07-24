


-- ===============================================================================
-- Author:      José Santos
-- Description: Mapping erp raw to adi
--
--  23.09.2024.TO   Updated
-- ===============================================================================

CREATE VIEW [cus].[v_LOCATION] AS

    WITH erp_locations AS
    (
        --ERP_BC_REST
        SELECT
			CAST([Code] + '-' + [Company] AS NVARCHAR(255)) AS [NO],
            CAST([Name] AS NVARCHAR(255)) AS [NAME],
            Company
        FROM
            cus.location

    )
    --Adding custom locations if they exist and location type from location_mapping_setup if configured there
    SELECT DISTINCT
        loc_list.[NO],
        loc_list.[NAME],
        loc_list.company
    FROM erp_locations loc_list

