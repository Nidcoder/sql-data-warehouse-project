 
  SELECT   * FROM [DataWarehouse].[bronze].[crm_cust_info]
  
  SELECT  * FROM [DataWarehouse].[bronze].[crm_prd_info]

  SELECT   * FROM [DataWarehouse].[bronze].[crm_sales_details]

  SELECT   * FROM [DataWarehouse].[bronze].[erp_CUST_AZ12]

  select  * from [DataWarehouse].[bronze].erp_LOC_A101;

  select  * from [DataWarehouse].[bronze].erp_PX_CAT_G1V2;
  -----------------------------------------------------------------------
  /*
  DDL SCRIPT:CREATE SILVER TABLES
  =======================================================================
  This script creates tables into 'silver' schema, drpping existing tables
  if they already exists.
  Run this script to re-define the DDL structure of bronze tables
  */

---------------------- creating silver table ------------------------------
select DB_NAME();

USE DataWarehouse;
Go

CREATE OR ALTER PROCEDURE silver.create_silver AS
BEGIN
IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL
      DROP TABLE silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info(
   cst_id INT,
   cst_key NVARCHAR(50),
   cst_firstname NVARCHAR(50),
   cst_lastname NVARCHAR(50),
   cst_marital_status NVARCHAR(50),
   cst_gndr NVARCHAR(50),
   cst_create_date DATE,
   dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
      DROP TABLE silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info(
   prd_id INT,
   cat_id NVARCHAR(50),
   prd_key NVARCHAR(50),
   prd_nm NVARCHAR(50),
   prd_cost INT,
   prd_line NVARCHAR(50),
   prd_start_dt DATE,
   prd_end_dt DATE,
   dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_sales_details', 'U') IS NOT NULL
        DROP TABLE silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details(
   sls_ord_num NVARCHAR(50),
   sls_prd_key NVARCHAR(50),
   sls_cust_id INT,
   sls_order_dt DATE,
   sls_ship_dt DATE,
   sls_due_dt DATE,
   sls_sales INT,
   sls_quantity INT,
   sls_price INT,
   dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_CUST_AZ12', 'U') IS NOT NULL
    DROP TABLE silver.erp_CUST_AZ12;

CREATE TABLE silver.erp_CUST_AZ12(
     CID NVARCHAR(50),
     BDATE DATE,
     GEN NVARCHAR(50),
     dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.erp_LOC_A101', 'U') IS NOT NULL
     DROP TABLE silver.erp_LOC_A101;

CREATE TABLE silver.erp_LOC_A101(
     CID NVARCHAR(50),
     CNTRY NVARCHAR(50),
     dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_PX_CAT_G1V2', 'U') IS NOT NULL
     DROP TABLE silver.erp_PX_CAT_G1V2;

CREATE TABLE silver.erp_PX_CAT_G1V2(
     ID NVARCHAR(50),
     CAT NVARCHAR(50),
     SUBCAT NVARCHAR(50),
     MAINTENANCE NVARCHAR(50),
     dwh_create_date DATETIME2 DEFAULT GETDATE()
);

END
GO
 

select * from silver.crm_cust_info;
select * from silver.crm_prd_info;
select * from silver.crm_sales_details;
SELECT * FROM silver.erp_CUST_AZ12;
SELECT * FROM silver.erp_LOC_A101;
select * from silver.erp_PX_CAT_G1V2;  
