CREATE VIEW [cus].v_ITEM_GROUP AS
    
    with groups as (
        --lvl 2
        SELECT
            CAST(sc.CategoryCode AS nvarchar(255)) AS [NO],
            CAST(sc.CategoryCode AS nvarchar(255)) AS [NAME]
        FROM cus.SystemCategory sc
        WHERE sc.IsActive=1

        union all
        --lvl1
        SELECT
            CAST(sc.ParentCategory AS nvarchar(255)) AS [NO],
            CAST(sc.ParentCategory AS nvarchar(255)) AS [NAME]
        FROM cus.SystemCategory sc
        WHERE sc.IsActive=1
        group by ParentCategory
    )
    select 
        g.NO AS [NO],
        g.NAME AS [NAME]
    from groups g
    group by 
        g.NO, g.NAME
