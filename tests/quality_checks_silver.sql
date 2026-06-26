/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'dw_silver.crm_cust_info'
-- ====================================================================

SELECT
    cst_id,
    COUNT(*)
FROM dw_silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

SELECT
    cst_key
FROM dw_silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

SELECT DISTINCT
    cst_marital_status
FROM dw_silver.crm_cust_info;

-- ====================================================================
-- Checking 'dw_silver.crm_prd_info'
-- ====================================================================

SELECT
    prd_id,
    COUNT(*)
FROM dw_silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

SELECT
    prd_nm
FROM dw_silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

SELECT
    prd_cost
FROM dw_silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

SELECT DISTINCT
    prd_line
FROM dw_silver.crm_prd_info;

SELECT
    *
FROM dw_silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Checking 'dw_silver.crm_sales_details'
-- ====================================================================

SELECT
    NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM dw_bronze.crm_sales_details
WHERE sls_due_dt <= 0
    OR LENGTH(sls_due_dt) != 8
    OR sls_due_dt > 20500101
    OR sls_due_dt < 19000101;

SELECT
    *
FROM dw_silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;



SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM dw_silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price
;

-- ====================================================================
-- Checking 'dw_silver.erp_cust_az12'
-- ====================================================================

SELECT DISTINCT
    bdate
FROM dw_silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > CURDATE();

SELECT DISTINCT
    gen
FROM dw_silver.erp_cust_az12;

-- ====================================================================
-- Checking 'dw_silver.erp_loc_a101'
-- ====================================================================

SELECT DISTINCT
    cntry
FROM dw_silver.erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Checking 'dw_silver.erp_px_cat_g1v2'
-- ====================================================================

SELECT
    *
FROM dw_silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);

SELECT DISTINCT
       maintenance,
       LENGTH(maintenance) AS len,
       HEX(maintenance) AS hex_value
FROM dw_silver.erp_px_cat_g1v2;


select *
from dw_silver.erp_px_cat_g1v2
where trim(maintenance)!=maintenance;





SET SQL_SAFE_UPDATES = 0;
UPDATE dw_silver.erp_px_cat_g1v2
SET
    id = TRIM(REPLACE(REPLACE(id, '\r', ''), '\n', '')),
    cat = TRIM(REPLACE(REPLACE(cat, '\r', ''), '\n', '')),
    subcat = TRIM(REPLACE(REPLACE(subcat, '\r', ''), '\n', '')),
    maintenance = TRIM(REPLACE(REPLACE(maintenance, '\r', ''), '\n', ''));


