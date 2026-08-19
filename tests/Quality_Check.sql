-- TO GIVE ROWNUMBER TO ALL AS WELL AS DUPLICATES

SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS FLAG_LAST
FROM bronze.crm_cust_info
where cst_id = 29433;

-- TO SEE WHERE DUPLICATES ARE THERE AS WELL AS WHICH ONE TO PREFER
SELECT 
*
FROM(
SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS FLAG_LAST
FROM bronze.crm_cust_info)T
WHERE FLAG_LAST != 1;

-- TO SEE WHERE ALL CUSTOMER ARE UNIQUE;
SELECT 
*
FROM(
SELECT
*,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS FLAG_LAST
FROM bronze.crm_cust_info)T
WHERE FLAG_LAST = 1;

-- CHECK FOR DUPLICATES AND NULL VALUES (PRIMARY KEY)
-- EXPECTATION : NO RESULT
USE DataWarehouse;
SELECT
cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1
order by cst_id;

-- CHECK FOR UNWANTED SPACES
-- expectation - no result
SELECT cst_firstname
from bronze.crm_cust_info
where cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
from bronze.crm_cust_info
where cst_lastname != TRIM(cst_lastname);

SELECT cst_gndr
from bronze.crm_cust_info
where cst_gndr != TRIM(cst_gndr);

-- Data Standardization & consistency

SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;
-- now moving onto next table i.e crm_prd_info
-- CHECKING DUPLICATES AND NULL VALUES IN PRD_ID WHICH IS A PRIMARY KEY
-- EXPECTATION-- NO RESULT


SELECT DB_NAME() AS CurrentDatabase;
use DataWarehouse; 

select * from bronze.crm_prd_info;
select  * from [DataWarehouse].[bronze].erp_PX_CAT_G1V2;
SELECT
prd_id,
count(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id is null;

-- TO CREATE A SUBSTRING AS CAT_ID AND SUBSTRING AS PRD_KEY;
SELECT
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
substring(prd_key, 7,LEN(prd_key)) as prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
from bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key,1,5), '-','_') NOT IN
(SELECT DISTINCT id from bronze.erp_PX_CAT_G1V2);


select sls_prd_key from bronze.crm_sales_details

-- REPLACING THE '-' TO '_' 
SELECT
prd_id,
prd_key,
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
substring(prd_key, 7,LEN(prd_key)) as prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
from bronze.crm_prd_info
WHERE SUBSTRING(prd_key, 7, LEN(prd_key)) NOT IN
(SELECT distinct sls_prd_key from bronze.crm_sales_details);
-- CHECKING WHETHER prd_nm is not having space
-- EXPECTATION : NO RESULT
SELECT prd_nm
FROM bronze.crm_prd_info
where prd_nm != TRIM(prd_nm)

-- CHECKING FOR NULLS OR NEGATIVE NUMBERS
-- EXPECTATION : NO RESULT

SELECT prd_cost
from bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

select * from bronze.crm_prd_info;
--CHECK FOR INVALID DATE ORDERS
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

select
prd_id,
prd_key,
prd_nm,
prd_start_dt,
prd_end_dt,
dateadd(DAY,-1,LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt_test
from bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509')

-- CLEAN AND LOAD NEW TABLE I.E CRM_SALES_DETAILS
use DataWarehouse;
-- 1.

select
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details
where sls_ord_num != TRIM(sls_ord_num);

--2.
select
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details
where sls_prd_key != TRIM(sls_prd_key);

--3.
  SELECT   * FROM [DataWarehouse].[bronze].[crm_cust_info]
  
  SELECT  * FROM [DataWarehouse].[bronze].[crm_prd_info]

  select
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
     ELSE CAST(CAST(sls_order_dt AS VARCHAR)AS DATE)
END AS sls_order_dt,
CAST(CAST(sls_ship_dt AS VARCHAR)AS DATE) AS sls_ship_dt,
CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) AS sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from bronze.crm_sales_details
where sls_cust_id not in (select cst_id from silver.crm_cust_info);

select * from silver.crm_sales_details;
-- CLEAN AND LOAD NEW TABLE I.E CRM_SALES_DETAILS

select * from bronze.crm_sales_details
SELECT
sls_cust_id,
NULLIF(sls_order_dt,0) AS sls_order_dt
from bronze.crm_sales_details
where sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 OR sls_order_dt > 20500101;

select
NULLIF(sls_ship_dt,0) AS sls_ship_dt
from bronze.crm_sales_details
where sls_ship_dt <= 0 OR LEN(sls_ship_dt) !=8 OR sls_ship_dt > 20500101;

