CREATE TABLE [nav_cus].[ItemExtraInfo] (
    [No_] NVARCHAR(20) NOT NULL,
    [Manufacturing Policy] NVARCHAR(1) NULL,
    [Global Dimension 1 Code] NVARCHAR(20) NULL,
    [Global Dimension 2 Code] NVARCHAR(20) NULL,
    [min] INT NULL,
    [max] INT NULL,
    [Purchasing Blocked] TINYINT NULL,
    CONSTRAINT [pk_ItemExtraInfo] PRIMARY KEY (No_)
);
