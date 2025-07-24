CREATE VIEW [cus].v_LOCATION
AS
    SELECT CAST(LOCATION AS nvarchar(255)) AS [NO],
           CAST(LOCATION AS nvarchar(255)) AS [NAME]
    from cus.ICLOC
