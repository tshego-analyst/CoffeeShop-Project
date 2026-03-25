SELECT *
FROM workspace.dbo.coffee
LIMIT 3;

--Check datatypes
DESCRIBE `workspace`.`dbo`.`coffee`;

--Check price range
SELECT MAX(unit_price)
FROM workspace.dbo.coffee;

SELECT MIN(unit_price)
FROM workspace.dbo.coffee;

--get the total sales for the whole perios jan-June
select SUM(unit_price*transaction_qty)
FROM workspace.dbo.coffee;

--Check quantity range
SELECT MAX(transaction_qty)
FROM workspace.dbo.coffee;

SELECT MIN(transaction_qty)
FROM workspace.dbo.coffee;

--Check transaction date range
SELECT
    MIN(TO_DATE(transaction_date, 'yyyy/MM/dd')) AS first_transaction_date,
    MAX(TO_DATE(transaction_date, 'yyyy/MM/dd')) AS last_transaction_date
FROM `workspace`.`dbo`.`coffee`;

--============================CLEANING THE DATA================================

--1. Check total rows
SELECT COUNT(*) AS total_rows
FROM workspace.dbo.coffee;

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
FROM workspace.dbo.coffee;
--conclusion-there are no null values

-- 3. Check for duplicate transcations
SELECT transaction_id, count(*) as numofDuplicatse
FROM workspace.dbo.coffee
GROUP BY transaction_id
HAVING count(*)> 0;
--conclusion-there are no duplicate values

--4. Standardise Categorical columns

--GET the number of stores
SELECT COUNT (DISTINCT store_location) AS Store_Location
FROM workspace.dbo.coffee;

--Get the different store locations
SELECT DISTINCT store_location 
FROM workspace.dbo.coffee;

--Get the number of prodcuct category
SELECT COUNT (DISTINCT product_category) AS product_category
FROM workspace.dbo.coffee;

--Get the different Categories
SELECT DISTINCT product_category
FROM workspace.dbo.coffee;

--Get the number of prodcuct details
SELECT COUNT (DISTINCT product_detail) AS product_detail
FROM workspace.dbo.coffee;

--Get the different product details
SELECT DISTINCT product_detail
FROM workspace.dbo.coffee;

SELECT COUNT (DISTINCT product_type) AS product_type
FROM workspace.dbo.coffee;

--Get the different product details
SELECT DISTINCT product_type
FROM workspace.dbo.coffee;


--============================================================Conclusion- All categorical colummns are standardised.===============================================================================

--Next Step: Transform/summarise the data

SELECT *
FROM workspace.dbo.coffee
LIMIT 3;

--Which product makes the most revenue
SELECT 
    product_detail,
    ROUND(SUM(transaction_qty * unit_price), 2) AS product_Revenue
FROM workspace.dbo.coffee
GROUP BY product_detail
ORDER BY product_Revenue DESC;

/*
What time of day is busiest?Peak hours analysis Column to use: transaction_time + transaction_qty
For this one we need to extract the hour from transaction_time and then label it as:
 Morning / Afternoon / Evening using CASE

*/

SELECT 
    --dayname(transaction_date) AS day_of_The_Week,
    HOUR(transaction_time) AS hour_of_day,
CASE 
    WHEN  hour_of_day  BETWEEN 6 AND 11 THEN 'MORNING'
    WHEN  hour_of_day BETWEEN 12 AND 16 THEN 'AFTERNOON'
    WHEN  hour_of_day BETWEEN 17 AND 20 THEN 'EVENING'
    ELSE 'off_peak'
    END AS time_of_day,
SUM(transaction_qty) as total_items_sold
FROM workspace.dbo.coffee
GROUP BY 
  hour_of_day,
 --dayname(transaction_date),
    CASE
        WHEN HOUR(transaction_time) BETWEEN 6  AND 11 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(transaction_time) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Off Peak'
    END
    ORDER BY total_items_sold DESC;

    --Which store performs best?
  SELECT 
  store_location, 
    ROUND(SUM(transaction_qty* unit_price), 2) as total_revenue_by_store,
    SUM(transaction_qty) as total_items_sold,
    COUNT(DISTINCT transaction_id) AS total_transaction_per_store
  FROM workspace.dbo.coffee
  GROUP BY store_location
  ORDER BY total_revenue_by_store DESC;


/*
How are sales trending over time? Monthly/weekly trends(which month perfroms best)
*/

SELECT 
    MONTHNAME(transaction_date) AS Month_name, 
    MONTH(transaction_date) AS month_number,
    ROUND(SUM(transaction_qty* unit_price), 2) AS total_revenue_per_Month
FROM workspace.dbo.coffee
GROUP BY Month_name, month_number
ORDER BY total_revenue_per_Month DESC;


--Which category earns the most? (Revenue by category)

SELECT 
    product_category, 
    ROUND(SUM(transaction_qty * unit_price), 2) total_revenue_By_Cat, 
    SUM(transaction_qty) AS Items_sold_in_Cat,
    COUNT(DISTINCT transaction_id) AS num_of_transaction_forThisCat
FROM workspace.dbo.coffee
GROUP BY product_category
ORDER BY total_revenue_By_Cat DESC;

-- What days sell the most? (Day of week patterns)
SELECT 
    dayname(transaction_date) AS day_name,
    dayofweek(transaction_date) AS day_number,
    ROUND(SUM(transaction_qty * unit_price), 2) AS revenue_per_Day,
    COUNT(transaction_id) AS total_transactions,
    SUM(transaction_qty)  AS total_units_sold
