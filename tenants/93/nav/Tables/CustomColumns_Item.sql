CREATE TABLE [nav_cus].[CustomColumns_Item] (
    [No_] NVARCHAR(20) NOT NULL,
    [Vendor No_] NVARCHAR(20) NULL,
    [Vendor Item No_] NVARCHAR(50) NULL,
    [EndurreikandDags] NVARCHAR(255) NOT NULL,
    [SolupontunarNumer] NVARCHAR(255) NOT NULL,
    [MarginPercentage] DECIMAL(38,20) NULL,
    [Margin] DECIMAL(38,20) NULL,
    CONSTRAINT [pk_ItemCC] PRIMARY KEY (No_)
);
