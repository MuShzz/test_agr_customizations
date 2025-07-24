CREATE TABLE [bc_sql_cus].[production_bom_line_jose] (
    [Production BOM No_] NVARCHAR(20) NOT NULL,
    [Line No_] INT NOT NULL,
    [Type] NVARCHAR(50) NOT NULL,
    [No_] NVARCHAR(20) NOT NULL,
    [Unit of Measure Code] NVARCHAR(10) NOT NULL,
    [Quantity per] NUMERIC(38,20) NOT NULL,
    CONSTRAINT [PK__producti__109F5E8CD55FFFB2] PRIMARY KEY (Line No_,Production BOM No_)
);
