CREATE TABLE [cus].[location_mapping_setup] (
    [location_no] NVARCHAR(255) NOT NULL,
    [location_no_target] NVARCHAR(255) NOT NULL,
    [location_type] NVARCHAR(10) NULL,
    [include] BIT NOT NULL,
    [is_virtual] BIT NOT NULL DEFAULT ((0)),
    CONSTRAINT [PK_core_location_mapping_setup] PRIMARY KEY (location_no)
);