FROM workspace.dbo.coffee
GROUP BY day_name, day_number
ORDER BY revenue_per_Day DESC;


--What is the average order value? (Spend per transaction)
SELECT 
COUNT(transaction_id) as total_transactions,
ROUND(SUM(transaction_qty * unit_price),2) AS total_revenue,
ROUND(SUM(transaction_qty * unit_price) / COUNT(transaction_id), 2) AS Average_spend
FROM workspace.dbo.coffee;

--  Which products sell most by volume? (Units sold ranking)
SELECT 
    product_detail,
    SUM(transaction_qty) as items_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS product_Revenue,  
    COUNT( DISTINCT transaction_ID) transaction_per_product_detail
FROM workspace.dbo.coffee
GROUP BY product_detail
ORDER BY items_sold DESC
LIMIT 10;



--I want to calssify the spend range, howeverm I frist need to explore my data before I make a decision

--  What is the spend range per transaction?
SELECT 
    MIN(transaction_qty * unit_price) AS min_spend,
    MAX(transaction_qty * unit_price) AS max_spend,
    AVG(transaction_qty * unit_price) AS avg_spend
 FROM workspace.dbo.coffee;

--What is that $360 transaction?
SELECT 
    product_detail,
    product_category,
    transaction_qty,
    unit_price,
    (transaction_qty * unit_price) AS spend
FROM workspace.dbo.coffee
WHERE (transaction_qty * unit_price) = 360
LIMIT 5;

--What are the most expenstive transactioons and how often do they happen
SELECT 
    (transaction_qty * unit_price) AS spend,
    COUNT(transaction_id)  AS num_transactions
FROM workspace.dbo.coffee
GROUP BY spend
ORDER BY spend DESC
LIMIT 20;

--What are the cheapest transactions and how common are they?
SELECT 
    (transaction_qty * unit_price) AS spend,
    COUNT(transaction_id)  AS num_transactions
FROM workspace.dbo.coffee
GROUP BY spend
ORDER BY spend ASC
LIMIT 20;

/*
classify transactions as High or Low based on whether 
they were above or below the average spend of $4.69"
*/
SELECT 
(transaction_qty * unit_price) AS spend,
CASE
    WHEN (transaction_qty * unit_price) >= 20   THEN 'High Spender'
    WHEN (transaction_qty * unit_price) >= 4.69 THEN 'Mid Spender'
    ELSE                                             'Low Spender'
END AS spend_category
FROM workspace.dbo.coffee;

--Classify the days
SELECT 
dayname(transaction_date) AS day_name,
CASE
    WHEN day_name IN('Sun', 'Sat') THEN 'Weekend'
    ELSE   'Weekday'
END AS day_type
FROM workspace.dbo.coffee;

--========================================Summarise the data and create one table ==============================================

SELECT 

    -- === PRODUCT INFO ===
    product_detail,
    product_category,

    -- === DATE INFO ===
    transaction_date,
    MONTHNAME(transaction_date)             AS month_name,
    MONTH(transaction_date)                 AS month_number,
    DAYNAME(transaction_date)               AS day_name,
    DAYOFWEEK(transaction_date)             AS day_number,

    -- === TIME INFO ===
    HOUR(transaction_time)                  AS hour_of_day,
    CASE 
    WHEN  hour_of_day BETWEEN 6 AND 11 THEN 'MORNING'
    WHEN  hour_of_day BETWEEN 12 AND 16 THEN 'AFTERNOON'
    WHEN  hour_of_day BETWEEN 17 AND 20 THEN 'EVENING'
    ELSE 'off_peak'
    END AS time_of_day,

    CASE
    WHEN day_name IN('Sun', 'Sat') THEN 'Weekend'
    ELSE   'Weekday'
    END AS day_type,
   

    -- === STORE INFO ===
    store_location,

    -- === NUMBERS ===
    COUNT(transaction_id)                   AS total_transactions,
    SUM(transaction_qty)                    AS total_units_sold,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
    ROUND(SUM(transaction_qty * unit_price) / 
          COUNT(transaction_id), 2)         AS avg_order_value,

    -- === PERFORMANCE LABELS ===
    CASE
    WHEN (transaction_qty * unit_price) >= 20   THEN 'High Spender'
    WHEN (transaction_qty * unit_price) >= 4.69 THEN 'Mid Spender'
    ELSE     'Low Spender'
    END AS spend_category

FROM workspace.dbo.coffee
GROUP BY
    product_detail,
    product_category,
    transaction_date,
    MONTHNAME(transaction_date),
    MONTH(transaction_date),
    DAYNAME(transaction_date),
    CASE
    WHEN DAYNAME(transaction_date) IN('Sun', 'Sat') THEN 'Weekend'
    ELSE   'Weekday'
    END,
    DAYOFWEEK(transaction_date),
    HOUR(transaction_time),
    CASE
        WHEN HOUR(transaction_time) BETWEEN 6  AND 11 THEN 'Morning'
        WHEN HOUR(transaction_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(transaction_time) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Off Peak'
    END,
    CASE
    WHEN (transaction_qty * unit_price) >= 20   THEN 'High Spender'
    WHEN (transaction_qty * unit_price) >= 4.69 THEN 'Mid Spender'
    ELSE    'Low Spender'
    END,
    store_location
ORDER BY total_revenue DESC
LIMIT 200000;
