CREATE TABLE [cus].[PURCHLINE] (
    [PURCHID] NVARCHAR(20) NOT NULL,
    [LINENUM] NUMERIC(18,2) NOT NULL,
    [ITEMID] NVARCHAR(20) NOT NULL,
    [PURCHSTATUS] INT NOT NULL,
    [SHIPPINGDATEREQUESTED] DATETIME NOT NULL,
    [LEDGERACCOUNT] NVARCHAR(20) NOT NULL,
    [DELIVERYDATE] DATETIME NOT NULL,
    [NAME] NVARCHAR(1000) NOT NULL,
    [TAXGROUP] NVARCHAR(10) NOT NULL,
    [QTYORDERED] NUMERIC(18,2) NOT NULL,
    [PURCHRECEIVEDNOW] NUMERIC(18,2) NOT NULL,
    [REMAINPURCHPHYSICAL] NUMERIC(18,2) NOT NULL,
    [REMAINPURCHFINANCIAL] NUMERIC(18,2) NOT NULL,
    [PRICEUNIT] NUMERIC(18,2) NOT NULL,
    [PURCHPRICE] NUMERIC(18,2) NOT NULL,
    [CURRENCYCODE] NVARCHAR(3) NOT NULL,
    [LINEPERCENT] NUMERIC(18,2) NOT NULL,
    [LINEDISC] NUMERIC(18,2) NOT NULL,
    [LINEAMOUNT] NUMERIC(18,2) NOT NULL,
    [EXTERNALITEMID] NVARCHAR(20) NOT NULL,
    [PURCHUNIT] NVARCHAR(10) NOT NULL,
    [DIMENSION] NVARCHAR(10) NOT NULL,
    [DIMENSION2_] NVARCHAR(10) NOT NULL,
    [DIMENSION3_] NVARCHAR(10) NOT NULL,
    [CONFIRMEDDLV] DATETIME NOT NULL,
    [ADDRESSREFRECID] BIGINT NOT NULL,
    [INVENTTRANSID] NVARCHAR(20) NOT NULL,
    [VENDGROUP] NVARCHAR(10) NOT NULL,
    [VENDACCOUNT] NVARCHAR(20) NOT NULL,
    [ADDRESSREFTABLEID] INT NOT NULL,
    [PURCHQTY] NUMERIC(18,2) NOT NULL,
    [PURCHMARKUP] NUMERIC(18,2) NOT NULL,
    [INVENTRECEIVEDNOW] NUMERIC(18,2) NOT NULL,
    [MULTILNDISC] NUMERIC(18,2) NOT NULL,
    [MULTILNPERCENT] NUMERIC(18,2) NOT NULL,
    [PURCHASETYPE] INT NOT NULL,
    [REMAININVENTPHYSICAL] NUMERIC(18,2) NOT NULL,
    [TAXITEMGROUP] NVARCHAR(10) NOT NULL,
    [SHIPPINGDATECONFIRMED] DATETIME NOT NULL,
    [TAXAUTOGENERATED] INT NOT NULL,
    [UNDERDELIVERYPCT] NUMERIC(18,2) NOT NULL,
    [OVERDELIVERYPCT] NUMERIC(18,2) NOT NULL,
    [BARCODE] NVARCHAR(80) NOT NULL,
    [BARCODETYPE] NVARCHAR(10) NOT NULL,
    [INVENTREFID] NVARCHAR(20) NOT NULL,
    [INVENTREFTRANSID] NVARCHAR(20) NOT NULL,
    [ITEMREFTYPE] INT NOT NULL,
    [BLOCKED] INT NOT NULL,
    [COMPLETE] INT NOT NULL,
    [REQPLANIDSCHED] NVARCHAR(10) NOT NULL,
    [REQPOID] NVARCHAR(20) NOT NULL,
    [LINEHEADER] NVARCHAR(80) NOT NULL,
    [SCRAP] INT NOT NULL,
    [RETURNACTIONID] NVARCHAR(10) NOT NULL,
    [INVENTDIMID] NVARCHAR(20) NOT NULL,
    [ASSETID] NVARCHAR(20) NOT NULL,
    [ASSETTRANSTYPEPURCH] INT NOT NULL,
    [ASSETBOOKID] NVARCHAR(10) NOT NULL,
    [PROJTAXITEMGROUPID] NVARCHAR(10) NOT NULL,
    [PROJTAXGROUPID] NVARCHAR(10) NOT NULL,
    [PROJSALESCURRENCYID] NVARCHAR(3) NOT NULL,
    [PROJSALESUNITID] NVARCHAR(10) NOT NULL,
    [DELIVERYTYPE] INT NOT NULL,
    [CUSTOMERREF] NVARCHAR(60) NOT NULL,
    [CUSTPURCHASEORDERFORMNUM] NVARCHAR(20) NOT NULL,
    [BLANKETREFTRANSID] NVARCHAR(20) NOT NULL,
    [DATAAREAID] NVARCHAR(4) NOT NULL,
    [RECVERSION] INT NOT NULL,
    [RECID] BIGINT NOT NULL,
    [DELIVERYADDRESS] NVARCHAR(250) NOT NULL,
    [DELIVERYNAME] NVARCHAR(60) NOT NULL,
    [DELIVERYSTREET] NVARCHAR(250) NOT NULL,
    [DELIVERYZIPCODE] NVARCHAR(10) NOT NULL,
    [DELIVERYCITY] NVARCHAR(60) NOT NULL,
    [DELIVERYCOUNTY] NVARCHAR(10) NOT NULL,
    [DELIVERYSTATE] NVARCHAR(10) NOT NULL,
    [DELIVERYCOUNTRYREGIONID] NVARCHAR(10) NOT NULL,
    [TRANSACTIONCODE] NVARCHAR(10) NOT NULL,
    [TRANSPORT] NVARCHAR(10) NOT NULL,
    [STATPROCID] NVARCHAR(10) NOT NULL,
    [PORT] NVARCHAR(10) NOT NULL,
    [STATTRIANGULARDEAL] INT NOT NULL,
    [TOLLSKYRSLUNR] NVARCHAR(10) NOT NULL,
    [CESECONDARYPURCHUNIT] NVARCHAR(10) NOT NULL,
    [CESECONDARYPURCHQTY] NUMERIC(18,2) NOT NULL,
    [CREATEDDATETIME] DATETIME NOT NULL,
    [AWSINSPECTIONREQUIRED] INT NOT NULL,
    [PROJTRANSID] NVARCHAR(20) NOT NULL,
    [PROJCATEGORYID] NVARCHAR(10) NOT NULL,
    [PROJID] NVARCHAR(10) NOT NULL,
    [PROJLINEPROPERTYID] NVARCHAR(10) NOT NULL,
    [PROJSALESPRICE] NUMERIC(18,2) NOT NULL,
    [ITEMTAGGING] INT NOT NULL,
    [CASETAGGING] INT NOT NULL,
    [PALLETTAGGING] INT NOT NULL,
    [DEL_INTERCOMPANYRETURNACTIONID] NVARCHAR(10) NOT NULL,
    [DEL_INTERCOMPANYRETURNACTIO102] NVARCHAR(60) NOT NULL,
    [REMAININVENTFINANCIAL] NUMERIC(18,2) NOT NULL,
    [PURCHREQLINEREFID] NVARCHAR(60) NOT NULL,
    [ACTIVITYNUMBER] NVARCHAR(10) NOT NULL,
    [RETURNSTATUS] INT NOT NULL,
    [RETURNDISPOSITIONCODEID] NVARCHAR(10) NOT NULL,
    [CREATEFIXEDASSET] INT NOT NULL,
    [ASSETGROUP] NVARCHAR(10) NOT NULL,
    [REQUISITIONER] NVARCHAR(20) NOT NULL,
    [REQATTENTION] NVARCHAR(255) NOT NULL,
    [PURCHREQID] NVARCHAR(20) NOT NULL,
    [GSTHSTTAXTYPE_CA] INT NOT NULL,
    [DEL_DLVSTATE] NVARCHAR(10) NOT NULL,
    [DEL_REFDLVZIPCODE] BIGINT NOT NULL,
    [DEL_CORRECTIVEREASON] NTEXT NULL,
    CONSTRAINT [pk_constraint_PURCHLINE_recid] PRIMARY KEY (RECID)
);
