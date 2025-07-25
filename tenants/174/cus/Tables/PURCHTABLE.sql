CREATE TABLE [cus].[PURCHTABLE] (
    [PURCHID] NVARCHAR(20) NOT NULL,
    [PURCHNAME] NVARCHAR(60) NOT NULL,
    [ORDERACCOUNT] NVARCHAR(20) NOT NULL,
    [INVOICEACCOUNT] NVARCHAR(20) NOT NULL,
    [FREIGHTZONE] NVARCHAR(10) NOT NULL,
    [EMAIL] NVARCHAR(80) NOT NULL,
    [DELIVERYDATE] DATETIME NOT NULL,
    [DELIVERYTYPE] INT NOT NULL,
    [ADDRESSREFRECID] BIGINT NOT NULL,
    [ADDRESSREFTABLEID] INT NOT NULL,
    [INTERCOMPANYORIGINALSALESID] NVARCHAR(20) NOT NULL,
    [INTERCOMPANYORIGINALCUSTACCO12] NVARCHAR(20) NOT NULL,
    [CURRENCYCODE] NVARCHAR(3) NOT NULL,
    [PAYMENT] NVARCHAR(10) NOT NULL,
    [CASHDISC] NVARCHAR(10) NOT NULL,
    [PURCHPLACER] NVARCHAR(20) NOT NULL,
    [VENDGROUP] NVARCHAR(10) NOT NULL,
    [LINEDISC] NVARCHAR(10) NOT NULL,
    [DISCPERCENT] NUMERIC(18,2) NOT NULL,
    [DIMENSION] NVARCHAR(10) NOT NULL,
    [DIMENSION2_] NVARCHAR(10) NOT NULL,
    [DIMENSION3_] NVARCHAR(10) NOT NULL,
    [PRICEGROUPID] NVARCHAR(10) NOT NULL,
    [MULTILINEDISC] NVARCHAR(10) NOT NULL,
    [ENDDISC] NVARCHAR(10) NOT NULL,
    [INTERCOMPANYCUSTPURCHORDERFO26] NVARCHAR(20) NOT NULL,
    [DELIVERYADDRESS] NVARCHAR(250) NOT NULL,
    [TAXGROUP] NVARCHAR(10) NOT NULL,
    [DLVTERM] NVARCHAR(10) NOT NULL,
    [DLVMODE] NVARCHAR(10) NOT NULL,
    [PURCHSTATUS] INT NOT NULL,
    [MARKUPGROUP] NVARCHAR(10) NOT NULL,
    [PURCHASETYPE] INT NOT NULL,
    [URL] NVARCHAR(255) NOT NULL,
    [POSTINGPROFILE] NVARCHAR(10) NOT NULL,
    [DELIVERYZIPCODE] NVARCHAR(10) NOT NULL,
    [DLVCOUNTY] NVARCHAR(10) NOT NULL,
    [DLVCOUNTRYREGIONID] NVARCHAR(10) NOT NULL,
    [DLVSTATE] NVARCHAR(10) NOT NULL,
    [SETTLEVOUCHER] INT NOT NULL,
    [CASHDISCPERCENT] NUMERIC(18,2) NOT NULL,
    [DELIVERYNAME] NVARCHAR(60) NOT NULL,
    [ONETIMEVENDOR] INT NOT NULL,
    [RETURNITEMNUM] NVARCHAR(10) NOT NULL,
    [FREIGHTSLIPTYPE] INT NOT NULL,
    [DOCUMENTSTATUS] INT NOT NULL,
    [CONTACTPERSONID] NVARCHAR(20) NOT NULL,
    [INVENTLOCATIONID] NVARCHAR(10) NOT NULL,
    [ITEMBUYERGROUPID] NVARCHAR(10) NOT NULL,
    [PURCHPOOLID] NVARCHAR(10) NOT NULL,
    [VATNUM] NVARCHAR(20) NOT NULL,
    [INCLTAX] INT NOT NULL,
    [NUMBERSEQUENCEGROUP] NVARCHAR(10) NOT NULL,
    [LANGUAGEID] NVARCHAR(7) NOT NULL,
    [AUTOSUMMARYMODULETYPE] INT NOT NULL,
    [DEL_PRINTMODULETYPE] INT NOT NULL,
    [PAYMMODE] NVARCHAR(10) NOT NULL,
    [PAYMSPEC] NVARCHAR(10) NOT NULL,
    [FIXEDDUEDATE] DATETIME NOT NULL,
    [DELIVERYCITY] NVARCHAR(60) NOT NULL,
    [DELIVERYSTREET] NVARCHAR(250) NOT NULL,
    [VENDORREF] NVARCHAR(60) NOT NULL,
    [CREATEDDATETIME] DATETIME NOT NULL,
    [DATAAREAID] NVARCHAR(4) NOT NULL,
    [RECVERSION] INT NOT NULL,
    [RECID] BIGINT NOT NULL,
    [TRANSACTIONCODE] NVARCHAR(10) NOT NULL,
    [PORT] NVARCHAR(10) NOT NULL,
    [TRANSPORT] NVARCHAR(10) NOT NULL,
    [STATPROCID] NVARCHAR(10) NOT NULL,
    [CMFPRIORITYORDER] INT NOT NULL,
    [AWSRECEIPTCONFIRMATION] INT NOT NULL,
    [INVENTSITEID] NVARCHAR(10) NOT NULL,
    [PROJID] NVARCHAR(10) NOT NULL,
    [RETURNREASONCODEID] NVARCHAR(10) NOT NULL,
    [RETURNREPLACEMENTCREATED] INT NOT NULL,
    [REQATTENTION] NVARCHAR(255) NOT NULL,
    [REQUISITIONER] NVARCHAR(20) NOT NULL,
    [INVOICEDECLARATIONID_IS] NVARCHAR(10) NOT NULL,
    [CEVENDORCONFIRMED] INT NOT NULL,
    [DEL_CORRECTIVEREASON] NTEXT NULL,
    [DEL_REFDLVZIPCODE] BIGINT NOT NULL,
    [DEL_CORRECTEDINVOICEID] NVARCHAR(20) NOT NULL,
    [CESHIPPINGDATE] DATETIME NOT NULL,
    [CEARRIVED] INT NOT NULL,
    CONSTRAINT [pk_constraint_PURCHTABLE_recid] PRIMARY KEY (RECID)
);
