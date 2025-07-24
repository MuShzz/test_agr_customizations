CREATE   VIEW [cus].[v_VENDOR]
AS
WITH cteVendor AS
(
    SELECT
        s.pkSupplierID,
        s.SupplierName,
        s.bLogicalDelete,
        ROW_NUMBER() OVER (
            PARTITION BY s.SupplierName
            ORDER BY 
                CASE WHEN s.bLogicalDelete = 'False' THEN 0 ELSE 1 END,
                s.pkSupplierID
        ) AS rn
    FROM cus.Supplier s
)
SELECT
    CAST(SupplierName   AS NVARCHAR(255)) AS [NO],
    CAST(SupplierName   AS NVARCHAR(255)) AS [NAME],
    CAST(1              AS SMALLINT)      AS [LEAD_TIME_DAYS],
    CAST(bLogicalDelete AS BIT)           AS [CLOSED]
FROM cteVendor
WHERE rn = 1;

