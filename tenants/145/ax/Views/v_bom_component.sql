CREATE VIEW [ax_cus].[v_bom_component] AS
	
	WITH cte AS
(
    SELECT
        CAST(iv1.NO AS NVARCHAR(255))    AS [ITEM_NO],
        CAST(iv2.NO AS NVARCHAR(255))     AS [COMPONENT_ITEM_NO],
        CAST(b.BOMQTY AS DECIMAL(18,4))     AS [QUANTITY],
        CAST(b.DATAAREAID AS NVARCHAR(4))   AS [COMPANY],
        ROW_NUMBER() OVER (
            PARTITION BY b.BOMID, b.ITEMID
            ORDER BY bv.MODIFIEDDATETIME DESC
        ) AS rn
    FROM ax.BOM b
    INNER JOIN ax.BOMVERSION bv
       ON  bv.BOMID = b.BOMID
       AND b.DATAAREAID = bv.DATAAREAID
       AND (
            b.PARTITION = bv.PARTITION 
            OR (b.PARTITION IS NULL AND bv.PARTITION IS NULL)
       )
	INNER JOIN ax_cus.Item_v iv1 ON iv1.No_TO_JOIN_IL = bv.ITEMID
	INNER JOIN ax_cus.Item_v iv2 ON iv1.No_TO_JOIN_IL = b.ITEMID
    WHERE 
        bv.ACTIVE     = 1
        AND bv.APPROVED = 1
        AND bv.ITEMID <> b.ITEMID
)
SELECT
    ITEM_NO,
    COMPONENT_ITEM_NO,
    QUANTITY,
    COMPANY
FROM cte
WHERE rn = 1;
