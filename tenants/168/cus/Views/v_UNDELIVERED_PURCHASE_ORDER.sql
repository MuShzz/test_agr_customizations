CREATE VIEW [cus].v_UNDELIVERED_PURCHASE_ORDER
AS
SELECT CAST(mp.pohId AS varchar(128)) + '-' + CAST(mp.podId AS varchar(128))    AS [PURCHASE_ORDER_NO],
       CAST(mp.itemId AS nvarchar(255))                                         AS [ITEM_NO],
       CAST(ISNULL(lm.SAGE_LOCATION, mp.locId) AS nvarchar(255))                AS [LOCATION_NO],
       CAST(ISNULL(mp.realDueDate, mp.initDueDate) AS date)                     AS [DELIVERY_DATE],
       CAST(mp.ordered AS decimal(18, 4)) - CAST(mp.received AS decimal(18, 4)) AS [QUANTITY]
from cus.MIPOD mp
         inner join cus.sage_misys_location_match lm on mp.locId = lm.MISYS_LOCATION and [undelivered] = 1
WHERE mp.dStatus = 1
  and mp.itemId is not null
  and mp.locId is not null
