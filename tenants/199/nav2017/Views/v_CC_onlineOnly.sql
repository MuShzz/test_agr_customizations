

CREATE VIEW [nav2017_cus].[v_CC_onlineOnly] AS
    SELECT 
        i.itemNo,
        i.locationNo,
        CASE
            WHEN i.itemName LIKE '%~%' THEN 1
            ELSE 0
        END AS onlineOnly
    FROM
    dbo.AGREssentials_items i

