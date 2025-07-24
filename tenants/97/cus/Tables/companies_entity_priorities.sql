CREATE TABLE [cus].[companies_entity_priorities] (
    [entity_name] NVARCHAR(255) NOT NULL,
    [company] CHAR(3) NOT NULL,
    [priority] INT NOT NULL,
    CONSTRAINT [FK_companies_entity_priorities_companies] FOREIGN KEY (company) REFERENCES [cus].[companies] (company),
    CONSTRAINT [PK_cus_companies_entity_priorities] PRIMARY KEY (company,entity_name)
);
