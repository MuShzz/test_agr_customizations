CREATE TABLE [bc_rest_cus].[CC_Assortments] (
    [no_] NVARCHAR(20) NOT NULL,
    [manufacturercode] NVARCHAR(20) NOT NULL,
    [kjedesortiment] BIT NOT NULL,
    [sesong_innkjop] NVARCHAR(255) NOT NULL,
    [sortiment_oslo] BIT NOT NULL,
    [sortiment_enebakk] BIT NOT NULL,
    CONSTRAINT [pk_CC_Assortments] PRIMARY KEY (no_)
);
