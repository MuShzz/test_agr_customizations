CREATE TABLE [bc_rest_cus].[CustomColumns_Item] (
    [No] NVARCHAR(20) NOT NULL,
    [RemovedFromWeb] BIT NULL,
    [Webactive] BIT NULL,
    [StandardCost] DECIMAL(18,4) NULL,
    [UnitsperParcel] DECIMAL(18,4) NULL,
    CONSTRAINT [PK_CustomColumns_Item] PRIMARY KEY (No)
);
