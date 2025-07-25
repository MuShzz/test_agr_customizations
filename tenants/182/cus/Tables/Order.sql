CREATE TABLE [cus].[Order] (
    [pkOrderID] NVARCHAR(255) NULL,
    [cFullName] NVARCHAR(255) NULL,
    [cEmailAddress] NVARCHAR(255) NULL,
    [cShippingAddress] NVARCHAR(1000) NULL,
    [cPostCode] NVARCHAR(255) NULL,
    [dReceievedDate] NVARCHAR(255) NULL,
    [dDispatchBy] NVARCHAR(255) NULL,
    [dProcessedOn] NVARCHAR(255) NULL,
    [fPostageCost] NVARCHAR(255) NULL,
    [fTotalCharge] NVARCHAR(255) NULL,
    [cCurrency] NVARCHAR(255) NULL,
    [nOrderId] NVARCHAR(255) NULL,
    [nStatus] NVARCHAR(255) NULL,
    [Source] NVARCHAR(255) NULL,
    [bProcessed] NVARCHAR(255) NULL,
    [fTax] NVARCHAR(255) NULL,
    [fkCountryId] NVARCHAR(255) NULL,
    [fkPostalServiceId] NVARCHAR(255) NULL,
    [fkPackagingGroupId] NVARCHAR(255) NULL,
    [ReferenceNum] NVARCHAR(255) NULL,
    [ExternalReference] NVARCHAR(255) NULL,
    [PostalTrackingNumber] NVARCHAR(255) NULL,
    [CreatedBy] NVARCHAR(255) NULL,
    [CreatedDate] NVARCHAR(255) NULL,
    [Address1] NVARCHAR(255) NULL,
    [Address2] NVARCHAR(255) NULL,
    [Address3] NVARCHAR(255) NULL,
    [Town] NVARCHAR(255) NULL,
    [Region] NVARCHAR(255) NULL,
    [LifeStatus] NVARCHAR(255) NULL,
    [BuyerPhoneNumber] NVARCHAR(255) NULL,
    [Company] NVARCHAR(255) NULL,
    [SubSource] NVARCHAR(255) NULL,
    [AddressVerified] NVARCHAR(255) NULL,
    [Subtotal] NVARCHAR(255) NULL,
    [PostageCostExTax] NVARCHAR(255) NULL,
    [CountryTaxRate] NVARCHAR(255) NULL,
    [RecalculateTaxRequired] NVARCHAR(255) NULL,
    [ChannelBuyerName] NVARCHAR(255) NULL,
    [HoldOrCancel] NVARCHAR(255) NULL,
    [Marker] NVARCHAR(255) NULL,
    [TotalDiscount] NVARCHAR(255) NULL,
    [fkBankId] NVARCHAR(255) NULL,
    [FulfillmentLocationId] NVARCHAR(255) NULL,
    [SecondaryReferenceNum] NVARCHAR(255) NULL,
    [PostalServiceCost] NVARCHAR(255) NULL,
    [FulfilmentCenterAcknowledge] NVARCHAR(255) NULL,
    [PostageDiscount] NVARCHAR(255) NULL,
    [ConversionRate] NVARCHAR(255) NULL
);
