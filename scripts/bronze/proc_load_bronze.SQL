/* 
===========================================================================================================
 	I have created stored procedure to load data in bronze layer and also to calculate load duration 
    and also truncating table and also count the number of rows
	In this stored procedure i have loaded data from two different sources From 'CRM', 'ERP'.
===========================================================================================================
*/

-- Bulk insert the data in this sql file
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @Start_time DATETIME, @end_time DATETIME, @Batch_start_time DATETIME, @Batch_end_time DATETIME;
	
	BEGIN TRY
	SET @Batch_start_time = GETDATE();
	print '=========================================================================='
	print 'Loading Bronze CRM Layer'
	print '=========================================================================='

	SET @Start_time = GETDATE();
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
	SET @end_time = GETDATE();
	print '>>Load Duration:' +CAST(DATEDIFF(second,@Start_time, @end_time) AS NVARCHAR) + 'Seconds';
	print '>> -----------------------------------------------';

	print '>>Loading no of rows in bronze.crm_cust_info'
	select * from bronze.crm_cust_info;
	SELECT COUNT(*) from bronze.crm_cust_info;

	-- bulk load data of prd_info 
	SET @Start_time = GETDATE();
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
	SET @end_time = GETDATE();
	print '>>Load Duration:' +CAST(DATEDIFF(second,@Start_time, @end_time) AS NVARCHAR) + 'Seconds';
	print '>> -----------------------------------------------';

	print '>>Loading the no of rows in the table bronze.crm_prd_info'
	select * from bronze.crm_prd_info;
	SELECT COUNT(*) from bronze.crm_prd_info;

	-- bulk load the data of sales_details
	SET @Start_time = GETDATE();
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
	SET @end_time = GETDATE();
	print '>>Load Duration:' +CAST(DATEDIFF(second,@Start_time, @end_time) AS NVARCHAR) + 'Seconds';
	print '>> -----------------------------------------------';

	print '>> Loading the number of rows in the table into bronze.crm_sales_details'
	select * from bronze.crm_sales_details;
	SELECT COUNT(*) from bronze.crm_sales_details;

	-- bulk load the data of CUST_AZ12d
	print '=================================================================================================='
	print 'Loading Bronze Layer from ERP'
	print '=================================================================================================='
	SET @Start_time = GETDATE();
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
	SET @end_time = GETDATE();
	print '>>Load Duration:' +CAST(DATEDIFF(second,@Start_time, @end_time) AS NVARCHAR) + 'Seconds';
	print '>> -----------------------------------------------';

	print '>>Loading number of rows in the table bronze.erp_CUST_AZ12'
	select * from bronze.erp_CUST_AZ12;
	SELECT COUNT(*) from bronze.erp_CUST_AZ12;

	-- bulk load the data of LOC_A101
	SET @Start_time = GETDATE();
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
	SET @end_time = GETDATE();
	print '>>Load Duration:' +CAST(DATEDIFF(second,@Start_time, @end_time) AS NVARCHAR) + 'Seconds';
	print '>> -----------------------------------------------';

	print '>>Loading number of rows in the table bronze.erp_LOC_A101';
	select * from bronze.erp_LOC_A101;
	SELECT COUNT(*) from bronze.erp_LOC_A101;

	-- bulk load of data from PX_CAT_G1V2;
	SET @Start_time = GETDATE();
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
	SET @end_time = GETDATE();
	print '>>Load Duration:' +CAST(DATEDIFF(second,@Start_time, @end_time) AS NVARCHAR) + ' Seconds';
	print '>> -----------------------------------------------';

	print '>> Loading the number of rows in the table bronze.erp_PX_CAT_G1V2'
	select * from bronze.erp_PX_CAT_G1V2;

	SELECT COUNT(*) from bronze.erp_PX_CAT_G1V2;
	SET @Batch_end_time = GETDATE();
	print '--------------------------------------------------------------------------------------------'
	print 'Loading Bronze Layer is Completed'
	print '>>Load Duration:' +CAST(DATEDIFF(second, @Batch_start_time, @Batch_end_time) AS NVARCHAR) + ' Seconds';
	print '---------------------------------------------------------------------------------------------'
END TRY
BEGIN CATCH
	 PRINT '============================================';
	 PRINT 'error occured during loading bronze layer';
	 print 'Error Message' + Error_Message();
	 print 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
	 print 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
	 PRINT '============================================';
END CATCH
END
GO

EXEC bronze.load_bronze;
