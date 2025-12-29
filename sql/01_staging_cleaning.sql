/*
====================================================
File: 01_staging_cleaning.sql
Project: US Food & Retail Sales Analysis
Purpose: Create staging table and perform basic data checks
====================================================
*/

-- --------------------------------------------------
-- 1. Initial Data Validation
-- --------------------------------------------------

-- Check maximum ID value
SELECT MAX(id) AS max_id
FROM sales;

-- Identify records with missing or invalid business names
SELECT *
FROM sales
WHERE kind_of_business = 'NONE';


-- --------------------------------------------------
-- 2. Create Staging Table
-- --------------------------------------------------

-- Create a staging table identical to the original table
CREATE TABLE sales_staging LIKE sales;


-- --------------------------------------------------
-- 3. Load Data into Staging Table
-- --------------------------------------------------

INSERT INTO sales_staging
SELECT *
FROM sales;


-- --------------------------------------------------
-- 4. Verify Staging Table
-- --------------------------------------------------

-- Confirm data was copied correctly
SELECT *
FROM sales_staging;
