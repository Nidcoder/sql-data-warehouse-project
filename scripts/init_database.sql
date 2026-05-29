/*
================================================================================================================
Create database and schemas
================================================================================================================
Script Purpose:
	This script creates  a new databse named 'DataWarehouse' after checking if it already exists.
	If the database exists, it is dropped first and then recreated. Additionally, the scripts sets up three
	schemas within the database: 'bronze','silver','gold'.

WARNING:
	running this script will drop the entire 'Datawarehouse' database if it exists.
	All data in this database will be permanently deleted.Proceed with caution
	and ensure you have proper backups before running this script.
=================================================================================================================
*/


-- Create database 'DataWarehouse'

use master;
Go

-- Drop and recreate the 'DataWarehouse' Database
If exists (select 1 from sys.databases where name = 'DataWarehouse')
BEGIN 
	ALTER DATABASE DataWarehouse Set Single_user With Rollback Immediate;
	Drop Database DataWarehouse;
End;
Go

-- Create the 'Datawarehouse' database

create database DataWarehouse;
Go

use DataWarehouse;
Go

-- CREATE BRONZE SCHEMA
create schema bronze;
Go

-- CREATE SILVER SCHEMA
create schema silver;
Go

-- CREATE GOLD SCHEMA
create schema gold;
Go
