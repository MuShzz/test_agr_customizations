CREATE TABLE [cus].[Assembly] (
    [ID] BIGINT NOT NULL,
    [Product.Code] NVARCHAR(255) NULL,
    [Product.Description] NVARCHAR(255) NULL,
    [_Owner_._Owner_.Description] NVARCHAR(255) NULL,
    [_Owner_._Owner_.Code] NVARCHAR(255) NULL,
    [Quantity] DECIMAL(18,4) NULL
);
