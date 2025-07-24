CREATE VIEW [cus].v_VENDOR
             AS
SELECT CAST(no AS nvarchar(255))        AS [NO],
       CAST(name AS nvarchar(255))      AS [NAME],
       CAST(lead_time_days AS smallint) AS [LEAD_TIME_DAYS],
       CAST(closed AS bit)              AS [CLOSED]
FROM cus.vendor
