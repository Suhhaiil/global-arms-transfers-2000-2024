# Global Arms Transfers and Defense Trade Architecture (2000–2024)

### A Quantitative Analysis of Supplier Concentration, Decadal Geopolitical Shifts, and Regional Defense Balances

## Project Overview
This project examines the structural dynamics of conventional international defense trade between 2000 and 2024, focusing on supplier concentration, the post-2014 geopolitical shift, longitudinal trade volume trajectories, and regional trade imbalances. The analysis is built upon the Stockholm International Peace Research Institute (SIPRI) Trend Indicator Values (TIV) dataset, published via the World Bank World Development Indicators (WDI).

The project integrates end-to-end quantitative methods: data cleaning and First Normal Form (1NF) modeling in Microsoft Excel, relational database architecture in MySQL 8.0, statistical validation and plotting in Python, and dashboard reporting in Microsoft Power BI.

## Research Questions
1. How concentrated is the global arms export market, and what share is controlled by the leading supplier states?
2. How did major arms transfers shift following the 2014 annexation of Crimea and subsequent international strategic realignments?
3. What are the longitudinal delivery trajectories across the 2000–2024 timeline?
4. What structural trade deficits and export-to-import dependency ratios exist across World Bank geographic regions?

## Repository Structure
- `01_Raw_Data/`: Original wide-format longitudinal datasets from the World Bank WDI / SIPRI.
- `02_Excel/`: Normalized 1NF tidy datasets (`Clean_Data.csv`) and master workbook (`Global_Arms_Transfers_Working.xlsx`).
- `03_SQL/`: MySQL relational schema (`fact_arms_transfers`), bulk ingestion scripts, and analytical window queries (`analysis_queries.sql`).
- `04_Python/`: Jupyter notebook (`Global_arms_transfers_analysis.ipynb`) for statistical validation and Seaborn visualizations.
- `05_PowerBI/`: Interactive Power BI dashboard (`Global_Arms_Trade_Dashboard_2000_2024.pbix`) with custom DAX measures.
- `06_Report/`: Complete academic project report document (`.docx`).
- `07_References/`: Source citations, variable dictionaries, and metadata notes (`SOURCES.md`).
- `08_Final/`: High-resolution dashboard overview screenshots and visual deliverables.

## Data Source and Scope
- **Source:** Stockholm International Peace Research Institute (SIPRI) / World Bank Open Data (WDI).
- **Indicators:**
  - `MS.MIL.XPRT.KD`: Arms exports (SIPRI trend indicator values).
  - `MS.MIL.MPRT.KD`: Arms imports (SIPRI trend indicator values).
- **Measurement Unit:** SIPRI Trend Indicator Value (TIV), expressed in millions/billions of constant 1990 US dollars, measuring volume of conventional military equipment transferred rather than raw financial transaction values.
- **Scope:** 2,973 sovereign observation rows across 181 unique nations over 25 years (2000–2024), excluding macro-regional aggregates.

## Key Findings
- **High Supplier Concentration:** Cumulative global arms exports reached 646.33 billion TIV (2000–2024). The United States (34.4%) and the Russian Federation (20.8%) account for 55.2% of all cumulative global exports. The top 10 exporters collectively represent 88.0% of the global total.
- **Post-2014 Strategic Realignment:** Following the 2014 Crimean annexation, Russian exports fell by 42.65%. In contrast, US (+19.83%) and French (+26.28%) exports expanded, alongside rapid growth among emerging middle-power suppliers such as South Korea (+175.90%) and Türkiye (+300.92%).
- **Regional Imbalances:** North America (9.86x) and Europe & Central Asia (2.62x) operate as the sole net-exporting regions. The Middle East & North Africa (0.11x) and South Asia (0.03x) exhibit heavy procurement deficits and reliance on external equipment suppliers.

## Tools and Technologies
- **Microsoft Excel:** Data ingestion, column unpivoting to 1NF, metadata merging, and cross-tabulation.
- **SQL (MySQL 8.0):** Relational fact table design, index creation, CTEs, and window functions (`DENSE_RANK()`, `LAG()`).
- **Python (Pandas & NumPy):** Data validation, aggregation verification, and group statistical metrics.
- **Matplotlib & Seaborn:** Generation of annotated horizontal bar charts and longitudinal trend plots.
- **Microsoft Power BI:** 7 custom DAX measures, dynamic temporal/regional slicer filtering, and executive canvas layout design.

## Author
**Suhail Alam Mansoori**  
B.A. (Hons.) Political Science, University of Delhi
