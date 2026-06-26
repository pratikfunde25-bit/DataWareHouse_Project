 /*

# PROJECT: Modern Data Warehouse Implementation using MySQL

AUTHOR      : Pratik Funde
ROLE        : Data Engineer / SQL Developer
DATABASE    : MySQL 8.x
ARCHITECTURE: Medallion Architecture (Bronze, Silver, Gold)

---

## PROJECT OVERVIEW

This project demonstrates the implementation of a modern Data Warehouse
solution using MySQL following the Medallion Architecture approach.

The objective of this project is to integrate data from multiple operational
systems (CRM and ERP), transform it into analytics-ready datasets, and support
business intelligence and reporting requirements.

Data flows through three logical layers:

1. Bronze Layer

   * Stores raw source data exactly as received.
   * No transformations are applied.
   * Serves as the historical source of truth.

2. Silver Layer

   * Performs data cleansing, standardization, and validation.
   * Removes duplicates and handles data quality issues.

3. Gold Layer

   * Stores business-ready dimensional models.
   * Optimized for analytical reporting and dashboarding.

---

## SOURCE SYSTEMS

CRM System:
- Customer Information
- Product Information
- Sales Transactions

ERP System:
- Customer Master Data
- Location Information
- Product Category Information

---

## DATABASES CREATED BY THIS SCRIPT

1. dw_bronze  -> Raw data layer
2. dw_silver  -> Cleansed and standardized layer
3. dw_gold    -> Business and analytics layer

---

## WARNING

WARNING: This script is DESTRUCTIVE.

Execution of this script will:

```
DROP existing databases:
    - dw_bronze
    - dw_silver
    - dw_gold
```

ALL existing objects and data inside these databases will be permanently
deleted.

Ensure that important data is backed up before execution.

---

## EXECUTION PREREQUISITES

1. MySQL Server 8.0 or above must be installed.
2. User must possess CREATE and DROP DATABASE privileges.
3. Existing warehouse databases should be backed up if required.
4. Execute this script only in Development or Testing environments.
5. Avoid running in Production without proper approval.

---

## EXECUTION ORDER

Step 1 : Execute init_database.sql
Step 2 : Execute Bronze Layer DDL scripts
Step 3 : Load raw source data into Bronze layer
Step 4 : Execute Silver Layer ETL scripts
Step 5 : Execute Gold Layer scripts
Step 6 : Run data quality validation scripts

---

## LAST UPDATED

Date: 26-June-2026
Version: 1.0

===============================================================================
*/

/*----------------------------------------------------------------------------
Remove existing warehouse databases if present
----------------------------------------------------------------------------*/

DROP DATABASE IF EXISTS dw_bronze;
DROP DATABASE IF EXISTS dw_silver;
DROP DATABASE IF EXISTS dw_gold;

/*----------------------------------------------------------------------------
Create Medallion Architecture Databases
----------------------------------------------------------------------------*/

CREATE DATABASE dw_bronze;
CREATE DATABASE dw_silver;
CREATE DATABASE dw_gold;

/*----------------------------------------------------------------------------
Verification Queries (Optional)
----------------------------------------------------------------------------*/

SHOW DATABASES LIKE 'dw_bronze';
SHOW DATABASES LIKE 'dw_silver';
SHOW DATABASES LIKE 'dw_gold';
