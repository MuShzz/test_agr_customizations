CREATE TABLE [nav_cus].[Afhendingar] (
    [timestamp] TIMESTAMP NOT NULL,
    [Verknúmer] VARCHAR(20) NULL,
    [Afhendingarnúmer] INT NULL,
    [Vörunúmer] VARCHAR(20) NULL,
    [Línunúmer] INT NULL,
    [Tegund] INT NULL,
    [Magn] DECIMAL(38,20) NULL,
    [Dagsetning] DATETIME NULL,
    [Móttakandi] VARCHAR(10) NULL,
    [Notandi] VARCHAR(20) NULL,
    [Heiti móttakanda] VARCHAR(30) NULL,
    [Afhent kl_] DATETIME NULL,
    [Þjónustupöntun] VARCHAR(20) NULL,
    [Millifærslupöntun] VARCHAR(20) NULL,
    [BókarLínunúmer] INT NULL,
    [Lánað] TINYINT NULL,
    [Frá lager] VARCHAR(10) NULL,
    [Til lagers] VARCHAR(10) NULL,
    [Sniðmát] VARCHAR(10) NULL,
    [Keyrsla] VARCHAR(10) NULL,
    [Frá staðsetning] VARCHAR(10) NULL,
    [Til staðsetning] VARCHAR(10) NULL,
    [Raðnúmer] VARCHAR(20) NULL,
    [Beiðni númer] VARCHAR(20) NULL,
    [Verð] DECIMAL(38,20) NULL,
    [Kostnaðarverð] DECIMAL(38,20) NULL,
    [Þjónustuvöruflokkur] VARCHAR(20) NULL,
    [Yfirflokkur vöru] VARCHAR(20) NULL,
    [Undirflokkur vöru] VARCHAR(20) NULL,
    [Þjónustupöntunartegund] VARCHAR(20) NULL,
    [Shortcut Dimension 1 Code] VARCHAR(20) NULL,
    [Shortcut Dimension 2 Code] VARCHAR(20) NULL
);
