
CREATE VIEW [cus].[v_CUSTOMER_GROUP] AS
	
	SELECT
        CAST(cg.Code AS NVARCHAR(255)) AS [NO],
        CAST(cg.Name AS NVARCHAR(255)) AS [NAME],
        cg.Company
	FROM
        [cus].customer_group cg
	WHERE cg.Dimension_Code='DEPARTMENT'
	AND cg.Code IN ('1040','1050','1060','1065','1070')


