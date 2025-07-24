CREATE VIEW [cus].[v_vendor]
AS
 
       SELECT
            CAST(VENDORID AS NVARCHAR(255))  AS [NO],
            CAST(VENDNAME AS NVARCHAR(255))  AS [NAME],
            CAST('1' AS SMALLINT)               AS [LEAD_TIME_DAYS],
            CAST(HOLD AS BIT)                AS [CLOSED],
            [Company]
        FROM
            [cus].[PM00200] 


