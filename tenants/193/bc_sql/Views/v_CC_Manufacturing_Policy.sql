
CREATE VIEW bc_sql_cus.v_CC_Manufacturing_Policy
AS

	SELECT 
		No_,
		CASE 
			WHEN [Manufacturing Policy] = 0 
			THEN 'Make-to-Stock' 
			WHEN [Manufacturing Policy] = 1 
			THEN 'Make-to-Order' 
		END AS [Manufacturing Policy] 
	FROM bc_sql_cus.CC_Manifacturing_Policy
