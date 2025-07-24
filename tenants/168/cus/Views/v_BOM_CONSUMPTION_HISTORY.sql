CREATE VIEW [cus].v_BOM_CONSUMPTION_HISTORY
AS
SELECT CAST(NULL AS bigint)                                      AS [TRANSACTION_ID],
       CAST(itemId AS nvarchar(255))                             AS [ITEM_NO],
       CAST(ISNULL(lm.SAGE_LOCATION, mp.locId) AS nvarchar(255)) AS [LOCATION_NO],
       CAST(tranDt AS date)                                      AS [DATE],
       CAST(qty AS decimal(18, 4))                               AS [UNIT_QTY]
from cus.MILOGH mp
         inner join cus.sage_misys_location_match lm on mp.locId = lm.MISYS_LOCATION and [bom] = 1
where itemId is not null
  and locId is not null
  and tranDt is not null
