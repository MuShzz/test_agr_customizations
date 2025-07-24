CREATE TABLE [bc_sql_cus].[CC_Item_Publication] (
    [Item No_] VARCHAR(50) NOT NULL,
    [Publication No_] VARCHAR(255) NOT NULL,
    [Status] VARCHAR(50) NULL,
    [Discontinued Date] DATE NULL,
    CONSTRAINT [PK__CC_Item___F98B8CD606C3643F] PRIMARY KEY (Item No_,Publication No_)
);
