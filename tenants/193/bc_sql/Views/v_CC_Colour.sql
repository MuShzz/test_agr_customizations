CREATE VIEW bc_sql_cus.v_CC_Colour AS
	SELECT 
		No_,
		FinishDescription AS Colour 
	FROM bc_sql_cus.CC_Commercial_Status_Code 
		INNER JOIN bc_sql_cus.CC_Finish ON [ACO Finish$a3d760bd-9288-4964-acc7-2649e678307d] = FinishCode 
