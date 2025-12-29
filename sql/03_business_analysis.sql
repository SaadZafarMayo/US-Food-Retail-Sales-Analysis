/*
====================================================
File: 03_business_analysis.sql
Project: US Food & Retail Sales Analysis
Purpose: Answer core business questions using SQL
====================================================
*/

-- ==================================================
-- 1️⃣ Overall & Trend Analysis
-- ==================================================

-- Q1: Which industries had the highest total sales each year?

WITH industry_sales AS (
    SELECT
        year, 
        industry,
        SUM(sales) AS total_sales,
        DENSE_RANK() OVER (
            PARTITION BY year 
            ORDER BY SUM(sales) DESC
        ) AS rnk
    FROM sales_staging
    GROUP BY year, industry
)
SELECT year, industry, total_sales
FROM industry_sales
WHERE rnk = 1;


-- --------------------------------------------------
-- Q2: How did total sales change month-over-month?
-- --------------------------------------------------

WITH monthly_sales AS (
    SELECT
        year,
        month,
        SUM(sales) AS current_month_sales,
        LAG(SUM(sales)) OVER (ORDER BY year, month) AS prev_month_sales
    FROM sales_staging
    GROUP BY year, month
)
SELECT
    *,
    current_month_sales - prev_month_sales AS diff_sales_month,
    ROUND(
        (current_month_sales - prev_month_sales) / prev_month_sales * 100,
        2
    ) AS pct_change
FROM monthly_sales;


-- --------------------------------------------------
-- Q3: Which months have the highest and lowest sales?
-- --------------------------------------------------

WITH monthly_totals AS (
    SELECT
        month,
        SUM(sales) AS total_sales,
        DENSE_RANK() OVER (ORDER BY SUM(sales)) AS rnk
    FROM sales_staging
    GROUP BY month
)
SELECT month, total_sales
FROM monthly_totals
WHERE rnk = 1
   OR rnk = (SELECT MAX(rnk) FROM monthly_totals);


-- --------------------------------------------------
-- Q4: Are there seasonal patterns for specific industries?
-- --------------------------------------------------

SELECT
    industry,
    month,
    SUM(sales) AS total_monthly_sales,
    DENSE_RANK() OVER (
        PARTITION BY industry 
        ORDER BY SUM(sales) DESC
    ) AS rnk
FROM sales_staging
GROUP BY industry, month
ORDER BY industry, rnk;

-- ==================================================
-- 2️⃣ Industry & Business-Level Insights
-- ==================================================

-- Q5: Top contributing businesses within each industry

WITH ranked_businesses AS (
    SELECT
        industry,
        kind_of_business,
        SUM(sales) AS total_sales,
        DENSE_RANK() OVER (
            PARTITION BY industry 
            ORDER BY SUM(sales) DESC
        ) AS rnk
    FROM sales_staging
    GROUP BY industry, kind_of_business
)
SELECT *
FROM ranked_businesses
WHERE rnk = 1;


