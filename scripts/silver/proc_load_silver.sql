/*

# FILE: proc_load_silver.sql

PROJECT:
Modern Data Warehouse using MySQL

PURPOSE:
Load cleansed and standardized data from Bronze layer into Silver layer.

LAYER:
Silver

AUTHOR:
Pratik Funde

===============================================================================
*/

USE dw_silver;

/*=============================================================================
LOAD CRM CUSTOMER INFORMATION
=============================================================================*/

TRUNCATE TABLE crm_cust_info;

INSERT INTO crm_cust_info
(
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)

SELECT
    cst_id,
    cst_key,

    TRIM(cst_firstname),

    TRIM(cst_lastname),

    CASE
        WHEN UPPER(TRIM(cst_marital_status))='S'
            THEN 'Single'

        WHEN UPPER(TRIM(cst_marital_status))='M'
            THEN 'Married'

        ELSE 'Unknown'
    END,

    CASE
        WHEN UPPER(TRIM(cst_gndr))='M'
            THEN 'Male'

        WHEN UPPER(TRIM(cst_gndr))='F'
            THEN 'Female'

        ELSE 'Unknown'
    END,

    CASE
        WHEN YEAR(cst_create_date)=0
            THEN NULL
        ELSE cst_create_date
    END

FROM
(
    SELECT *,
           ROW_NUMBER() OVER(
               PARTITION BY cst_id
               ORDER BY cst_create_date DESC
           ) rn

    FROM dw_bronze.crm_cust_info
) t

WHERE rn = 1
AND cst_id <> 0;


/*-----------------------------------------------------------------------------
VALIDATION
-----------------------------------------------------------------------------*/

SELECT
COUNT(*) AS Total_Customers
FROM dw_silver.crm_cust_info;

SELECT COUNT(*)
FROM dw_bronze.crm_cust_info
WHERE cst_create_date IS NULL;

SELECT *
FROM dw_silver.crm_cust_info
WHERE YEAR(cst_create_date)=0;

SHOW COLUMNS FROM dw_bronze.crm_cust_info;





-- Table 2 


select * from dw_bronze.crm_prd_info
limit 100;

use dw_silver;
TRUNCATE TABLE crm_prd_info;

INSERT INTO crm_prd_info
(
prd_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)

SELECT


prd_id,

SUBSTRING(prd_key, 4) AS prd_key,

TRIM(prd_nm) AS prd_nm,

IFNULL(prd_cost, 0) AS prd_cost,

CASE UPPER(TRIM(prd_line))

    WHEN 'M' THEN 'Mountain'
    WHEN 'R' THEN 'Road'
    WHEN 'S' THEN 'Other Sales'
    WHEN 'T' THEN 'Touring'

    ELSE 'Unknown'

END AS prd_line,

CAST(prd_start_dt AS DATE) AS prd_start_dt,

CASE
    WHEN LEAD(CAST(prd_start_dt AS DATE))
         OVER (
             PARTITION BY SUBSTRING(prd_key, 4)
             ORDER BY CAST(prd_start_dt AS DATE)
         ) IS NULL
    THEN NULL

    ELSE DATE_SUB(
            LEAD(CAST(prd_start_dt AS DATE))
            OVER (
                PARTITION BY SUBSTRING(prd_key, 4)
                ORDER BY CAST(prd_start_dt AS DATE)
            ),
            INTERVAL 1 DAY
         )
END AS prd_end_dt


FROM dw_bronze.crm_prd_info;



/*=============================================================================
LOAD CRM SALES DETAILS
=============================================================================*/

TRUNCATE TABLE crm_sales_details;

INSERT INTO crm_sales_details
(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)

SELECT


sls_ord_num,

SUBSTRING(sls_prd_key, 4) AS sls_prd_key,

sls_cust_id,

CASE
    WHEN sls_order_dt = 0
         OR LENGTH(sls_order_dt) != 8
    THEN NULL
    ELSE STR_TO_DATE(CAST(sls_order_dt AS CHAR), '%Y%m%d')
