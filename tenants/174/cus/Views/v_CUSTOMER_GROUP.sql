CREATE VIEW [cus].[v_CUSTOMER_GROUP]
AS

	SELECT DISTINCT
		CAST(c.STATISTICSGROUP AS NVARCHAR(255))              AS [NO],
		CAST(c.STATISTICSGROUP AS NVARCHAR(255))			AS [NAME]
	FROM cus.CUSTTABLE c


