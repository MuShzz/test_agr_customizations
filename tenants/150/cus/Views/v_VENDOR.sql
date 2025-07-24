

  CREATE VIEW [cus].[v_VENDOR] AS
       SELECT
            CAST(Code AS NVARCHAR(255)) AS [NO],
            CAST(Name AS NVARCHAR(255)) AS [NAME],
            CAST([Options.LeadTimeQuantity] AS SMALLINT) AS [LEAD_TIME_DAYS],
            CAST(IIF([WorkflowStatus.Code] = 'C',1,0) AS BIT) AS [CLOSED]
       FROM cus.Vendor

