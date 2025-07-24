CREATE VIEW [cus].v_VENDOR
AS
SELECT CAST(suplId AS nvarchar(255))                                                                      AS [NO],
       CAST(shortName AS nvarchar(255))                                                                   AS [NAME],
       case
           when CAST(daysTotal AS int) > 32000 then 7
           else CAST(ISNULL(daysTotal, 7) AS smallint) end                                                AS [LEAD_TIME_DAYS],
       CAST(supStatus AS bit)                                                                             AS [CLOSED]
from cus.MISUPL
