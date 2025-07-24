



CREATE VIEW [cus].[v_ITEM_GROUP] AS
   SELECT CAST(code AS NVARCHAR(255)) AS [no]
          ,CAST(name AS NVARCHAR(255)) AS [name]
    FROM cus.[@TRC_COLL_ITM_GROUP]

	UNION
    
	    SELECT CAST(code AS NVARCHAR(255)) AS [no]
          ,CAST(name AS NVARCHAR(255)) AS [name]
    FROM cus.[@TRC_COLLECTION]


