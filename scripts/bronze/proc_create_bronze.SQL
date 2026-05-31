/*
================================================================================================================
CREATE BRONZE LAYER
================================================================================================================
	I have created 6 different tables from two different sources 'crm', 'erp' in this layer and 
	also I have load the data in bulk load in this sql file 

	I have also calculated load duration of whole batch as well as every table execution.
	I have also created stored procedure for each for creating the table and loading data into tables.
================================================================================================================

*/
select DB_NAME();

USE DataWarehouse;
Go

CREATE OR ALTER PROCEDURE bronze.create_bronze AS
BEGIN
	IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
		DROP TABLE bronze.crm_cust_info;

	create table bronze.crm_cust_info(
		cst_id INT,
		cst_key NVARCHAR(50),
		cst_firstname NVARCHAR(50),
		cst_lastname NVARCHAR(50),
		cst_material_status NVARCHAR(50),
		cst_gndr NVARCHAR(50),
		cst_create_date DATE
	);

	IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
		DROP TABLE bronze.crm_prd_info;

	create table bronze.crm_prd_info(
		prd_id INT,
		prd_key NVARCHAR(50),
		prd_nm NVARCHAR(70),
		prd_cost INT,
		prd_line NVARCHAR(50),
		prd_start_dt DATE,
		prd_end_dt DATE
	);

	IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
		DROP TABLE bronze.crm_sales_details;

	create table bronze.crm_sales_details(
		sls_ord_num NVARCHAR(50),
		sls_prd_key NVARCHAR(50),
		sls_cust_id INT,
		sls_order_dt INT,
		sls_ship_dt INT,
		sls_due_dt INT,
		sls_sales INT,
		sls_quantity INT,
		sls_price INT
	);

	IF OBJECT_ID ('bronze.erp_CUST_AZ12', 'U') IS NOT NULL
		DROP TABLE bronze.erp_CUST_AZ12;

	create table bronze.erp_CUST_AZ12(
		CID NVARCHAR(50),
		BDATE DATE,
		GEN NVARCHAR(50)
	);

	IF OBJECT_ID ('bronze.erp_LOC_A101', 'U') IS NOT NULL
		DROP TABLE bronze.erp_LOC_A101;

	create table bronze.erp_LOC_A101(
		CID NVARCHAR(50),
		CNTRY NVARCHAR(50)
	);

	IF OBJECT_ID ('bronze.erp_PX_CAT_G1V2', 'U') IS NOT NULL
		DROP TABLE bronze.erp_PX_CAT_G1V2;

	create table bronze.erp_PX_CAT_G1V2(
		ID NVARCHAR(50),
		CAT NVARCHAR(50),
		SUBCAT NVARCHAR(50),
		MAINTENANCE NVARCHAR(50)
	);
END
GO
