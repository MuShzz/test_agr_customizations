CREATE TABLE [bc_rest_cus].[purch_rcpt_header] (
    [No] NVARCHAR(20) NOT NULL,
    [BuyfromVendorNo] NVARCHAR(20) NOT NULL,
    [DocumentDate] DATE NOT NULL,
    [DueDate] DATE NOT NULL,
    [ExpectedReceiptDate] DATE NOT NULL,
    [InboundWhseHandlingTime] VARCHAR(32) NOT NULL,
    [LeadTimeCalculation] VARCHAR(32) NOT NULL,
    [LocationCode] NVARCHAR(10) NOT NULL,
    [OrderDate] DATE NOT NULL,
    [OrderNo] NVARCHAR(20) NOT NULL,
    [PostingDate] DATE NOT NULL,
    [PostingDescription] NVARCHAR(100) NOT NULL,
    [PromisedReceiptDate] DATE NOT NULL,
    [PurchaserCode] NVARCHAR(20) NOT NULL,
    [RequestedReceiptDate] DATE NOT NULL,
    [ShiptoName] NVARCHAR(100) NOT NULL,
    CONSTRAINT [PK_bc_rest_purchase_rcpt_header] PRIMARY KEY (No)
);
