CREATE VIEW [bc_rest_cus].[v_CUSTOMER_GROUP]
AS

    SELECT DISTINCT
        CAST([GlobalDimension2Code] AS NVARCHAR(255)) AS NO,
        CAST([GlobalDimension2Code] AS NVARCHAR(255)) AS NAME
    FROM
        bc_rest_cus.customer c
