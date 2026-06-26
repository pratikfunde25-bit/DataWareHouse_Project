/*
===============================================================================
Procedure Script: Load Silver Layer
===============================================================================

PURPOSE:
    Transform Bronze raw data into cleansed Silver tables.

EXPECTED LOGIC:
    - Standardize codes and names.
    - Clean invalid dates and numeric values.
    - Remove duplicates.
    - Apply data quality rules.
===============================================================================
*/

USE dw_silver;
