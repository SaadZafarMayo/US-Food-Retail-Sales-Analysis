# 📊 US Food & Retail Sales Analysis using SQL
> SQL-driven analysis of U.S. food & retail sales, with business insights and investment evaluation.


## Overview
This project explores historical **U.S. food and retail sales data** using **SQL**
to answer business-oriented questions related to trends, industry structure,
business concentration, seasonality, and growth behavior.

Rather than focusing on visualization or fixed outcomes, the project emphasizes
**analytical methodology**, **query design**, and **data-driven reasoning**.
All insights are derived through structured SQL analysis.

---

## Project Goals
- Perform data staging, cleaning, and validation using SQL
- Analyze sales trends across time (monthly & yearly)
- Evaluate performance at industry and business levels
- Examine sub-industries using NAICS codes
- Identify concentration, growth, and variability patterns
- Frame findings in a business and investment analysis context





---

## Key Business Questions Explored
- How do total sales evolve over time across industries?
- Which industries and businesses contribute most to total sales?
- Are sales concentrated among a small number of businesses?
- Do industries exhibit seasonal sales patterns?
- How do NAICS sub-industries differ in scale and growth behavior?
- Which segments show consistent growth or decline over time?

This project emphasizes analytical methodology to answer these questions rather than relying on predefined conclusions.
---

## Reporting & Interpretation
Findings are documented in the `reports/` directory:

- **Key Insights**: Summarizes observed patterns and structural characteristics
- **Investment Analysis**: Frames trends and growth behavior in a strategic context

Both reports are intentionally **result-agnostic** to ensure robustness and
reusability.


---

## Dataset
The dataset contains historical U.S. retail and food services sales figures,
including:
- Time dimensions (month, year)
- NAICS codes
- Industry and business classifications
- Sales values

The data supports multi-level aggregation and time-based analysis.
Raw data is stored in `data/raw/` in **CSV and JSON formats** to support flexible analysis and data ingestion.  


---

## Analytical Approach
The analysis follows a structured workflow:

1. **Data Staging & Validation**
   - Schema replication
   - Data completeness checks
   - Identification of invalid or missing values

2. **Data Cleaning**
   - Standardization of data types
   - Handling of null and inconsistent values

3. **Exploratory & Business Analysis**
   - Aggregations across time, industry, and business
   - Ranking and contribution analysis
   - Growth and change evaluation
   - NAICS-based segmentation

All analysis is implemented directly in SQL.


## Project Structure

```text 

US-Food-Retail-Sales-Analysis/
│
├── data/
│   ├── raw/
│   │   ├── sales_raw.csv       # Original CSV dataset
│   │   └── sales_raw.json      # Original JSON dataset
│
├── sql/
│   ├── 01_staging_validation.sql       # Initial staging table creation & validation
│   ├── 02_data_cleaning.sql           # Correct data types and handle invalid values
│   ├── 03_exploratory_analysis.sql     # SQL queries answering core business questions
│   └── output/                <- CSV outputs for business questions
│       
│
├── reports/
│   ├── key_insights.md
│   └── investment_analysis.md
│
├── README.md
└── LICENSE

```


---

## Tools & Techniques
- **SQL**
  - Aggregations & GROUP BY
  - Common Table Expressions (CTEs)
  - Window functions (`LAG`, `DENSE_RANK`, `PERCENT_RANK`)
  - Time-series comparisons

- **Analytical Concepts**
  - Trend & seasonality analysis
  - Market concentration
  - Growth vs decline classification
  - Contribution analysis

---


## Future Enhancements
- Build interactive dashboards using Tableau or Power BI
- Add forecasting and trend projection
- Enrich analysis with macroeconomic indicators
- Extend analysis to profitability if cost data is available

---