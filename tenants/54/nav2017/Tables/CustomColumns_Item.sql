CREATE TABLE [nav2017_cus].[CustomColumns_Item] (
    [No_] NVARCHAR(20) NOT NULL,
    [Fortress Item No_] NVARCHAR(255) NOT NULL,
    [Replenishment Type] NVARCHAR(255) NULL,
    [Replenishment System] NVARCHAR(255) NULL,
    [Standard Cost] DECIMAL(38,20) NULL,
    CONSTRAINT [PK_nav2017_cus_CustomColumns_Item] PRIMARY KEY (No_)
);
