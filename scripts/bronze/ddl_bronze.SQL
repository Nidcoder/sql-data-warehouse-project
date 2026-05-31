/*
================================================================================================================
CREATE BRONZE LAYER
================================================================================================================
	I have created 6 different tables from two different sources 'crm', 'erp' in this layer and 
	also I have load the data in bulk load in this sql file 

	I have also calculated load duration of whole batch as well as every table execution.
	I have also created stored procedure for each for creating the table and loading data into tables.
=================================================================================================================
*/
select DB_NAME();

USE DataWarehouse;
Go

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



-- Bulk insert the data in this sql file
	print '=========================================================================='
	print 'Loading Bronze CRM Layer'
	print '=========================================================================='

	PRINT '>> Truncating table :bronze.crm_cust_info'
	Truncate table bronze.crm_cust_info;

	print '>>Loading data into bronze.crm_cust_info'
	BULK INSERT bronze.crm_cust_info 
	from 'C:\Users\nidhi\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	with (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	print '>>Load Duration:' +CAST(DATEDIFF(second,@Start_time, @end_time) AS NVARCHAR) + 'Seconds';
	print '>> -----------------------------------------------';

	print '>>Loading no of rows in bronze.crm_cust_info'
	select * from bronze.crm_cust_info;
	SELECT COUNT(*) from bronze.crm_cust_info;

	-- bulk load data of prd_info 
	print '>> Truncating the table bronze.crm_prd_info'
	Truncate table bronze.crm_prd_info;

	print'>> Loading the data in table bronze.crm_prd_info'
	BULK INSERT bronze.crm_prd_info 
	from 'C:\Users\nidhi\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	with (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	print '>>Loading the no of rows in the table bronze.crm_prd_info'
	select * from bronze.crm_prd_info;
	SELECT COUNT(*) from bronze.crm_prd_info;

	-- bulk load the data of sales_details
	print '>> Truncating the table bronze.crm_sales_details'
	Truncate table bronze.crm_sales_details;

    print '>> Loading data into bronze.crm_sales_details'
	BULK INSERT bronze.crm_sales_details 
	from 'C:\Users\nidhi\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	with (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	print '>> Loading the number of rows in the table into bronze.crm_sales_details'
	select * from bronze.crm_sales_details;
	SELECT COUNT(*) from bronze.crm_sales_details;

	-- bulk load the data of CUST_AZ12d
	print '=================================================================================================='
	print 'Loading Bronze Layer from ERP'
	print '=================================================================================================='
	print '>> Truncating the table bronze.erp_CUST_AZ12'
	Truncate table bronze.erp_CUST_AZ12;

	print '>>Loading the data in the table bronze.erp_CUST_AZ12'
	BULK INSERT bronze.erp_CUST_AZ12 
	from 'C:\Users\nidhi\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
	with (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	print '>>Loading number of rows in the table bronze.erp_CUST_AZ12'
	select * from bronze.erp_CUST_AZ12;
	SELECT COUNT(*) from bronze.erp_CUST_AZ12;

	-- bulk load the data of LOC_A101
	print '>>Truncating the table bronze.erp_LOC_A101';
	Truncate table bronze.erp_LOC_A101;

	print '>>Loading the data in table bronze.erp_LOC_A101';
	BULK INSERT bronze.erp_LOC_A101 
	from 'C:\Users\nidhi\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
	with (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	print '>>Loading number of rows in the table bronze.erp_LOC_A101';
	select * from bronze.erp_LOC_A101;
	SELECT COUNT(*) from bronze.erp_LOC_A101;

	-- bulk load of data from PX_CAT_G1V2;
	print '>> Truncating the table bronze.erp_PX_CAT_G1V2'
	Truncate table bronze.erp_PX_CAT_G1V2;

	print '>> Loading data in table bronze.erp_PX_CAT_G1V2'
	BULK INSERT bronze.erp_PX_CAT_G1V2 
	from 'C:\Users\nidhi\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
	with (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	print '>> Loading the number of rows in the table bronze.erp_PX_CAT_G1V2'
	select * from bronze.erp_PX_CAT_G1V2;


EXEC bronze.load_bronze;
