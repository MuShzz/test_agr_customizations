CREATE TABLE [cus].[RM00101] (
    [CUSTNMBR] VARCHAR(20) NOT NULL,
    [CUSTNAME] VARCHAR(100) NULL,
    [Company] VARCHAR(15) NOT NULL,
    CONSTRAINT [PK_cus_RM00101] PRIMARY KEY (Company,CUSTNMBR)
);
