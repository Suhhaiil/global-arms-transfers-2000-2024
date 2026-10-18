# Global Arms Transfers and Defense Trade Architecture (2000–2024)

### A Quantitative Analysis of Supplier Concentration, Decadal Geopolitical Shifts, and Regional Defense Balances

## Project Overview
This project examines the structural dynamics of conventional international defense trade between 2000 and 2024, focusing on supplier concentration, the post-2014 geopolitical shift, longitudinal trade volume trajectories, and regional trade imbalances[cite: 19]. The analysis is built upon the Stockholm International Peace Research Institute (SIPRI) Trend Indicator Values (TIV) dataset, published via the World Bank World Development Indicators (WDI)[cite: 19].

The project integrates end-to-end quantitative methods: data cleaning and First Normal Form (1NF) modeling in Microsoft Excel, relational database architecture in MySQL 8.0, statistical validation and plotting in Python, and dashboard reporting in Microsoft Power BI[cite: 19].

## Research Questions
1. How concentrated is the global arms export market, and what share is controlled by the leading supplier states[cite: 19]?
2. How did major arms transfers shift following the 2014 annexation of Crimea and subsequent international strategic realignments[cite: 19]?
3. What are the longitudinal delivery trajectories across the 2000–2024 timeline[cite: 19]?
4. What structural trade deficits and export-to-import dependency ratios exist across World Bank geographic regions[cite: 19]?

## Repository Structure
- `01_Raw_Data/`: Original wide-format longitudinal datasets from the World Bank WDI / SIPRI.
- `02_Excel/`: Normalized 1NF tidy datasets (`Clean_Data.csv`) and master workbook (`Global_Arms_Transfers_Working.xlsx`).
- `03_SQL/`: MySQL relational schema (`fact_arms_transfers`), bulk ingestion scripts, and analytical window queries (`analysis_queries.sql`).
- `04_Python/`: Jupyter notebook (`Global_arms_transfers_analysis.ipynb`) for statistical validation and Seaborn visualizations.
- `05_PowerBI/`: Interactive Power BI dashboard (`Global_Arms_Trade_Dashboard_2000_2024.pbix`) with custom DAX measures.
- `06_Report/`: Complete academic project report document (`.docx`).
- `07_References/`: Source citations, variable dictionaries, and metadata notes (`SOURCES.md`).
-
