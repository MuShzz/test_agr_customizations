CREATE TABLE [bc_sql_cus].[AssemblyHeader] (
    [Document Type] INT NOT NULL,
    [No_] NVARCHAR(20) NOT NULL,
    [Item No_] NVARCHAR(20) NOT NULL,
    [Variant Code] NVARCHAR(10) NOT NULL,
    [Location Code] NVARCHAR(50) NOT NULL,
    [Status] INT NOT NULL,
    [Quantity] NUMERIC(38,20) NULL,
    [Quantity to Assemble] NUMERIC(38,10) NULL,
    [Remaining Quantity (Base)] DECIMAL(38,10) NULL,
    [Remaining Quantity] DECIMAL(38,10) NULL,
    [Due Date] DATE NULL,
    CONSTRAINT [PK_cus_AssemblyHeader] PRIMARY KEY (Document Type,Item No_,No_,Variant Code)
);
