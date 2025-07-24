CREATE TABLE [bc_sql_cus].[CC_Enum] (
    [EnumList] NVARCHAR(50) NOT NULL,
    [EnumValue] TINYINT NOT NULL,
    [EnumDescription] NVARCHAR(50) NOT NULL,
    [IncludeSales] BIT NOT NULL,
    [IncludeStocks] BIT NOT NULL
);
