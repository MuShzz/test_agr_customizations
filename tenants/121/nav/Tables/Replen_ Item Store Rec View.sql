CREATE TABLE [nav_cus].[Replen_ Item Store Rec View] (
    [Item No_] NVARCHAR(20) NOT NULL,
    [Location Code] NVARCHAR(20) NOT NULL,
    [xReplen_ Method NOT USED] INT NULL,
    [Exclude from Replenishment] INT NULL,
    [Transfer Multiple] DECIMAL(18,4) NULL,
    [Order Multiple] DECIMAL(18,4) NULL,
    [Block Purchasing] INT NULL,
    [Block Transferring] INT NULL
);
