CREATE VIEW bc_sql_cus.v_CC_Replenishmet_Method
AS
	WITH item_w_locations AS(
		SELECT
		 No_,
		 loc.locationNo,
		 [Replenishment System]
		 FROM bc_sql.Item
		 LEFT JOIN core.location_mapping_setup loc
			ON loc.locationNo != 'IRELAND'
	)
	
	SELECT
		i.No_,
		i.locationNo AS [Location Code],
		ce.EnumDescription AS [Replenishment Method]
	FROM item_w_locations i
	LEFT JOIN bc_sql.StockkeepingUnit s 
		ON i.No_ = s.[Item No_] AND s.[Location Code] != 'IRELAND'
	LEFT JOIN bc_sql_cus.CC_Enum ce
		ON i.[Replenishment System] = ce.EnumValue
		AND ce.enumlist = 'ItemReplenishmentSystem'

	UNION ALL

	SELECT
		[Item No_] AS No_, 
		[Location Code],
		EnumDescription AS [Replenishment Method]
	FROM bc_sql.StockkeepingUnit 
	LEFT OUTER JOIN bc_sql_cus.CC_Enum 
		ON [Replenishment System] = EnumValue 
		AND enumlist = 'ItemReplenishmentSystem'
	WHERE  [Location Code] = 'IRELAND'
