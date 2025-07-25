CREATE TABLE [cus].[PURCHLINE] (
    [PURCHID] NVARCHAR(MAX) NULL,
    [ITEMID] NVARCHAR(MAX) NULL,
    [PURCHSTATUS] NVARCHAR(MAX) NULL,
    [SHIPPINGDATEREQUESTED] NVARCHAR(MAX) NULL,
    [DELIVERYDATE] NVARCHAR(MAX) NULL,
    [NAME] NVARCHAR(MAX) NULL,
    [TAXGROUP] NVARCHAR(MAX) NULL,
    [QTYORDERED] NVARCHAR(MAX) NULL,
    [PURCHRECEIVEDNOW] NVARCHAR(MAX) NULL,
    [REMAINPURCHPHYSICAL] NVARCHAR(MAX) NULL,
    [REMAINPURCHFINANCIAL] NVARCHAR(MAX) NULL,
    [PRICEUNIT] NVARCHAR(MAX) NULL,
    [PURCHPRICE] NVARCHAR(MAX) NULL,
    [CURRENCYCODE] NVARCHAR(MAX) NULL,
    [LINEPERCENT] NVARCHAR(MAX) NULL,
    [LINEDISC] NVARCHAR(MAX) NULL,
    [LINEAMOUNT] NVARCHAR(MAX) NULL,
    [EXTERNALITEMID] NVARCHAR(MAX) NULL,
    [PURCHUNIT] NVARCHAR(MAX) NULL,
    [CONFIRMEDDLV] NVARCHAR(MAX) NULL,
    [ADDRESSREFRECID] NVARCHAR(MAX) NULL,
    [INVENTTRANSID] NVARCHAR(MAX) NULL,
    [VENDGROUP] NVARCHAR(MAX) NULL,
    [VENDACCOUNT] NVARCHAR(MAX) NULL,
    [ADDRESSREFTABLEID] NVARCHAR(MAX) NULL,
    [PURCHQTY] NVARCHAR(MAX) NULL,
    [PURCHMARKUP] NVARCHAR(MAX) NULL,
    [INVENTRECEIVEDNOW] NVARCHAR(MAX) NULL,
    [MULTILNDISC] NVARCHAR(MAX) NULL,
    [MULTILNPERCENT] NVARCHAR(MAX) NULL,
    [PURCHASETYPE] NVARCHAR(MAX) NULL,
    [COVREF] NVARCHAR(MAX) NULL,
    [REMAININVENTPHYSICAL] NVARCHAR(MAX) NULL,
    [TAXITEMGROUP] NVARCHAR(MAX) NULL,
    [TRANSACTIONCODE] NVARCHAR(MAX) NULL,
    [SHIPPINGDATECONFIRMED] NVARCHAR(MAX) NULL,
    [COUNTYORIGDEST] NVARCHAR(MAX) NULL,
    [TAXAUTOGENERATED] NVARCHAR(MAX) NULL,
    [UNDERDELIVERYPCT] NVARCHAR(MAX) NULL,
    [OVERDELIVERYPCT] NVARCHAR(MAX) NULL,
    [TAX1099AMOUNT] NVARCHAR(MAX) NULL,
    [BARCODE] NVARCHAR(MAX) NULL,
    [BARCODETYPE] NVARCHAR(MAX) NULL,
    [INVENTREFID] NVARCHAR(MAX) NULL,
    [INVENTREFTRANSID] NVARCHAR(MAX) NULL,
    [ITEMREFTYPE] NVARCHAR(MAX) NULL,
    [PROJTRANSID] NVARCHAR(MAX) NULL,
    [BLOCKED] NVARCHAR(MAX) NULL,
    [COMPLETE] NVARCHAR(MAX) NULL,
    [REQPLANIDSCHED] NVARCHAR(MAX) NULL,
    [REQPOID] NVARCHAR(MAX) NULL,
    [ITEMROUTEID] NVARCHAR(MAX) NULL,
    [ITEMBOMID] NVARCHAR(MAX) NULL,
    [LINEHEADER] NVARCHAR(MAX) NULL,
    [SCRAP] NVARCHAR(MAX) NULL,
    [RETURNACTIONID] NVARCHAR(MAX) NULL,
    [INTERCOMPANYORIGIN] NVARCHAR(MAX) NULL,
    [PROJCATEGORYID] NVARCHAR(MAX) NULL,
    [PROJID] NVARCHAR(MAX) NULL,
    [INVENTDIMID] NVARCHAR(MAX) NULL,
    [TRANSPORT] NVARCHAR(MAX) NULL,
    [STATPROCID] NVARCHAR(MAX) NULL,
    [PORT] NVARCHAR(MAX) NULL,
    [ASSETID] NVARCHAR(MAX) NULL,
    [ASSETTRANSTYPEPURCH] NVARCHAR(MAX) NULL,
    [ASSETBOOKID] NVARCHAR(MAX) NULL,
    [PROJLINEPROPERTYID] NVARCHAR(MAX) NULL,
    [PROJTAXITEMGROUPID] NVARCHAR(MAX) NULL,
    [PROJTAXGROUPID] NVARCHAR(MAX) NULL,
    [PROJSALESPRICE] NVARCHAR(MAX) NULL,
    [PROJSALESCURRENCYID] NVARCHAR(MAX) NULL,
    [INTERCOMPANYINVENTTRANSID] NVARCHAR(MAX) NULL,
    [PROJSALESUNITID] NVARCHAR(MAX) NULL,
    [DELIVERYNAME] NVARCHAR(MAX) NULL,
    [DELIVERYTYPE] NVARCHAR(MAX) NULL,
    [CUSTOMERREF] NVARCHAR(MAX) NULL,
    [CUSTPURCHASEORDERFORMNUM] NVARCHAR(MAX) NULL,
    [STATTRIANGULARDEAL] NVARCHAR(MAX) NULL,
    [TAX1099STATE] NVARCHAR(MAX) NULL,
    [TAX1099STATEAMOUNT] NVARCHAR(MAX) NULL,
    [ITEMTAGGING] NVARCHAR(MAX) NULL,
    [CASETAGGING] NVARCHAR(MAX) NULL,
    [PALLETTAGGING] NVARCHAR(MAX) NULL,
    [REMAININVENTFINANCIAL] NVARCHAR(MAX) NULL,
    [PURCHREQLINEREFID] NVARCHAR(MAX) NULL,
    [DEPRECIATIONSTARTDATE] NVARCHAR(MAX) NULL,
    [ACTIVITYNUMBER] NVARCHAR(MAX) NULL,
    [RETURNSTATUS] NVARCHAR(MAX) NULL,
    [RETURNDISPOSITIONCODEID] NVARCHAR(MAX) NULL,
    [CREATEFIXEDASSET] NVARCHAR(MAX) NULL,
    [ASSETGROUP] NVARCHAR(MAX) NULL,
    [REQATTENTION] NVARCHAR(MAX) NULL,
    [PURCHREQID] NVARCHAR(MAX) NULL,
    [TAX1099RECID] NVARCHAR(MAX) NULL,
    [MATCHINGPOLICY] NVARCHAR(MAX) NULL,
    [PROCUREMENTCATEGORY] NVARCHAR(MAX) NULL,
    [LINEDELIVERYTYPE] NVARCHAR(MAX) NULL,
    [SOURCEDOCUMENTLINE] NVARCHAR(MAX) NULL,
    [DEFAULTDIMENSION] NVARCHAR(MAX) NULL,
    [LEDGERDIMENSION] NVARCHAR(MAX) NULL,
    [ISDELETED] NVARCHAR(MAX) NULL,
    [ISMODIFIED] NVARCHAR(MAX) NULL,
    [MATCHINGAGREEMENTLINE] NVARCHAR(MAX) NULL,
    [MANUALENTRYCHANGEPOLICY] NVARCHAR(MAX) NULL,
    [SYSTEMENTRYCHANGEPOLICY] NVARCHAR(MAX) NULL,
    [SYSTEMENTRYSOURCE] NVARCHAR(MAX) NULL,
    [WORKFLOWSTATE] NVARCHAR(MAX) NULL,
    [EDITABLEINWORKFLOW] NVARCHAR(MAX) NULL,
    [WFINVRECEIVEDSTATE] NVARCHAR(MAX) NULL,
    [WFDELIVERYDUESTATE] NVARCHAR(MAX) NULL,
    [TAX1099FIELDS] NVARCHAR(MAX) NULL,
    [GSTHSTTAXTYPE_CA] NVARCHAR(MAX) NULL,
    [DELIVERYPOSTALADDRESS] NVARCHAR(MAX) NULL,
    [LINENUMBER] NVARCHAR(MAX) NULL,
    [TAXWITHHOLDITEMGROUPHEADING_TH] NVARCHAR(MAX) NULL,
    [REQUESTER] NVARCHAR(MAX) NULL,
    [ACCOUNTINGDISTRIBUTIONTEMPLATE] NVARCHAR(MAX) NULL,
    [OPERATIONTYPE_MX] NVARCHAR(MAX) NULL,
    [STOCKEDPRODUCT] NVARCHAR(MAX) NULL,
    [ISFINALIZED] NVARCHAR(MAX) NULL,
    [PLANREFERENCE] NVARCHAR(MAX) NULL,
    [ISINVOICEMATCHED] NVARCHAR(MAX) NULL,
    [ITEMPBAID] NVARCHAR(MAX) NULL,
    [TAXWITHHOLDBASECUR_TH] NVARCHAR(MAX) NULL,
    [TAXWITHHOLDGROUP_TH] NVARCHAR(MAX) NULL,
    [TAXSERVICECODE_BR] NVARCHAR(MAX) NULL,
    [INTRASTATFULFILLMENTDATE_HU] NVARCHAR(MAX) NULL,
    [CFOPTABLE_BR] NVARCHAR(MAX) NULL,
    [STATISTICVALUE_LT] NVARCHAR(MAX) NULL,
    [PSARETAINSCHEDULEID] NVARCHAR(MAX) NULL,
    [PSATOTALRETAINAMOUNT] NVARCHAR(MAX) NULL,
    [SERVICEDATE] NVARCHAR(MAX) NULL,
    [REMAINDER] NVARCHAR(MAX) NULL,
    [SERVICEADDRESS] NVARCHAR(MAX) NULL,
    [INVENTINVOICENOW] NVARCHAR(MAX) NULL,
    [RETAILLINENUMEX1] NVARCHAR(MAX) NULL,
    [VARIANTID] NVARCHAR(MAX) NULL,
    [RETAILPACKAGEID] NVARCHAR(MAX) NULL,
    [RBOPACKAGELINENUM] NVARCHAR(MAX) NULL,
    [RETAILTEMPVALUEEX2] NVARCHAR(MAX) NULL,
    [MCRDROPSHIPMENT] NVARCHAR(MAX) NULL,
    [MCRDROPSHIPCOMMENT] NVARCHAR(MAX) NULL,
    [MCRDROPSHIPSTATUS] NVARCHAR(MAX) NULL,
    [AGREEMENTSKIPAUTOLINK] NVARCHAR(MAX) NULL,
    [CONFIRMEDTAXAMOUNT] NVARCHAR(MAX) NULL,
    [CONFIRMEDTAXWRITECODE] NVARCHAR(MAX) NULL,
    [DISCAMOUNT] NVARCHAR(MAX) NULL,
    [DISCPERCENT] NVARCHAR(MAX) NULL,
    [ISPWP] NVARCHAR(MAX) NULL,
    [MANUALMODIFIEDFIELD] NVARCHAR(MAX) NULL,
    [MCRORDERLINE2PRICEHISTORYREF] NVARCHAR(MAX) NULL,
    [PDSCALCULATIONID] NVARCHAR(MAX) NULL,
    [PDSCWINVENTRECEIVEDNOW] NVARCHAR(MAX) NULL,
    [PDSCWQTY] NVARCHAR(MAX) NULL,
    [PDSCWREMAININVENTFINANCIAL] NVARCHAR(MAX) NULL,
    [PDSCWREMAININVENTPHYSICAL] NVARCHAR(MAX) NULL,
    [PROJWORKER] NVARCHAR(MAX) NULL,
    [PURCHCOMMITMENTLINE_PSN] NVARCHAR(MAX) NULL,
    [SKIPDISTRIBUTIONUPDATE] NVARCHAR(MAX) NULL,
    [TAMITEMVENDREBATEGROUPID] NVARCHAR(MAX) NULL,
    [BUDGETRESERVATIONLINE_PSN] NVARCHAR(MAX) NULL,
    [CREDITEDVENDINVOICETRANS] NVARCHAR(MAX) NULL,
    [MODIFIEDDATETIME] NVARCHAR(MAX) NULL,
    [CREATEDDATETIME] NVARCHAR(MAX) NULL,
    [DATAAREAID] NVARCHAR(MAX) NULL,
    [RECVERSION] NVARCHAR(MAX) NULL,
    [PARTITION] NVARCHAR(MAX) NULL,
    [RECID] NVARCHAR(MAX) NULL,
    [DEL_MCSDELIVERYHOUSENR] NVARCHAR(MAX) NULL,
    [DEL_MCSDELIVERYADDITION] NVARCHAR(MAX) NULL,
    [MCSCONNECTIONID] NVARCHAR(MAX) NULL,
    [MCSSTARTDATETIME] NVARCHAR(MAX) NULL,
    [MCSSTARTDATETIMETZID] NVARCHAR(MAX) NULL,
    [MCSENDDATETIME] NVARCHAR(MAX) NULL,
    [MCSENDDATETIMETZID] NVARCHAR(MAX) NULL,
    [DEL_MCSBUILDINGNAME] NVARCHAR(MAX) NULL,
    [MCSCONTRACTNUM] NVARCHAR(MAX) NULL,
    [MCSINVOICEID] NVARCHAR(MAX) NULL,
    [MSM_SVCCALLID] NVARCHAR(MAX) NULL,
    [ADVINVENTSERIALIDFROM] NVARCHAR(MAX) NULL,
    [ADVINVENTSERIALIDTO] NVARCHAR(MAX) NULL
);
