/* ==============================================================================
   PROJECT: Global Arms Transfers & Defense Policy Analytics (2000–2024)
   DATABASE: defense_trade_db
   ENGINE: MySQL 8.0+
   DATASET: SIPRI / World Bank TIV Indicators
   ============================================================================== */

CREATE DATABASE IF NOT EXISTS defense_trade_db;
USE defense_trade_db;

-- 1. DDL: Fact Table Architecture
DROP TABLE IF EXISTS fact_arms_transfers;

CREATE TABLE fact_arms_transfers (
    Country_Name VARCHAR(150),
    Country_Code VARCHAR(10),
    Year INT,
    Exports_TIV BIGINT DEFAULT 0,
    Imports_TIV BIGINT DEFAULT 0,
    Region VARCHAR(100),
    Income_Group VARCHAR(100),
    Net_Trade_TIV BIGINT,
    Total_Volume_TIV BIGINT,
    INDEX idx_country_year (Country_Code, Year),
    INDEX idx_region (Region)
);

-- 2. Ingestion Pipeline (Handles Formatted Delimiters & Nulls)
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE "C:/Users/moham/OneDrive/Desktop/Erasmus Mundus/08 Projects/04_global-arms-transfers/02_Excel/Clean_Data.csv"
INTO TABLE fact_arms_transfers
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    Country_Name, 
    Country_Code, 
    Year, 
    @raw_exp, 
    @raw_imp, 
    Region, 
    Income_Group, 
    @raw_net, 
    @raw_vol
)
SET 
    Exports_TIV      = CAST(REPLACE(COALESCE(NULLIF(TRIM(@raw_exp), ''), '0'), ',', '') AS SIGNED),
    Imports_TIV      = CAST(REPLACE(COALESCE(NULLIF(TRIM(@raw_imp), ''), '0'), ',', '') AS SIGNED),
    Net_Trade_TIV    = CAST(REPLACE(COALESCE(NULLIF(TRIM(@raw_net), ''), '0'), ',', '') AS SIGNED),
    Total_Volume_TIV = CAST(REPLACE(COALESCE(NULLIF(TRIM(@raw_vol), ''), '0'), ',', '') AS SIGNED);

-- 3. Analytical Query 1: Top 10 Global Exporters & Market Share
WITH cumulative_summary AS (
    SELECT 
        Country_Name,
        Country_Code,
        SUM(Exports_TIV) AS total_exports_tiv
    FROM fact_arms_transfers
    WHERE Region <> 'Regional Aggregate'
    GROUP BY Country_Name, Country_Code
),
global_pool AS (
    SELECT SUM(total_exports_tiv) AS global_total_exports 
    FROM cumulative_summary
)
SELECT 
    DENSE_RANK() OVER (ORDER BY cs.total_exports_tiv DESC) AS export_rank,
    cs.Country_Name,
    cs.Country_Code,
    cs.total_exports_tiv,
    ROUND((cs.total_exports_tiv / gp.global_total_exports) * 100, 2) AS market_share_pct
FROM cumulative_summary cs
CROSS JOIN global_pool gp
ORDER BY export_rank ASC
LIMIT 10;

-- 4. Analytical Query 2: Top 10 Arms Importers & Procurement Deficits
SELECT 
    DENSE_RANK() OVER (ORDER BY SUM(Imports_TIV) DESC) AS import_rank,
    Country_Name,
    Country_Code,
    SUM(Imports_TIV) AS total_imports_tiv,
    SUM(Net_Trade_TIV) AS cumulative_net_trade
FROM fact_arms_transfers
WHERE Region <> 'Regional Aggregate'
GROUP BY Country_Name, Country_Code
ORDER BY import_rank ASC
LIMIT 10;

-- 5. Analytical Query 3: Decadal Strategic Shift (Pre vs Post-2014)
WITH era_aggregation AS (
    SELECT 
        Country_Name,
        Country_Code,
        SUM(CASE WHEN Year BETWEEN 2000 AND 2013 THEN Exports_TIV ELSE 0 END) AS exp_era_1,
        SUM(CASE WHEN Year BETWEEN 2014 AND 2024 THEN Exports_TIV ELSE 0 END) AS exp_era_2,
        SUM(CASE WHEN Year BETWEEN 2000 AND 2013 THEN Imports_TIV ELSE 0 END) AS imp_era_1,
        SUM(CASE WHEN Year BETWEEN 2014 AND 2024 THEN Imports_TIV ELSE 0 END) AS imp_era_2
    FROM fact_arms_transfers
    WHERE Region <> 'Regional Aggregate'
    GROUP BY Country_Name, Country_Code
)
SELECT 
    Country_Name,
    Country_Code,
    exp_era_1 AS exports_2000_2013,
    exp_era_2 AS exports_2014_2024,
    ROUND(CASE WHEN exp_era_1 = 0 THEN NULL ELSE ((exp_era_2 - exp_era_1) / exp_era_1) * 100 END, 2) AS export_growth_pct,
    imp_era_1 AS imports_2000_2013,
    imp_era_2 AS imports_2014_2024,
    ROUND(CASE WHEN imp_era_1 = 0 THEN NULL ELSE ((imp_era_2 - imp_era_1) / imp_era_1) * 100 END, 2) AS import_growth_pct
FROM era_aggregation
WHERE (exp_era_1 + exp_era_2) > 10000000000
ORDER BY export_growth_pct DESC;

-- 6. Analytical Query 4: Longitudinal Momentum (YoY Changes via LAG)
WITH yearly_global AS (
    SELECT 
        Year,
        SUM(Exports_TIV) AS annual_global_exports
    FROM fact_arms_transfers
    WHERE Region <> 'Regional Aggregate'
    GROUP BY Year
)
SELECT 
    Year,
    annual_global_exports,
    LAG(annual_global_exports, 1) OVER (ORDER BY Year) AS prev_year_exports,
    annual_global_exports - LAG(annual_global_exports, 1) OVER (ORDER BY Year) AS yoy_absolute_change,
    ROUND(((annual_global_exports - LAG(annual_global_exports, 1) OVER (ORDER BY Year)) / LAG(annual_global_exports, 1) OVER (ORDER BY Year)) * 100, 2) AS yoy_growth_pct
FROM yearly_global
ORDER BY Year ASC;

-- 7. Analytical Query 5: Regional Defense Trade Balance
SELECT 
    Region,
    SUM(Exports_TIV) AS total_regional_exports,
    SUM(Imports_TIV) AS total_regional_imports,
    SUM(Net_Trade_TIV) AS regional_net_balance,
    ROUND(CASE WHEN SUM(Imports_TIV) = 0 THEN NULL ELSE SUM(Exports_TIV) / SUM(Imports_TIV) END, 2) AS export_to_import_ratio
FROM fact_arms_transfers
WHERE Region <> 'Regional Aggregate'
GROUP BY Region
ORDER BY regional_net_balance DESC;