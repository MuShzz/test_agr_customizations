CREATE TABLE [nav_cus].[ItemExtraInfo] (
    [No_] NVARCHAR(20) NOT NULL,
    [Not Allowed To Buy] NVARCHAR(20) NULL,
    [Default Box Size Purchase] DECIMAL(38,20) NOT NULL,
    CONSTRAINT [PK_nav_ItemExtraInfo] PRIMARY KEY (No_)
);
