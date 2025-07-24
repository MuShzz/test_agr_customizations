CREATE TABLE [nav_cus].[Replen_ Item Store Rec] (
    [Item No_] NVARCHAR(20) NOT NULL,
    [Variant Code] NVARCHAR(20) NOT NULL,
    [Location Code] NVARCHAR(20) NOT NULL,
    [Active From Date] DATETIME NOT NULL,
    [xReplen_ Method NOT USED] INT NULL,
    [Exclude from Replenishment] INT NULL,
    CONSTRAINT [PK_nav_cus_replen_item] PRIMARY KEY (Item No_,Location Code,Variant Code)
);
