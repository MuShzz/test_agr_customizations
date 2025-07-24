CREATE VIEW [bc_rest_cus].[v_CUSTOMER]
AS

    SELECT
        CAST([No] AS NVARCHAR(255)) AS NO,
        CAST([Name] AS NVARCHAR(255)) AS NAME,
        CAST([GlobalDimension2Code] AS NVARCHAR(255)) AS CUSTOMER_GROUP_NO
    FROM
        bc_rest_cus.customer c

