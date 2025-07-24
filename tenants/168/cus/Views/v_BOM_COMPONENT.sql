CREATE VIEW [cus].v_BOM_COMPONENT
AS
SELECT CAST(bomItem AS nvarchar(255))        AS [ITEM_NO],
       CAST(partId AS nvarchar(255))         AS [COMPONENT_ITEM_NO],
       SUM(ABS(CAST(qty AS decimal(18, 4)))) AS [QUANTITY]
from cus.MIBOMD m
where partId is not null
  and bomItem is not null
  and bomRev = (select max(bomRev)
                from cus.MIBOMD
                where bomItem = m.bomItem)
group by bomItem, partId
