# Customization Framework

Version and source control of tenant customization implementations with automatic deployment to tenant databases.


## 📂 Folder Structure

```
customization_framework/
└── tenants/                        # All tenants customizations
    └── [Tenant NN]/                # All custom objects of a particular Tenant e.g. 42
        └── Data/                   # Tenant specific data stored as CSV files, e.g. dbo.tenant_info.csv
        └── [ERP Schema Selection]/ # The tenant_info selected schema e.g. sap_b1, bc_rest
            ├── Functions/          # Stored functions (.sql)
            ├── Procedures/         # Stored procedures (.sql)
            ├── Tables/             # Table definitions (.sql)
            └── Views/              # View definitions (.sql)
