



CREATE   VIEW [cus].[v_location_setup] AS


	SELECT '001' AS location_no,
	'001' AS source_location_no,
	1 AS sale,
	0 AS transfer_as_sale,
	1 AS stock,
	1 AS undelivered
	 
	 UNION ALL

	 SELECT '001' AS location_no,
	'023' AS source_location_no,
		1 AS sale,
	0 AS transfer_as_sale,
	1 AS stock,
	1 AS undelivered
	 
	 UNION ALL

	 SELECT '90' AS location_no,
	'90' AS source_location_no,
	1 AS sale,
	0 AS transfer_as_sale,
	1 AS stock,
	1 AS undelivered
	 


