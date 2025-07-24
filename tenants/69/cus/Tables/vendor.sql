CREATE TABLE [cus].[vendor] (
    [no] NVARCHAR(255) NOT NULL,
    [name] NVARCHAR(255) NOT NULL,
    [lead_time_days] SMALLINT NOT NULL,
    [closed] BIT NOT NULL,
    CONSTRAINT [PK_cus_vendor] PRIMARY KEY (no)
);
