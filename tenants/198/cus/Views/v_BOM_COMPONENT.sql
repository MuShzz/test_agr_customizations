CREATE VIEW [cus].v_BOM_COMPONENT
             AS
            SELECT
               CAST(NULL AS nvarchar(255)) AS [ITEM_NO],
               CAST(NULL AS nvarchar(255)) AS [COMPONENT_ITEM_NO],
               CAST(NULL AS decimal(18,4)) AS [QUANTITY]
                WHERE 1 = 0;
