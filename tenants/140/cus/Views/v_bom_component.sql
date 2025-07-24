CREATE VIEW [cus].[v_bom_component]
AS

    SELECT
        CAST(CONCAT(RTRIM(PPN_I), ' - ', [Company]) AS NVARCHAR(128))        AS [ITEM_NO],
        CAST(CONCAT(RTRIM(CPN_I), ' - ', [Company]) AS NVARCHAR(255))        AS [COMPONENT_ITEM_NO],
        SUM(CAST(QUANTITY_I AS DECIMAL(18,4)))   AS [QUANTITY],
        [Company]
    FROM
        [cus].[BM010115]
    GROUP BY
        PPN_I, CPN_I, Company
