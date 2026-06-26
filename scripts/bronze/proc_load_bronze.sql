 /*

# FILE: proc_load_bronze.sql

PROJECT:
Modern Data Warehouse using MySQL

PURPOSE:
Load raw data from CRM and ERP source files into Bronze layer tables.

LAYER:
Bronze (Raw Data Layer)

## SOURCE → TARGET MAPPING

cust_info.csv        → crm_cust_info
prd_info.csv         → crm_prd_info
sales_details.csv    → crm_sales_details
CUST_AZ12.csv        → erp_cust_az12
LOC_A101.csv         → erp_loc_a101
PX_CAT_G1V2.csv      → erp_px_cat_g1v2

## TRANSFORMATION LOGIC

No transformations are applied in the Bronze layer.
Data is loaded exactly as received from source systems.

## DATA QUALITY RULES

* No validations performed.
* No deduplication performed.
* No business rules applied.

## DEPENDENCIES

1. init_database.sql must be executed.
2. ddl_bronze.sql must be executed.
3. Source CSV files must exist at the specified locations.
4. local_infile must be enabled.

## EXECUTION ORDER

1. init_database.sql
2. ddl_bronze.sql
3. proc_load_bronze.sql

## WARNING

Existing Bronze table data will be deleted before loading.

AUTHOR:
Pratik Funde
============

*/

USE dw_bronze;

-- ============================================================================
-- CRM CUSTOMER INFORMATION
-- ============================================================================

TRUNCATE TABLE crm_cust_info;

LOAD DATA LOCAL INFILE
'C:/Users/Pratik/Desktop/sql-data-warehouse-project-mysql/datasets/source_crm/cust_info.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT
'crm_cust_info Loaded Successfully' AS Status,
COUNT(*) AS Rows_Loaded
FROM crm_cust_info;

-- ============================================================================
-- CRM PRODUCT INFORMATION
-- ============================================================================

TRUNCATE TABLE crm_prd_info;

LOAD DATA LOCAL INFILE
'C:/Users/Pratik/Desktop/sql-data-warehouse-project-mysql/datasets/source_crm/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT
'crm_prd_info Loaded Successfully' AS Status,
COUNT(*) AS Rows_Loaded
FROM crm_prd_info;

-- ============================================================================
-- CRM SALES DETAILS
-- ============================================================================

TRUNCATE TABLE crm_sales_details;

LOAD DATA LOCAL INFILE
'C:/Users/Pratik/Desktop/sql-data-warehouse-project-mysql/datasets/source_crm/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT
'crm_sales_details Loaded Successfully' AS Status,
COUNT(*) AS Rows_Loaded
FROM crm_sales_details;

-- ============================================================================
-- ERP CUSTOMER MASTER DATA
-- ============================================================================

TRUNCATE TABLE erp_cust_az12;

LOAD DATA LOCAL INFILE
'C:/Users/Pratik/Desktop/sql-data-warehouse-project-mysql/datasets/source_erp/CUST_AZ12.csv'
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT
'erp_cust_az12 Loaded Successfully' AS Status,
COUNT(*) AS Rows_Loaded
FROM erp_cust_az12;

-- ============================================================================
-- ERP LOCATION DATA
-- ============================================================================

TRUNCATE TABLE erp_loc_a101;

LOAD DATA LOCAL INFILE
'C:/Users/Pratik/Desktop/sql-data-warehouse-project-mysql/datasets/source_erp/LOC_A101.csv'
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT
'erp_loc_a101 Loaded Successfully' AS Status,
COUNT(*) AS Rows_Loaded
FROM erp_loc_a101;

-- ============================================================================
-- ERP PRODUCT CATEGORY DATA
-- ============================================================================

TRUNCATE TABLE erp_px_cat_g1v2;

LOAD DATA LOCAL INFILE
'C:/Users/Pratik/Desktop/sql-data-warehouse-project-mysql/datasets/source_erp/PX_CAT_G1V2.csv'
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT
'erp_px_cat_g1v2 Loaded Successfully' AS Status,
COUNT(*) AS Rows_Loaded
FROM erp_px_cat_g1v2;

-- ============================================================================
-- FINAL VALIDATION
-- ============================================================================

SELECT 'Bronze Layer Data Loading Completed Successfully' AS Final_Status;


SELECT COUNT(*) FROM crm_cust_info;
SELECT COUNT(*) FROM crm_prd_info;
SELECT COUNT(*) FROM crm_sales_details;
