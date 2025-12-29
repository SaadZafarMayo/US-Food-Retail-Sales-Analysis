/*
====================================================
File: 02_data_cleaning.sql
Project: US Food & Retail Sales Analysis
Purpose: Handle invalid sales values and enforce correct data types
====================================================
*/

-- --------------------------------------------------
-- 1. Identify Invalid Sales Values
-- --------------------------------------------------

-- Check for non-numeric values in the sales column
SELECT *
FROM sales_staging
WHERE sales = 'NONE';


-- --------------------------------------------------
-- 2. Handle Invalid Values
-- --------------------------------------------------

-- Convert invalid sales values to NULL
UPDATE sales_staging
SET sales = NULL
WHERE sales = 'NONE';


-- --------------------------------------------------
-- 3. Data Type Correction
-- --------------------------------------------------

-- Change sales column from TEXT to INTEGER
ALTER TABLE sales_staging
MODIFY COLUMN sales INT;


-- --------------------------------------------------
-- 4. Final Verification
-- --------------------------------------------------

-- Verify cleaned data
SELECT *
FROM sales_staging;
