CREATE VIEW [cus].[v_nextExpectedPonumber]
AS
SELECT pl.ItemCode,
       ISNULL(ls_parent.locationNo, ls.locationNo) as LOCATION_NO,
       MIN(p.DocDueDate)                           AS mindate,
       CAST(MIN(p.DocNum) AS NVARCHAR(255))        AS DocNum
FROM cus.POR1 pl
         INNER JOIN cus.OPOR p ON p.DocEntry = pl.DocEntry
         INNER JOIN core.location_mapping_setup ls ON ls.locationNo = pl.WhsCode
         LEFT JOIN core.location_mapping_setup ls_parent ON ls.parentLocationId = ls_parent.id
WHERE pl.LineStatus = 'O'
  AND pl.ItemCode IS NOT NULL
  AND pl.WhsCode IS NOT NULL
GROUP BY pl.ItemCode,
         ISNULL(ls_parent.locationNo, ls.locationNo)
