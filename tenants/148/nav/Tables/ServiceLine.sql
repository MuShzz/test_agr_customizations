CREATE TABLE [nav_cus].[ServiceLine] (
    [Document Type] INT NOT NULL,
    [Document No_] NVARCHAR(20) NOT NULL,
    [Line No_] INT NOT NULL,
    [Customer No_] NVARCHAR(20) NOT NULL,
    [Type] INT NOT NULL,
    [No_] NVARCHAR(20) NOT NULL,
    [Location Code] NVARCHAR(10) NOT NULL,
    [Posting Group] NVARCHAR(20) NOT NULL,
    [Description] NVARCHAR(100) NOT NULL,
    [Description 2] NVARCHAR(50) NOT NULL,
    [Unit of Measure] NVARCHAR(50) NOT NULL,
    [Quantity] DECIMAL(38,20) NOT NULL,
    [Outstanding Quantity] DECIMAL(38,20) NOT NULL,
    [Qty_ to Invoice] DECIMAL(38,20) NOT NULL,
    [Qty_ to Ship] DECIMAL(38,20) NOT NULL,
    [Unit Price] DECIMAL(38,20) NOT NULL,
    [Amount] DECIMAL(38,20) NOT NULL,
    [Amount Including VAT] DECIMAL(38,20) NOT NULL,
    [Gen_ Prod_ Posting Group] NVARCHAR(20) NOT NULL,
    [Delivered] INT NULL,
    CONSTRAINT [pk_nav_cus_ServiceLine] PRIMARY KEY (Document No_,Document Type,Line No_)
);
