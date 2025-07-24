CREATE TABLE [nav_cus].[AGR Extended Item] (
    [timestamp] TIMESTAMP NOT NULL,
    [Item No_] NVARCHAR(20) NOT NULL,
    [Connected Item] NVARCHAR(20) NOT NULL,
    [Connected From] DATETIME NOT NULL,
    [Connected To] DATETIME NOT NULL,
    [Scale] DECIMAL(38,20) NOT NULL,
    [Connection Duration] INT NOT NULL,
    [Connect Sale History] TINYINT NOT NULL,
    [Connect Stock History] TINYINT NOT NULL,
    [Sale Overlap] INT NOT NULL,
    [Order Frequency] INT NOT NULL,
    CONSTRAINT [nav_cus$AGR Extended Item$0] PRIMARY KEY (Connected Item,Item No_)
);
