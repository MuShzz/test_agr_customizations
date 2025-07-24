CREATE TABLE [cus].[Txt] (
    [Lang] INT NOT NULL,
    [TxtTp] INT NOT NULL,
    [TxtNo] INT NOT NULL,
    [LnNo] INT NOT NULL,
    [Txt] NVARCHAR(250) NULL,
    CONSTRAINT [PK_cus_Txt] PRIMARY KEY (Lang,LnNo,TxtTp)
);
