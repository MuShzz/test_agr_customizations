CREATE TABLE [nav_cus].[ILEExtraInfo] (
    [Entry No_] INT NOT NULL,
    [Item No_] NVARCHAR(20) NOT NULL,
    [Remaining Quantity] DECIMAL(38,20) NOT NULL,
    [Open] TINYINT NOT NULL,
    CONSTRAINT [nav_cus_PK_ILEExtraInfo] PRIMARY KEY (Entry No_)
);
