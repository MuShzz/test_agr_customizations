CREATE TABLE [cus].[ItemPlant] (
    [Product] NVARCHAR(32) NOT NULL,
    [Plant] NVARCHAR(32) NOT NULL,
    [PurchasingGroup] NVARCHAR(32) NULL,
    [MRPType] NVARCHAR(32) NULL,
    [BaseUnit] NVARCHAR(32) NULL,
    CONSTRAINT [PK_cus_Plant_Product] PRIMARY KEY (Plant,Product)
);
