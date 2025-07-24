CREATE VIEW [cus].v_LOCATION
             AS
            SELECT
               CAST([LocationNo] AS nvarchar(255)) AS [NO],
               CAST([Name] AS nvarchar(255)) AS [NAME]
                FROM
					[cus].Locations
