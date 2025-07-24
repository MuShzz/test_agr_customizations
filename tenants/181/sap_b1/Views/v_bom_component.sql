CREATE VIEW [sap_b1_cus].[v_bom_component] AS

SELECT 	
	RANKING.ITEM_NO,
	RANKING.COMPONENT_ITEM_NO,
	RANKING.QUANTITY FROM (
		SELECT
			ROW_NUMBER() OVER ( PARTITION BY h.Code, l.Code ORDER BY h.Code, l.Code) AS rn,
			CAST(h.Code     AS NVARCHAR(255))   AS ITEM_NO,            -- parent item
			CAST(l.Code AS NVARCHAR(255))   AS COMPONENT_ITEM_NO,  -- component
			CAST(l.Quantity AS DECIMAL(18,4))   AS QUANTITY            -- qty per parent
		FROM      [sap_b1].OITT  AS h           -- BOM header
		INNER JOIN [sap_b1].ITT1 AS l
			   ON l.Father = h.Code    -- BOM lines
		WHERE l.Code IS NOT NULL
		/* optional filter : keep only real production/assembly BOMs
		   WHERE h.TreeType IN ('P','A')    */ 
		   ) RANKING WHERE RANKING.rn = 1

