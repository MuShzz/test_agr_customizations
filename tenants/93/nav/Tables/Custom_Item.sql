CREATE TABLE [nav_cus].[Custom_Item] (
    [No_] NVARCHAR(20) NOT NULL,
    [Birgðarflokkur] INT NULL,
    [Not for purchase] INT NULL,
    [Item not active] INT NULL,
    [Manufacturing Policy] INT NULL,
    [Endurreiknað dags_] NVARCHAR(50) NULL,
    CONSTRAINT [pk_Custom_Item] PRIMARY KEY (No_)
);
