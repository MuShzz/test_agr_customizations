
CREATE VIEW [sap_b1_cus].[v_BOM_CONSUMPTION_HISTORY] AS
    SELECT
		CAST(inm.TransSeq AS NVARCHAR(255))  AS TRANSACTION_ID, -- unique movement id
		CAST(inm.ItemCode AS NVARCHAR(255))  AS ITEM_NO,        -- component issued
		CAST(inm.Warehouse  AS NVARCHAR(255))  AS LOCATION_NO,    -- warehouse/bin code
		CAST(inm.DocDate  AS DATE)           AS [DATE],         -- posting date
		CAST(inm.OutQty   AS DECIMAL(18,4))  AS [UNIT_QTY]      -- quantity issued
	FROM [sap_b1].OINM AS inm                      -- warehouse-journal view
	WHERE  inm.TransType IN (60)          -- 162 = Production Issue
	  AND  inm.OutQty    > 0 

