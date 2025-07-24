CREATE TABLE [cus].[Transformation] (
    [base_variant_code] NVARCHAR(250) NULL,
    [Can_be_Purchased] BIT NULL,
    [base_qty] DECIMAL(18,0) NULL,
    [transform_variant_code] NVARCHAR(250) NULL,
    [transform_variant_qty] DECIMAL(18,0) NULL,
    [Can_be_transformed_up] BIT NULL
);
