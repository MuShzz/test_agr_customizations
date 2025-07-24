CREATE VIEW [cus].v_LOCATION
AS
SELECT CAST(no AS nvarchar(255))   AS [NO],
       CAST(name AS nvarchar(255)) AS [NAME]
FROM cus.location
