CREATE TABLE [cus].[PartTran] (
    [TranNum] INT NULL,
    [PartNum] NVARCHAR(50) NULL,
    [WareHouseCode] NVARCHAR(50) NULL,
    [TranClass] NVARCHAR(50) NULL,
    [TranType] NVARCHAR(50) NULL,
    [InventoryTrans] BIT NULL,
    [TranDate] DATETIMEOFFSET NULL,
    [TranQty] FLOAT(53) NULL,
    [Plant] NVARCHAR(50) NULL,
    [CustNum] NVARCHAR(50) NULL,
    [LegalNumber] NVARCHAR(50) NULL,
    [ActTranQty] FLOAT(53) NULL,
    [ActTransUOM] NVARCHAR(10) NULL,
    [SysDate] DATETIMEOFFSET NULL
);
