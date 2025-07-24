CREATE VIEW [ax_cus].v_LOCATION
AS
	 WITH erp_locations AS
    (
		 SELECT DISTINCT
			il.INVENTLOCATIONID AS [NO],
			ISNULL(il.name,'') AS NAME,
			CAST(NULL AS NVARCHAR(255)) AS [GROUP],
			COALESCE(NULL, core.get_setting_value('core_location_type_default')) AS [TYPE] ,
            CAST(0 AS BIT) AS CLOSED,
            CAST(NULL AS DATE) AS OPENING_DATE,
            CAST(NULL AS DATE) AS CLOSING_DATE
		 FROM
			ax.INVENTLOCATION il
    )
    --Adding custom locations if they exist and location type from location_mapping_setup if configured there
    SELECT
        loc_list.[NO],
        loc_list.[NAME]

    FROM
       (SELECT
            l.NO, l.NAME, l.[GROUP], l.[TYPE], l.CLOSED, l.OPENING_DATE, l.CLOSING_DATE
        FROM erp_locations l) loc_list
	LEFT JOIN core.location_mapping_setup clms ON clms.locationNo = loc_list.[NO]

