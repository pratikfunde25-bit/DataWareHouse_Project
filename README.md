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

## Run From PowerShell

Create your local MySQL config:

```powershell
Copy-Item .env.example .env
notepad .env
```

Update `MYSQL_PASSWORD` in `.env`, then run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/run_bronze.ps1
```

To run the full project pipeline:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/run_all.ps1
```

The runner looks for `mysql.exe` in PATH and common MySQL Server installation folders. It also enables `--local-infile=1` so `LOAD DATA LOCAL INFILE` can load CSV files from `datasets/`.

If CSV loading is blocked, enable local infile in MySQL:

```sql
SET GLOBAL local_infile = 1;
```

## Source Systems

- CRM: customer, product, and sales transaction data.
- ERP: customer master, location, and product category data.

## Notes

- Bronze stores raw data without transformations.
- Silver stores cleansed and standardized data.
- Gold stores analytics-ready dimensional models.
