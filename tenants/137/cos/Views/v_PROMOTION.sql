CREATE VIEW [cos_cus].[v_PROMOTION]
AS

WITH DistinctPromo AS
         (
             -- Step 1: Remove exact duplicates (optional if your data can have identical rows)
             SELECT DISTINCT
                 Item       = p.ITEM_NO
                           , Location   = p.LOCATION_NO
                           , StartDate  = p.PERIOD_START
                           , EndDate    = p.PERIOD_END
             FROM cos.agr_Promotion AS p
         ),
     Ordered AS
         (
             -- Step 2: Sort by StartDate (per Item/Location) and get the "running max" EndDate
             SELECT
                 Item
                  , Location
                  , StartDate
                  , EndDate
                  , RunningMaxEnd = MAX(EndDate) OVER (
                 PARTITION BY Item, Location
                 ORDER BY StartDate
                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                 )
             FROM DistinctPromo
         ),
     Marked AS
         (
             -- Step 3: Compare current StartDate to the previous row's running max EndDate
             -- LAG(RunningMaxEnd) gives the "running max" from the row before this one.
             SELECT
                 Item
                  , Location
                  , StartDate
                  , EndDate
                  , CASE
                        WHEN StartDate <= DATEADD(DAY, 1,
                                                  LAG(RunningMaxEnd) OVER (
                                                      PARTITION BY Item, Location
                                                      ORDER BY StartDate
                                                      )
                                          )
                            THEN 0
                        ELSE 1
                 END AS IsBreak
             FROM Ordered
         ),
     Islanded AS
         (
             -- Step 4: Running sum of IsBreak to group intervals into "islands"
             SELECT
                 Item
                  , Location
                  , StartDate
                  , EndDate
                  , Grp = SUM(IsBreak) OVER (
                 PARTITION BY Item, Location
                 ORDER BY StartDate
                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                 )
             FROM Marked
         )
-- Step 5: Collapse to one row per group => the merged intervals
SELECT distinct
    Item as [ITEM_NO]
              , Location as [LOCATION_NO]
              , MIN(StartDate) AS [PERIOD_START]
              , MAX(EndDate) AS [PERIOD_END]
FROM Islanded
GROUP BY
    Item
       , Location
       , Grp
