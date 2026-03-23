SELECT *
FROM dbo.coffee
LIMIT 3;

--Check datatypes
DESCRIBE `workspace`.`dbo`.`coffee`;

--Check price range
SELECT MAX(unit_price)
FROM dbo.coffee;

SELECT MIN(unit_price)
FROM dbo.coffee;

--get the total sales for the whole perios jan-June
select SUM(unit_price*transaction_qty)
FROM dbo.coffee;

--Check quantity range
SELECT MAX(transaction_qty)
FROM dbo.coffee;

SELECT MIN(transaction_qty)
FROM dbo.coffee;

--Check transaction date range
SELECT
    MIN(TO_DATE(transaction_date, 'yyyy/MM/dd')) AS first_transaction_date,
    MAX(TO_DATE(transaction_date, 'yyyy/MM/dd')) AS last_transaction_date
FROM `workspace`.`dbo`.`coffee`;

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

-- 3. Check for duplicate transcations
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

SELECT COUNT (DISTINCT product_type) AS product_type
FROM dbo.coffee;

--Get the different product details
SELECT DISTINCT product_type
FROM dbo.coffee;


--Conclusion- All categorical colummns are standardised. 

--Next Step: Convert the date and group the time 

-- Convert transaction_date from raw text to a readable date format dd MMMM yyyy
SELECT
    transaction_date,
    DATE_FORMAT(TO_DATE(transaction_date, 'yyyy/MM/dd'), 'dd MMMM yyyy') AS transaction_date_formatted
FROM `workspace`.`dbo`.`coffee`
LIMIT 10;

--Convert transaction_time to 12-hour format with AM/PM.
SELECT
    transaction_time,
DATE_FORMAT(TO_TIMESTAMP(transaction_time, 'HH:mm:ss'), 'hh:mm:ss a')   AS transaction_time
FROM `workspace`.`dbo`.`coffee`
LIMIT 10;

--Create time_of_day buckets
SELECT
CASE
        WHEN HOUR(TO_TIMESTAMP(transaction_time, 'HH:mm:ss')) BETWEEN 6  AND 11 THEN 'Morning'
        WHEN HOUR(TO_TIMESTAMP(transaction_time, 'HH:mm:ss')) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(TO_TIMESTAMP(transaction_time, 'HH:mm:ss')) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END   AS time_of_day
FROM `workspace`.`dbo`.`coffee`;

--Transformation: Create new columns that will assist us in our analysis, the store opens at 6am and closes at 9pm
SELECT
    transaction_id,
    DATE_FORMAT(TO_DATE(transaction_date, 'yyyy/MM/dd'), 'dd MMMM yyyy')    AS transaction_date,
    DATE_FORMAT(TO_TIMESTAMP(transaction_time, 'HH:mm:ss'), 'hh:mm:ss a')   AS transaction_time,
    transaction_qty,
    store_id,
    store_location,
    product_id,
    unit_price,
    product_category,
    product_type,
    product_detail,
    ROUND(unit_price * transaction_qty, 2)                                   AS total_sales,
    MONTH(TO_DATE(transaction_date, 'yyyy/MM/dd'))                           AS month,
    DATE_FORMAT(TO_DATE(transaction_date, 'yyyy/MM/dd'), 'MMM')              AS month_name,
    DATE_FORMAT(TO_DATE(transaction_date, 'yyyy/MM/dd'), 'EEEE')             AS day_of_week,
    CASE
        WHEN HOUR(TO_TIMESTAMP(transaction_time, 'HH:mm:ss')) BETWEEN 6  AND 11 THEN 'Morning'
        WHEN HOUR(TO_TIMESTAMP(transaction_time, 'HH:mm:ss')) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(TO_TIMESTAMP(transaction_time, 'HH:mm:ss')) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END   AS time_of_day
FROM `workspace`.`dbo`.`coffee`;
