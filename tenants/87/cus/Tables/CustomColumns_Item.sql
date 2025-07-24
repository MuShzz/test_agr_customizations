CREATE TABLE [cus].[CustomColumns_Item] (
    [No] NVARCHAR(255) NOT NULL,
    [Planner_ID_GRBAS] NVARCHAR(255) NULL,
    [Class_GRBAS] NVARCHAR(255) NULL,
    [Company] NVARCHAR(100) NOT NULL,
    CONSTRAINT [pk_cus_Custom_Columns_Item] PRIMARY KEY (Company,No)
);
