CREATE TABLE [cus].[ItemDescription] (
    [Product] NVARCHAR(128) NOT NULL,
    [Language] NVARCHAR(128) NOT NULL,
    [ProductDescription] NVARCHAR(128) NULL,
    CONSTRAINT [PK_cus_ItemDesc] PRIMARY KEY (Language,Product)
);