END AS sls_order_dt,

CASE
    WHEN sls_ship_dt = 0
         OR LENGTH(sls_ship_dt) != 8
    THEN NULL
    ELSE STR_TO_DATE(CAST(sls_ship_dt AS CHAR), '%Y%m%d')
END AS sls_ship_dt,

CASE
    WHEN sls_due_dt = 0
         OR LENGTH(sls_due_dt) != 8
    THEN NULL
    ELSE STR_TO_DATE(CAST(sls_due_dt AS CHAR), '%Y%m%d')
END AS sls_due_dt,

/* Final Sales Calculation */
ABS(sls_quantity * sls_price) AS sls_sales,

sls_quantity,

NULLIF(ABS(sls_price) ,0)AS sls_price


FROM dw_bronze.crm_sales_details;


/*-----------------------------------------------------------------------------
VALIDATION
-----------------------------------------------------------------------------*/

SELECT COUNT(*) AS Total_Sales
FROM crm_sales_details;

/*=============================================================================
LOAD ERP CUSTOMER MASTER
=============================================================================*/

TRUNCATE TABLE erp_cust_az12;

INSERT INTO erp_cust_az12
(
cid,
bdate,
gen
)

SELECT
CASE
    WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4)
    ELSE cid
END AS cid,
CASE
        WHEN YEAR(bdate) = 0 THEN NULL
        WHEN bdate < '1924-01-01' THEN NULL
        WHEN bdate > CURDATE() THEN NULL
        ELSE bdate
    END AS bdate,

CASE
    WHEN UPPER(TRIM(gen)) IN ('M','MALE')
        THEN 'Male'

    WHEN UPPER(TRIM(gen)) IN ('F','FEMALE')
        THEN 'Female'

    ELSE 'Unknown'
END AS gen


FROM dw_bronze.erp_cust_az12

WHERE cid IS NOT NULL;

/*-----------------------------------------------------------------------------
VALIDATION
-----------------------------------------------------------------------------*/

SELECT COUNT(*) AS Total_ERP_Customers
FROM erp_cust_az12;

/*=============================================================================
LOAD ERP LOCATION INFORMATION
=============================================================================*/

TRUNCATE TABLE erp_loc_a101;

INSERT INTO erp_loc_a101
(
cid,
cntry
)

SELECT


REPLACE(cid,'-','') AS cid,

CASE

    WHEN TRIM(cntry)='DE'
        THEN 'Germany'

    WHEN TRIM(cntry) IN ('US','USA')
        THEN 'United States'

    WHEN TRIM(cntry)=''
        THEN 'Unknown'

    ELSE TRIM(cntry)

END AS cntry


FROM dw_bronze.erp_loc_a101;

/*-----------------------------------------------------------------------------
VALIDATION
-----------------------------------------------------------------------------*/

SELECT COUNT(*) AS Total_Locations
FROM erp_loc_a101;

/*=============================================================================
LOAD ERP PRODUCT CATEGORY INFORMATION
=============================================================================*/

TRUNCATE TABLE erp_px_cat_g1v2;

INSERT INTO erp_px_cat_g1v2
(
id,
cat,
subcat,
maintenance
)

SELECT


id,

TRIM(cat),

TRIM(subcat),

TRIM(maintenance)


FROM dw_bronze.erp_px_cat_g1v2;

/*-----------------------------------------------------------------------------
FINAL VALIDATION
-----------------------------------------------------------------------------*/

SELECT 'Silver Layer Loading Completed Successfully'
AS Final_Status;





select * 
from dw_bronze.crm_sales_details;

SELECT *
FROM dw_silver.crm_sales_details
WHERE LENGTH(sls_order_dt) <> 10
OR LENGTH(sls_ship_dt) <> 10
OR LENGTH(sls_due_dt) <> 10;

