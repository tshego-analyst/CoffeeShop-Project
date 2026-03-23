SELECT *
FROM dbo.coffee
LIMIT 3;

--Check datatypes
DESCRIBE `workspace`.`dbo`.`coffee`;
--============================CLEANING THE DATA================================

--1. Check total rows
SELECT COUNT(*) AS total_rows
FROM dbo.coffee;

/*
2.
check for nulls in every column:
Go to every row in a column and look for the nulls in the row, 
ask, is this NULL(Empty)? if yes, then 1 if no then 0, 
close the case statement and then add all the 1s from ech row, 
after that display the rum in a new column 
*/
SELECT
SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_transaction_id,
SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) AS null_date, 
SUM(CASE WHEN transaction_qty IS NULL THEN 1 ELSE 0 END) AS null_gty,
SUM(CASE WHEN store_id IS NULL THEN 1 ELSE 0 END) AS null_storeID,
SUM(CASE WHEN store_location IS NULL THEN 1 ELSE 0 END) AS nul_storeLOcation,
SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_prod_id,
SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS null_unit_price, 
SUM(CASE WHEN product_category IS NULL THEN 1 ELSE 0 END) AS null_protCt,
SUM(CASE WHEN product_type IS NULL THEN 1 ELSE 0 END) AS null_prodtype, 
SUM(CASE WHEN product_detail IS NULL THEN 1 else 0 END) AS prod_details
FROM dbo.coffee;
--conclusion-there are no null values

-- 3. Check for duplicates
SELECT transaction_id, count(*) as numofDuplicatse
FROM dbo.coffee
GROUP BY transaction_id
HAVING count(*)> 0;
--conclusion-there are no duplicate values

--4. Standardise Categorical columns

--GET the number of stores
SELECT COUNT (DISTINCT store_location) AS Store_Location
FROM dbo.coffee;

--Get the different store locations
SELECT DISTINCT store_location 
FROM dbo.coffee;

--Get the number of prodcuct category
SELECT COUNT (DISTINCT product_category) AS product_category
FROM dbo.coffee;

--Get the different Categories
SELECT DISTINCT product_category
FROM dbo.coffee;

--Get the number of prodcuct details
SELECT COUNT (DISTINCT product_detail) AS product_detail
FROM dbo.coffee;

--Get the different product details
SELECT DISTINCT product_detail
FROM dbo.coffee;

--Conclusion- All categorical colummns are standardised. 
