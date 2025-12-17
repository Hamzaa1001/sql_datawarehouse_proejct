# SQL Data Warehouse Project

## Overview
This project demonstrates a **SQL Data Warehouse built from scratch** using a **layered (medallion) architecture**.  
It showcases how raw data from source systems can be transformed and structured for analytics and reporting.

---

## Data Flow & Layers

### 1️⃣ Bronze Layer (Raw Data)
- **Purpose:** Store raw, unprocessed data from source systems (e.g., CRM, Sales, Products).  
- **Characteristics:**  
  - Data is loaded as-is without transformations.  
  - Preserves historical snapshots for auditing.  
  - Handles messy or inconsistent formats.  
- **Data Flow:**  
  - Source CSV/flat files → `LOAD DATA` → Bronze tables.  
  - Invalid or malformed rows can be logged for review.

### 2️⃣ Silver Layer (Cleaned / Conformed Data)
- **Purpose:** Transform and clean raw data into a consistent, standardized format.  
- **Transformations:**  
  - Remove duplicates and null values.  
  - Standardize data types (dates, strings, numbers).  
  - Correct inconsistencies (e.g., `Y/N` → `Yes/No`).  
  - Combine related tables for easier analysis.  
- **Data Flow:**  
  - Bronze tables → ETL → Silver tables (cleaned and structured).

### 3️⃣ Gold Layer (Analytics / Aggregated Data)
- **Purpose:** Provide **analytics-ready data** for dashboards, reporting, and KPIs.  
- **Transformations:**  
  - Aggregate metrics (sales totals, customer counts, etc.).  
  - Join multiple Silver tables to create fact and dimension tables.  
  - Generate summary tables optimized for BI tools.  
- **Data Flow:**  
  - Silver tables → ETL → Gold tables (ready for reporting).

---

## ETL / Pipeline Flow
1. **Extract:** Load data from CSV or source systems into Bronze layer.  
2. **Transform:** Clean, standardize, and enrich data into Silver layer.  
3. **Load:** Aggregate, join, and prepare Gold tables for analytics.  
4. **Output:** Gold tables feed BI dashboards or analytical queries.

---

## Key Features
- **Scalable architecture** — easily extendable to new sources or tables.  
- **Audit-friendly** — preserves historical raw data in Bronze layer.  
- **Optimized for reporting** — Gold layer designed for performance and easy analysis.  

---

## Tools & Technologies
- **Database:** MySQL / SQL Server / PostgreSQL (depending on setup)  
- **ETL:** SQL scripts, data transformations  
- **BI / Visualization:** Tableau, Superset (optional for dashboards)  



Audit-friendly — raw Bronze tables preserve historical data.

Supports reporting & analytics — Gold layer optimized for performance.
