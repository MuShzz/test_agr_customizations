CREATE TABLE [cus].[OrderRel] (
    [OrderNum] INT NOT NULL,
    [OrderLine] INT NOT NULL,
    [OrderRelNum] INT NOT NULL,
    [SellingReqQty] DECIMAL(22,8) NULL,
    [OurJobShippedQty] DECIMAL(22,8) NULL,
    [SellingJobShippedQty] DECIMAL(22,8) NULL,
    [ReqDate] DATE NULL,
    [NeedByDate] DATE NULL,
    CONSTRAINT [pk_cus_orderRel] PRIMARY KEY (OrderLine,OrderNum,OrderRelNum)
);
