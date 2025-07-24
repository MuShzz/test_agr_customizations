
CREATE VIEW [dk_cus].[vw_AGREssentials_items_pivot]
AS

SELECT itemNo, 
    [bg1] AS bg1_StockUnits, 
    [kef] AS kef_StockUnits, 
    [hfj] AS hfj_StockUnits -- Add more locations as needed
FROM
(
    SELECT sl.[item_no] as itemNo, ISNULL(lms.parentLocationNo, sl.[location_no]) as locationNo, SUM(sl.[stock_units]) as stockUnits
    FROM [adi].[stock_level] sl
    inner join core.location_mapping_setup lms on sl.location_no = lms.locationNo
    group by sl.[item_no], ISNULL(lms.parentLocationNo, sl.[location_no])
) AS SourceTable
PIVOT
(
    MAX(stockUnits)
    FOR locationNo IN ([bg1], [kef], [hfj]) -- Add more locations here
) AS PivotTable;

