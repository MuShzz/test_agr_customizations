CREATE TABLE [bc_sql_cus].[OCAGRSKU] (
    [Item No_] NVARCHAR(20) NOT NULL,
    [Location] NVARCHAR(20) NOT NULL,
    [Supplier] NVARCHAR(20) NOT NULL,
    [Order From Type] INT NOT NULL,
    [Minimum Order Quantity] DECIMAL(18,4) NOT NULL,
    [Order Frequency (days)] INT NOT NULL,
    [AGR Lead time] INT NOT NULL,
    [company] NVARCHAR(4) NULL,
    CONSTRAINT [pk_cus_OCAGRSKU] PRIMARY KEY (Item No_,Location,Supplier)
);
