 /*

# FILE: quality_checks_gold.sql

PROJECT:
Modern Data Warehouse using MySQL

PURPOSE:
Perform data quality validation on the Gold Layer.

OBJECTIVES:
- Validate uniqueness of surrogate keys.
- Validate dimensional model integrity.
- Validate referential integrity between fact and dimensions.
- Detect missing or orphan records.
- Ensure analytical readiness.

EXPECTED RESULT:
All quality check queries should return ZERO rows unless an issue exists.

AUTHOR:
Pratik Funde
============

*/

USE dw_gold;

-- ============================================================================
-- CHECK 1 : CUSTOMER SURROGATE KEY UNIQUENESS
-- EXPECTATION : No duplicate customer_key values
-- ============================================================================

SELECT
customer_key,
COUNT(*) AS duplicate_count
FROM dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ============================================================================
-- CHECK 2 : CUSTOMER BUSINESS KEY UNIQUENESS
-- EXPECTATION : No duplicate customer_id values
-- ============================================================================

SELECT
customer_id,
COUNT(*) AS duplicate_count
FROM dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- ============================================================================
-- CHECK 3 : PRODUCT SURROGATE KEY UNIQUENESS
-- EXPECTATION : No duplicate product_key values
-- ============================================================================

SELECT
product_key,
COUNT(*) AS duplicate_count
FROM dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ============================================================================
-- CHECK 4 : PRODUCT BUSINESS KEY UNIQUENESS
-- EXPECTATION : No duplicate product_number values
-- ============================================================================

SELECT
product_number,
COUNT(*) AS duplicate_count
FROM dim_products
GROUP BY product_number
HAVING COUNT(*) > 1;

-- ============================================================================
-- CHECK 5 : FACT TO DIMENSION REFERENTIAL INTEGRITY
-- EXPECTATION : No orphan fact records
-- ============================================================================

SELECT
f.*
FROM fact_sales f

LEFT JOIN dim_customers c
ON f.customer_key = c.customer_key

LEFT JOIN dim_products p
ON f.product_key = p.product_key

WHERE c.customer_key IS NULL
OR p.product_key IS NULL;

-- ============================================================================
-- CHECK 6 : NULL CUSTOMER KEYS IN FACT TABLE
-- EXPECTATION : No rows
-- ============================================================================

SELECT *
FROM fact_sales
WHERE customer_key IS NULL;

-- ============================================================================
-- CHECK 7 : NULL PRODUCT KEYS IN FACT TABLE
-- ============================================================================

SELECT *
FROM fact_sales
WHERE product_key IS NULL;

-- ============================================================================
-- CHECK 8 : NEGATIVE OR INVALID SALES VALUES
-- EXPECTATION : No rows
-- ============================================================================

SELECT *
FROM fact_sales
WHERE sales_amount <= 0
OR quantity <= 0
OR unit_price <= 0;

-- ============================================================================
-- CHECK 9 : FUTURE ORDER DATES
-- EXPECTATION : No rows
-- ============================================================================

SELECT *
FROM fact_sales
WHERE order_date > CURDATE();

-- ============================================================================
-- CHECK 10 : CUSTOMER GENDER STANDARDIZATION
-- EXPECTATION :
-- Male
-- Female
-- Unknown
-- ============================================================================

SELECT DISTINCT gender
FROM dim_customers;

-- ============================================================================
-- CHECK 11 : PRODUCT LINE STANDARDIZATION
-- EXPECTATION :
-- Mountain
-- Road
-- Touring
-- Other Sales
-- Unknown
-- ============================================================================

SELECT DISTINCT product_line
FROM dim_products;

-- ============================================================================
-- FINAL QUALITY STATUS
-- ============================================================================

SELECT
'Gold Layer Quality Checks Completed Successfully'
AS Validation_Status;