select
sls_order_dt 
from
bronze.crm_sales_details
where sls_order_dt = 0;

select
sls_due_dt 
from
bronze.crm_sales_details
where sls_due_dt < = 0 OR LEN(sls_due_dt) != 8;

-- CHECKING FOR INVALID DATE
-- CHECKING FOR VALID SLS_PRICE
-- >> SALES = QUANTITY* PRICE
-- >> VALUES MUST NOT BE NULL,ZERO, OR NEGATIVE

SELECT DISTINCT
sls_sales AS old_sls_sales,
sls_quantity,
sls_price as old_sls_price,
CASE WHEN sls_sales IS null or sls_sales <=0 OR sls_sales != sls_quantity* ABS(sls_price)
      THEN sls_quantity * ABS(sls_price)
    ELSE sls_sales
END AS sls_sales,

CASE WHEN sls_price IS NULL OR sls_price <=0
      THEN ABS(sls_sales)/NULLIF(sls_quantity,0)
    ELSE sls_price
END AS sls_price
from bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
or sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0
ORDER BY sls_sales

-- CLEAN AND LOAD NEW TABLE I.E ERP_CUST_AZ12
SELECT cid,
CASE WHEN CID LIKE 'NAS%'THEN SUBSTRING(cid,4,LEN(CID))
     ELSE CID
END cid,
BDATE,
GEN
from bronze.erp_cust_az12
WHERE CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(CID))
      ELSE CID
END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)
--------------------------------------------------------------------------
SELECT 
CASE WHEN CID LIKE 'NAS%'THEN SUBSTRING(cid,4,LEN(CID))
     ELSE CID
END cid,
BDATE,
CASE WHEN bdate > GETDATE() THEN NULL
    ELSE BDATE
END AS BDATE,
CASE WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
     WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
     ELSE 'N/A'
END AS GEN
from bronze.erp_cust_az12
---------------------------------------------------------------------------
-- check for gen
SELECT DISTINCT
GEN,
CASE WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
     WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
     ELSE 'N/A'
END AS GEN
FROM bronze.erp_cust_az12;
----------------------------------------------------------------------------
-- VALID BDATE
SELECT 
BDATE
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' or bdate > GETDATE();
----------------------------------------------------------------------------
-- CLEANING AND LOADING DATA IN NEW TABLE I.E BRONZE.ERP_LOC_A101;
SELECT
REPLACE(CID, '-','') AS CID,
CNTRY
FROM bronze.erp_LOC_A101 
WHERE REPLACE(CID, '-','') NOT IN
(SELECT cst_key FROM silver.crm_cust_info);
------------------------------------------------------------------------------
SELECT
REPLACE(CID, '-','') AS CID,
case when TRIM(CNTRY) = 'DE' THEN 'Germany'
     when TRIM(CNTRY) IN ('US','USA') THEN 'United States'
     WHEN TRIM(CNTRY) = ' ' OR CNTRY IS NULL THEN 'N/A'
     ELSE TRIM(CNTRY)
END AS CNTRY
FROM bronze.erp_LOC_A101 

-- DATA STANDARDISATION & CONSISTENCY
SELECT DISTINCT CNTRY
FROM bronze.erp_LOC_A101
ORDER BY cntry;
--------------------------------------------------------------------------------------

SELECT DISTINCT case when TRIM(CNTRY) = 'DE' THEN 'Germany'
     when TRIM(CNTRY) IN ('US','USA') THEN 'United States'
     WHEN TRIM(CNTRY) = ' ' OR CNTRY IS NULL THEN 'N/A'
     ELSE TRIM(CNTRY)
END AS CNTRY
FROM bronze.erp_LOC_A101
ORDER BY cntry;

--------------------------------------------------------------------------------------
--- CLAENING AND LOADING INTO NEW TABLE (SILVER.erp_PX_CAT_G1V2)
select
id,
cat,
subcat,
maintenance
from bronze.erp_PX_CAT_G1V2;
--------------------------------------------------------------------------------------------
SELECT *
from silver.crm_prd_info;
-------------------------------------------------------------------------------------------
select * from
bronze.erp_PX_CAT_G1V2 
where cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != trim(maintenance);
-------------------------------------------------------------------------------------------
SELECT DISTINCT 
cat 
from bronze.erp_PX_CAT_G1V2;
--------------------------------------------------------------------------------------------
SELECT DISTINCT 
subcat 
from bronze.erp_PX_CAT_G1V2;
--------------------------------------------------------------------------------------------
SELECT DISTINCT 
maintenance 
from bronze.erp_PX_CAT_G1V2;
--------------------------------------------------------------------------------------------
