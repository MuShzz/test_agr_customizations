CREATE VIEW [cus].v_CUSTOMER
AS
    SELECT CAST(IDCUST AS nvarchar(255))   AS [NO],
           CAST(NAMECUST AS nvarchar(255)) AS [NAME],
           CAST(NULL AS nvarchar(255))     AS [CUSTOMER_GROUP_NO]
    FROM cus.ARCUS
