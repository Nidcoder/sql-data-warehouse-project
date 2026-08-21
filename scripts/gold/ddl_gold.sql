/*
====================================================================================
DDL Script: Create Gold Views
====================================================================================
Script Purpose:
	This script create views for the Gold layer in the data warehouses.
	This Gold Layer represents the final dimension and fact tables (Star Schema)

	Each view performs transformations and combines data from the silver layer
	to produce a clean, enriched, and business-ready dataset.


Usage:
	- This view can be queried directly for analytics and reporting.
=====================================================================================
*/


USE DataWarehouse;
-- ==================================================================================
-- CREATE DIMENSIONS:GOLD.DIM_CUSTOMERS
-- ==================================================================================


-- CHECKING FOR THE DUPLICATES ALSO JOINING THE TABLES
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
	DROP VIEW gold.dim_customers;

GO

CREATE VIEW gold.dim_customers AS
		select
		    ROW_NUMBER() OVER(ORDER BY cst_id)AS customer_key,
			ci.cst_id as customer_id,
			ci.cst_key AS customer_number,
			ci.cst_firstname AS first_name,
			ci.cst_lastname AS last_name,
			la.CNTRY AS country,
			ci.cst_marital_status as marital_status,
			CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
	             ELSE coalesce(ca.GEN, 'N/A')
	        END AS gender,
			ca.BDATE AS birthdate,
			ci.cst_create_date AS create_date				
		from silver.crm_cust_info as ci
		LEFT JOIN silver.erp_cust_az12 as ca
		ON  ci.cst_key = ca.cid
		LEFT JOIN silver.erp_loc_a101 as la
		ON ci.cst_key = la.CID
GO

-- Checking for data integration
Select distinct
	ci.cst_gndr,
	ca.GEN,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
	     ELSE coalesce(ca.GEN, 'N/A')
	END AS new_gen
FROM silver.crm_cust_info as ci
LEFT JOIN silver.erp_cust_az12 ca
ON  ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
ORDER BY 1,2;
GO
--- CHECKING VALUES IN VIEW gold.dim_customers;
SELECT * FROM gold.dim_customers;
GO
--- CHECKING THE DISTINCT GENDER IN VIEW
SELECT distinct gender from gold.dim_customers;
GO

-- ==================================================================================
-- CREATE DIMENSIONS:GOLD.DIM_PRODUCTS
-- ==================================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
	DROP VIEW gold.dim_products;
GO
create view gold.dim_products AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt,pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.CAT AS category,
	pc.SUBCAT AS subcategory,
	pc.MAINTENANCE,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date	
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.ID
WHERE prd_end_dt IS NULL;
GO

-- ==================================================================================
-- CREATE DIMENSIONS:GOLD.fact_sales
-- ==================================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
	DROP VIEW gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS
select
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS ship_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sls_sales,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
from silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
	ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
	ON sd.sls_cust_id = cu.customer_id;
GO
