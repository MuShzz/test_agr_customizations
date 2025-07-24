CREATE TABLE [cus].[customer] (
    [no] NVARCHAR(255) NOT NULL,
    [name] NVARCHAR(255) NOT NULL,
    [type] NVARCHAR(255) NULL,
    [closed] BIT NOT NULL,
    CONSTRAINT [PK_cus_customer] PRIMARY KEY (no)
);
