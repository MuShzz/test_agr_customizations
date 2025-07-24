CREATE TABLE [cus].[BOMComponent] (
    [Line No_] INT NOT NULL,
    [Parent Item No_] NVARCHAR(20) NOT NULL,
    [No_] NVARCHAR(20) NOT NULL,
    [Description] NVARCHAR(100) NOT NULL,
    [Unit of Measure Code] NVARCHAR(10) NOT NULL,
    [Quantity per] DECIMAL(38,20) NOT NULL,
    [Company] NVARCHAR(3) NOT NULL,
    CONSTRAINT [PK_cus_bom_component] PRIMARY KEY (Company,Line No_,Parent Item No_)
);
