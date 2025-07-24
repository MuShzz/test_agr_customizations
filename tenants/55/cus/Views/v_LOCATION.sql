


    CREATE VIEW [cus].[v_LOCATION] AS
       SELECT
            CAST(StcNo AS NVARCHAR(255)) AS [NO],
            CAST(Nm AS NVARCHAR(255)) AS [NAME]
       FROM
            [cus].[Stc]
		WHERE StcNo = 1

