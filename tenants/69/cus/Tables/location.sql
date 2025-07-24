CREATE TABLE [cus].[location] (
    [no] NVARCHAR(255) NOT NULL,
    [name] NVARCHAR(255) NOT NULL,
    [group] NVARCHAR(255) NULL,
    [type] NVARCHAR(255) NULL,
    [closed] BIT NOT NULL,
    [opening_date] DATE NULL,
    [closing_date] DATE NULL,
    CONSTRAINT [PK_cus_location] PRIMARY KEY (no)
);
