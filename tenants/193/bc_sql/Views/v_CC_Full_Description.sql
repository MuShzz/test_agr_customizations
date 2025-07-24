CREATE VIEW bc_sql_cus.v_CC_Full_Description
AS

SELECT No_, RTRIM([Description]) + RTRIM(LTRIM([Description 2])) AS [Full Description] FROM bc_sql.Item
