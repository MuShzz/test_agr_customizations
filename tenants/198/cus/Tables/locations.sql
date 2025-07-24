CREATE TABLE [cus].[locations] (
    [LocationNo] NVARCHAR(50) NOT NULL,
    [Name] NVARCHAR(50) NOT NULL,
    [Type_store_or_warehouse] NVARCHAR(50) NOT NULL,
    [created_date] DATETIME NULL DEFAULT (sysdatetime()),
    CONSTRAINT [PK_locations] PRIMARY KEY (LocationNo)
);
