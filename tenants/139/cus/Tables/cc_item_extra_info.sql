CREATE TABLE [cus].[cc_item_extra_info] (
    [No] NVARCHAR(20) NOT NULL,
    [PG_Device_Series] NVARCHAR(50) NULL,
    [PG_Budget_Category] NVARCHAR(50) NULL,
    [PG_Production_Status] NVARCHAR(50) NULL,
    [Company] NVARCHAR(100) NOT NULL,
    CONSTRAINT [pk_cus_cc_item_extra_info] PRIMARY KEY (Company,No)
);
