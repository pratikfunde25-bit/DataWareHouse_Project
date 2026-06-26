/*

# FILE: ddl_silver.sql

PROJECT:
Modern Data Warehouse using MySQL

PURPOSE:
Create Silver Layer tables for storing cleansed, standardized and
validated data.

LAYER:
Silver (Integrated & Cleansed Data Layer)

OBJECTIVES:
- Improve data quality.
- Remove duplicates.
- Standardize business values.
- Preserve lineage from Bronze layer.
- Prepare data for Gold layer transformations.

DESIGN PRINCIPLES:
- Natural keys are retained.
- Primary keys are enforced where feasible.
- Audit columns are maintained.
- No foreign keys are implemented.
- No surrogate keys are used in Silver.

DEPENDENCIES:
1. init_database.sql
2. ddl_bronze.sql

AUTHOR:
Pratik Funde

===============================================================================
*/

USE dw_silver;

/*=============================================================================
CRM CUSTOMER INFORMATION
=============================================================================*/

DROP TABLE IF EXISTS crm_cust_info;

CREATE TABLE crm_cust_info (


cst_id                INT NOT NULL,
cst_key               VARCHAR(50) NOT NULL,
cst_firstname         VARCHAR(50),
cst_lastname          VARCHAR(50),
cst_marital_status    VARCHAR(20),
cst_gndr              VARCHAR(20),
cst_create_date       DATE,

dwh_create_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
dwh_update_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                       ON UPDATE CURRENT_TIMESTAMP,

PRIMARY KEY (cst_id)


);

/*=============================================================================
CRM PRODUCT INFORMATION
=============================================================================*/

DROP TABLE IF EXISTS crm_prd_info;

CREATE TABLE crm_prd_info (

    prd_id                INT NOT NULL AUTO_INCREMENT,

    prd_key               VARCHAR(50) NOT NULL,

    prd_nm                VARCHAR(100),

    prd_cost              DECIMAL(10,2),

    prd_line              VARCHAR(50),

    prd_start_dt          DATE,

    prd_end_dt            DATE,

    dwh_create_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    dwh_update_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (prd_id)

);

/*=============================================================================
CRM SALES DETAILS
=============================================================================*/

DROP TABLE IF EXISTS crm_sales_details;

CREATE TABLE crm_sales_details (


sls_ord_num           VARCHAR(50),
sls_prd_key           VARCHAR(50),
sls_cust_id           INT,
sls_order_dt          DATE,
sls_ship_dt           DATE,
sls_due_dt            DATE,
sls_sales             DECIMAL(10,2),
sls_quantity          INT,
sls_price             DECIMAL(10,2),

dwh_create_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
dwh_update_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                       ON UPDATE CURRENT_TIMESTAMP


);

/*=============================================================================
ERP CUSTOMER MASTER DATA
=============================================================================*/

DROP TABLE IF EXISTS erp_cust_az12;

CREATE TABLE erp_cust_az12 (


cid                   VARCHAR(50) NOT NULL,
bdate                 DATE,
gen                   VARCHAR(20),

dwh_create_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
dwh_update_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                       ON UPDATE CURRENT_TIMESTAMP,

PRIMARY KEY (cid)


);

/*=============================================================================
ERP LOCATION INFORMATION
=============================================================================*/

DROP TABLE IF EXISTS erp_loc_a101;

CREATE TABLE erp_loc_a101 (

cid                   VARCHAR(50) NOT NULL,
cntry                 VARCHAR(50),

dwh_create_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
dwh_update_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                       ON UPDATE CURRENT_TIMESTAMP,

PRIMARY KEY (cid)


);

/*=============================================================================
ERP PRODUCT CATEGORY INFORMATION
=============================================================================*/

DROP TABLE IF EXISTS erp_px_cat_g1v2;

CREATE TABLE erp_px_cat_g1v2 (


id                    VARCHAR(50) NOT NULL,
cat                   VARCHAR(50),
subcat                VARCHAR(50),
maintenance           VARCHAR(50),

dwh_create_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
dwh_update_date       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                       ON UPDATE CURRENT_TIMESTAMP,

PRIMARY KEY (id)


);

/*=============================================================================
PERFORMANCE INDEXES
=============================================================================*/

CREATE INDEX idx_sales_customer
ON crm_sales_details (sls_cust_id);

CREATE INDEX idx_sales_product
ON crm_sales_details (sls_prd_key);

CREATE INDEX idx_sales_order
ON crm_sales_details (sls_order_dt);

CREATE INDEX idx_customer_key
ON crm_cust_info (cst_key);

CREATE INDEX idx_product_line
ON crm_prd_info (prd_line);
