# SQL Data Warehouse Project - MySQL

This project implements a modern data warehouse in MySQL using the Medallion Architecture: Bronze, Silver, and Gold layers.

## Project Structure

```text
datasets/              Source CSV files from CRM and ERP systems
docs/                  Architecture notes, data catalog, and design documents
scripts/init_database.sql
scripts/bronze/        Raw table DDL and load procedures
scripts/silver/        Cleansing and standardization scripts
scripts/gold/          Business-ready model scripts
tests/                 Data quality checks for Silver and Gold layers
```

## Execution Order

1. Run `scripts/init_database.sql`.
2. Run `scripts/bronze/ddl_bronze.sql`.
3. Place source CSV files in `datasets/source_crm/` and `datasets/source_erp/`.
4. Run `scripts/bronze/proc_load_bronze.sql`.
5. Run Silver layer scripts.
6. Run Gold layer scripts.
7. Run quality checks from `tests/`.

## Source Systems

- CRM: customer, product, and sales transaction data.
- ERP: customer master, location, and product category data.

## Notes

- Bronze stores raw data without transformations.
- Silver stores cleansed and standardized data.
- Gold stores analytics-ready dimensional models.