-- --------------------------------------------------
-- Q6: Do one or two businesses dominate industry (who dominates...not how much?
-- “Who are the biggest players in each industry?”
-- --------------------------------------------------
WITH ranked_businesses AS (
    SELECT
        industry,
        kind_of_business,
        SUM(sales) AS total_sales,
        DENSE_RANK() OVER (
            PARTITION BY industry 
            ORDER BY SUM(sales) DESC
        ) AS rnk
    FROM sales_staging
    GROUP BY industry, kind_of_business
)
SELECT *
FROM ranked_businesses
WHERE rnk <= 2;


-- --------------------------------------------------
-- Q7: Contribution percentage of top businesses per industry
-- “How much of the industry’s revenue does each top business control?”
-- --------------------------------------------------

WITH business_sales AS (
    SELECT industry, kind_of_business, SUM(sales) AS business_sales
    FROM sales_staging
    GROUP BY industry, kind_of_business
),
industry_totals AS (
    SELECT industry, SUM(business_sales) AS industry_sales
    FROM business_sales
    GROUP BY industry
)
SELECT
    b.industry,
    b.kind_of_business,
    b.business_sales,
    ROUND((b.business_sales / i.industry_sales) * 100 , 2) AS pct_of_industry
FROM business_sales b
JOIN industry_totals i
  ON b.industry = i.industry
ORDER BY b.industry, pct_of_industry DESC;


-- --------------------------------------------------
-- Q8: Compare small vs mid vs large businesses
-- --------------------------------------------------

WITH ranked_businesses AS (
    SELECT
        industry,
        kind_of_business,
        SUM(sales) AS total_sales,
        PERCENT_RANK() OVER (
            PARTITION BY industry 
            ORDER BY SUM(sales) DESC
        ) * 100 AS perc_rank
    FROM sales_staging
    GROUP BY industry, kind_of_business
)
SELECT
    *,
    CASE
        WHEN perc_rank <= 25 THEN 'LARGE'
        WHEN perc_rank > 25 and perc_rank <= 60 THEN 'MID'
        ELSE 'SMALL'
    END AS business_size
FROM ranked_businesses;

-- ==================================================
-- 3️⃣ Sub-Industry / NAICS Analysis
-- ==================================================

-- Q9: Sales by major NAICS groups

select distinct(LEFT(naics_code, 2)) from sales_staging;

WITH naics_sales AS (
    SELECT
        LEFT(naics_code, 2) AS major_naics,
        SUM(sales) AS total_sales
    FROM sales_staging
    GROUP BY major_naics
)
SELECT
    *,
    ROUND(total_sales * 100 / SUM(total_sales) OVER (), 2) AS pct_of_total
FROM naics_sales
ORDER BY total_sales DESC;


-- --------------------------------------------------
-- Q10: Top-performing sub-industries/ (naics or business) within each industry
-- --------------------------------------------------

SELECT
    industry,
    kind_of_business,
    naics_code,
    SUM(sales) AS total_sales,
    ROUND(
        SUM(sales) * 100 / SUM(SUM(sales)) OVER (PARTITION BY industry),
        2
    ) AS pct_contribution
FROM sales_staging
GROUP BY industry, kind_of_business, naics_code
ORDER BY industry, total_sales DESC;


-- --------------------------------------------------
-- Q11: NAICS sub-industries with consistent year-over-year growth
-- --------------------------------------------------

WITH yearly_naics_sales AS (
    SELECT
        naics_code,
        kind_of_business,
        year,
        SUM(sales) AS yearly_sales,
        LAG(SUM(sales)) OVER (
            PARTITION BY naics_code , kind_of_business
            ORDER BY year
        ) AS prev_year_sales
    FROM sales_staging
    GROUP BY naics_code,kind_of_business, year
)
SELECT
    *,
    yearly_sales - prev_year_sales AS diff,
    ROUND(
        (yearly_sales - prev_year_sales) / prev_year_sales * 100,
        2
    ) AS pct_change
FROM yearly_naics_sales;

-- ==================================================
-- 4️⃣ Growth & Change
-- ==================================================

-- Q12: Identify growing vs declining businesses

WITH yearly_business_sales AS (
    SELECT
        industry,
        kind_of_business,
        year,
        SUM(sales) AS yearly_sales,
        LAG(SUM(sales)) OVER (
            PARTITION BY industry, kind_of_business
            ORDER BY year
        ) AS prev_year_sales
    FROM sales_staging
    GROUP BY industry, kind_of_business, year
)
SELECT
    industry,
    kind_of_business,
    CASE
        WHEN MIN(yearly_sales - prev_year_sales) >= 0 THEN 'GROWING'
        WHEN MAX(yearly_sales - prev_year_sales) <= 0 THEN 'DECLINING'
        ELSE 'FLUCTUATING'
    END AS trend
FROM yearly_business_sales
GROUP BY industry, kind_of_business;


-- ==================================================
-- 5️⃣ Executive Insight
-- ==================================================

-- Q13: Based on the above analysis, which industries or businesses
--      are suitable for investment or expansion?
-- (Answered in report/investment_analysis.md)
