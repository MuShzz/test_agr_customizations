CREATE TABLE [ax_cus].[INVENTTABLE] (
    [ITEMID] NVARCHAR(20) NOT NULL,
    [ITEMTYPE] INT NOT NULL,
    [HEIGHT] NUMERIC(32,16) NOT NULL,
    [WIDTH] NUMERIC(32,16) NOT NULL,
    [PRIMARYVENDORID] NVARCHAR(20) NOT NULL,
    [NETWEIGHT] NUMERIC(32,16) NOT NULL,
    [DEPTH] NUMERIC(32,16) NOT NULL,
    [UNITVOLUME] NUMERIC(32,16) NOT NULL,
    [ABCREVENUE] INT NOT NULL,
    [ABCVALUE] INT NOT NULL,
    [ABCCONTRIBUTIONMARGIN] INT NOT NULL,
    [NAMEALIAS] NVARCHAR(20) NOT NULL,
    [PRODGROUPID] NVARCHAR(10) NOT NULL,
    [PROJCATEGORYID] NVARCHAR(30) NOT NULL,
    [GROSSHEIGHT] NUMERIC(32,16) NOT NULL,
    [STANDARDPALLETQUANTITY] NUMERIC(32,16) NOT NULL,
    [QTYPERLAYER] NUMERIC(32,16) NOT NULL,
    [ITEMBUYERGROUPID] NVARCHAR(10) NOT NULL,
    [TARAWEIGHT] NUMERIC(32,16) NOT NULL,
    [PRODUCT] BIGINT NOT NULL,
    [DEFAULTDIMENSION] BIGINT NOT NULL,
    [PDSBESTBEFORE] INT NOT NULL,
    [DATAAREAID] NVARCHAR(4) NOT NULL,
    [PARTITION] BIGINT NOT NULL,
    [RECID] BIGINT NOT NULL,
    [SPAFACTOR] INT NOT NULL,
    [CEWEIGHING] INT NOT NULL,
    [CEQTYPERLAYER] NUMERIC(32,16) NOT NULL,
    [CEPALLETQTY] NUMERIC(32,16) NOT NULL,
    [CEPRODUCTTYPE] INT NOT NULL,
    [AGRHEIGHT] NUMERIC(32,16) NOT NULL,
    [AGRLENGTH] NUMERIC(32,16) NOT NULL,
    [AGRPURCHQTY] INT NOT NULL,
    [AGRVOLUME] NUMERIC(32,16) NOT NULL,
    [AGRWIDTH] NUMERIC(32,16) NOT NULL,
    [CEMINIMUMLIFEONRECEPTION] INT NOT NULL,
    [CEMINIMUMLIFEONSALE] INT NOT NULL,
    CONSTRAINT [PK_ax_cus_INVENTTABLE] PRIMARY KEY (DATAAREAID,ITEMID,PARTITION)
);
