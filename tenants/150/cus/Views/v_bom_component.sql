
CREATE VIEW [cus].[v_bom_component] AS
	
	SELECT
		CAST([_Owner_._Owner_.Code]  AS NVARCHAR(255)) AS ITEM_NO,
		CAST([Product.Code] AS NVARCHAR(255)) AS COMPONENT_ITEM_NO,
		CAST(Quantity AS DECIMAL(18,4)) AS QUANTITY
	FROM cus.Assembly

