CREATE TABLE [bc_rest_cus].[CustomColumns_BirlStockAvailSum] (
    [Item_No] NVARCHAR(20) NOT NULL,
    [Parent_Item_No] NVARCHAR(20) NOT NULL,
    [Birlea_Stock_Available] INT NULL,
    CONSTRAINT [PK_CustomColumns_BirlStockAvailSum] PRIMARY KEY (Item_No,Parent_Item_No)
);
