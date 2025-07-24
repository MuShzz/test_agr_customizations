CREATE TABLE [nav_cus].[ItemExtraInfo] (
    [No_] NVARCHAR(20) NOT NULL,
    [Global Dimension 1 Code] NVARCHAR(20) NOT NULL,
    [Item Status] INT NOT NULL,
    [Deliv_ Performance Requirement] INT NOT NULL,
    [Short Expiry Dates] INT NOT NULL,
    [Contract Item] TINYINT NOT NULL,
    [Contract No_] NVARCHAR(10) NOT NULL,
    [Storage Method] INT NOT NULL,
    [Reserved Inventory] DECIMAL(38,20) NOT NULL,
    [Emergency Stock] DECIMAL(28,10) NOT NULL,
    CONSTRAINT [PK_nav_cus_ItemExtraInfo] PRIMARY KEY (No_)
);
