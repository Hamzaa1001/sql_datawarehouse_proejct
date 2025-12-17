/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/
-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO
  
CREATE VIEW gold.dim_customers AS 
select 
ROW_NUMBER() OVER (ORDER BY cst_id) AS custumer_key,
cst_id as custumer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name ,
ci.cst_lastname as lsat_name,
la.cntry as country,
ci.cst_marital_status as material_status,
CASE WHEN ci.cst_gndr != 'n/a' Then ci.cst_gndr
ELSE COALESCE(ca.gen,'n/a')
END AS gender,
ca.bdate as birthday,
ci.cst_create_date as create_date
from silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key=ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key=la.cid

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS 
Select
ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt,pn.prd_key) as product_key,
pn.prd_id as product_id,
pn.cat_id category,
pn.prd_key as product_number,
pc.cat as category_id,
pc.subcat as sub_category_id,
pn.prd_nm as product_name,
pn.prd_cost as cost,
pn.prd_line as produce_line,
pn.prd_start_dt as start_date,
pc.maintenance
from silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id=pc.id 
 WHERE prd_end_dt IS NULL --Filter out historical Data

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
  IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO
  
CREATE VIEW gold.fact_sales AS 
select
pr.product_key,
cu.custumer_key,
sd.sls_ord_num,
sd.sls_order_dt,
sd.sls_ship_dt,
sd.sls_due_dt,
sd.sls_sales,
sd.sls_quantity,
sd.sls_price
from silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key=pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id=cu.custumer_id
