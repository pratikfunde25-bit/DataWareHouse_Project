/*

# FILE: ddl_gold.sql

PROJECT:
Modern Data Warehouse using MySQL

PURPOSE:
Create business-ready analytical views for reporting and dashboards.

LAYER:
Gold (Business Layer)

ARCHITECTURE:
Star Schema

OBJECTS:
1. dim_customers
2. dim_products
3. fact_sales

DESIGN PRINCIPLES:
- Surrogate Keys
- Business-friendly attributes
- Conformed Dimensions
- Current Product Dimension
- Fact Table at Order Line Grain

AUTHOR:
Pratik Funde

===============================================================================
*/

USE dw_gold;

-- ============================================================================
-- DIMENSION : CUSTOMERS
-- ============================================================================

DROP VIEW IF EXISTS dim_customers;

CREATE VIEW dim_customers AS

SELECT


ROW_NUMBER() OVER(ORDER BY ci.cst_id)
    AS customer_key,

ci.cst_id
    AS customer_id,

ci.cst_key
    AS customer_number,

ci.cst_firstname
    AS first_name,

ci.cst_lastname
    AS last_name,

la.cntry
    AS country,

ci.cst_marital_status
    AS marital_status,

CASE

    WHEN ci.cst_gndr <> 'Unknown'
        THEN ci.cst_gndr

    ELSE COALESCE(ca.gen,'Unknown')

END
    AS gender,

ca.bdate
    AS birthdate,

ci.cst_create_date
    AS create_date


FROM dw_silver.crm_cust_info ci

LEFT JOIN dw_silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid

LEFT JOIN dw_silver.erp_loc_a101 la
ON ci.cst_key = la.cid;

-- ============================================================================
-- DIMENSION : PRODUCTS
-- ============================================================================

DROP VIEW IF EXISTS dim_products;

CREATE VIEW dim_products AS

SELECT


ROW_NUMBER()
OVER(
    ORDER BY prd_start_dt, prd_key
) AS product_key,

prd_id
    AS product_id,

prd_key
    AS product_number,

prd_nm
    AS product_name,

SUBSTRING(prd_key,1,2)
    AS category_id,

pc.cat
    AS category,

pc.subcat
    AS subcategory,

pc.maintenance
    AS maintenance,

prd_cost
    AS cost,

prd_line
    AS product_line,

prd_start_dt
    AS start_date


FROM dw_silver.crm_prd_info pn

LEFT JOIN dw_silver.erp_px_cat_g1v2 pc
ON SUBSTRING(pn.prd_key,1,2)=pc.id

WHERE pn.prd_end_dt IS NULL;

-- ============================================================================
-- FACT TABLE : SALES
-- ============================================================================

DROP VIEW IF EXISTS fact_sales;

CREATE VIEW fact_sales AS

SELECT


sd.sls_ord_num
    AS order_number,

pr.product_key
    AS product_key,

cu.customer_key
    AS customer_key,

sd.sls_order_dt
    AS order_date,

sd.sls_ship_dt
    AS shipping_date,

sd.sls_due_dt
    AS due_date,

sd.sls_sales
    AS sales_amount,

sd.sls_quantity
    AS quantity,

sd.sls_price
    AS unit_price


FROM dw_silver.crm_sales_details sd

LEFT JOIN dim_products pr
ON sd.sls_prd_key = pr.product_number

LEFT JOIN dim_customers cu
ON sd.sls_cust_id = cu.customer_id;




select * from dim_customers;
select customer_id,count(*)
from dim_customers
group by customer_id
having count(*) >1;


select first_name, last_name
from dim_customers
where length(first_name)<>length(trim(first_name)) 
or 	  length(last_name)<>length(trim(last_name));
