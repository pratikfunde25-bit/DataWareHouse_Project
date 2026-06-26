/*
===============================================================================
DDL Script: Create Bronze Layer Tables
===============================================================================

PROJECT:
    Modern Data Warehouse using MySQL

PURPOSE:
    This script creates all Bronze Layer tables inside the dw_bronze database.

BRONZE LAYER OBJECTIVES:
    - Store raw source data exactly as received.
    - Preserve historical source records.
    - Perform no transformations.
    - Enable auditing and reprocessing.

SOURCE SYSTEMS:
    1. CRM System 
    2. ERP System

WARNING:
    Existing tables will be permanently dropped and recreated.

EXECUTION ORDER:
    1. Run init_database.sql
    2. Execute this script

AUTHOR:
    Pratik Funde

===============================================================================
*/

USE dw_bronze;

/*=============================================================================
CRM CUSTOMER INFORMATION
=============================================================================*/

DROP TABLE IF EXISTS crm_cust_info;

CREATE TABLE crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_firstname      VARCHAR(50),
    cst_lastname       VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr           VARCHAR(50),
    cst_create_date    DATE
);

/*=============================================================================
CRM PRODUCT INFORMATION
=============================================================================*/

DROP TABLE IF EXISTS crm_prd_info;

CREATE TABLE crm_prd_info (
    prd_id        INT,
    prd_key       VARCHAR(50),
    prd_nm        VARCHAR(50),
    prd_cost      INT,
    prd_line      VARCHAR(50),
    prd_start_dt  DATETIME,
    prd_end_dt    DATETIME
);

/*=============================================================================
CRM SALES TRANSACTIONS
=============================================================================*/

DROP TABLE IF EXISTS crm_sales_details;

CREATE TABLE crm_sales_details (
    sls_ord_num   VARCHAR(50),
    sls_prd_key   VARCHAR(50),
    sls_cust_id   INT,
    sls_order_dt  INT,
    sls_ship_dt   INT,
    sls_due_dt    INT,
    sls_sales     INT,
    sls_quantity  INT,
    sls_price     INT
);

/*=============================================================================
ERP CUSTOMER LOCATION
=============================================================================*/

DROP TABLE IF EXISTS erp_loc_a101;

CREATE TABLE erp_loc_a101 (
    cid     VARCHAR(50),
    cntry   VARCHAR(50)
);

/*=============================================================================
ERP CUSTOMER MASTER DATA
=============================================================================*/

DROP TABLE IF EXISTS erp_cust_az12;

CREATE TABLE erp_cust_az12 (
    cid     VARCHAR(50),
    bdate   DATE,
    gen     VARCHAR(50)
);

/*=============================================================================
ERP PRODUCT CATEGORY DATA
=============================================================================*/

DROP TABLE IF EXISTS erp_px_cat_g1v2;

CREATE TABLE erp_px_cat_g1v2 (
    id           VARCHAR(50),
    cat          VARCHAR(50),
    subcat       VARCHAR(50),
    maintenance  VARCHAR(50)
);