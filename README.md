# ☕Coffee Shop — Sales Analysis 

## Project Overview
An end-to-end data analysis project analysing 6 months of transactional sales data from Bright Coffee Shop, a chain with 3 branches. The goal is to uncover insights that can help improve sales performance across stores, products, and time periods.

## Business Questions
This analysis answers the following business questions:

| # | Question | Dimension |
|---|---|---|
| 1 | Which store generates the most revenue? | Where |
| 2 | Which product category earns the most? | What |
| 3 | Which products sell most by volume? | What |
| 4 | How are sales trending month by month? | When |
| 5 | Which days of the week are busiest? | When |
| 6 | What time of day has the most sales? | When |
| 7 | What is the total revenue across 6 months? | How Much |
| 8 | What is the average order value per store? | How Much |


## Dataset
- **Source:** Bright Coffee Shop Sales Dataset
- **Period:** January 2023 – June 2023
- **Stores:** Lower Manhattan · Hell's Kitchen · Astoria
- **Records:** 149,116 transactions
- **Columns:** 11 raw columns → 15 after transformation

  ### Raw Columns
| Column | Data Type | Description |
|---|---|---|
| transaction_id | bigint | Unique identifier per transaction (Primary Key) |
| transaction_date | DATE | Date of sale |
| transaction_time | Timestamp | Time of sale |
| transaction_qty | bigint | Number of units sold |
| store_id | bigint | Store identifier |
| store_location | string | Store branch name |
| product_id | bigint | Product identifier |
| unit_price | double | Price per unit |
| product_category | string | Broad product category |
| product_type | string | Specific product type |
| product_detail | string | Full product name and size |

## Tools Used

| Tool | Purpose |
|---|---|
| Microsoft Excel | Quick data validation checks |
| Miro | Project planning and brainstorming |
| Databricks (SQL) | Data cleaning and transformation |
| Canva | Project phase updates |
| Microsoft Excel | Data visualisation and dashboard |
| Canva| Project Presentation |

---


## Data Inspection Summary
Before cleaning, the following checks were performed:

| Check | Result |
|---|---|
| Total rows | 149,116 |
| Null values | 0 across all columns |
| Duplicate transaction IDs | 0 |
| Date range | 01 Jan 2023 – 30 Jun 2023 |
| Unit price range | $0.80 – $45.00 |
| Quantity range | 1 – 8 units |


## Data Transformation
The following transformations were applied in Databricks SQL:

1. Created `total_revenue`
2. Extracted `month` and `month_name`
3. Extracted `day_of_week`
4. Created `time_of_day` buckets
5. Extracted `day type
6. Extracted `Spending categories`

---

## Key Findings

| # | Question | Answer |
|---|---|---|
| 1 | Top revenue product | Sustainably Grown Organic Lg |
| 2 | Busiest time of day | 10am — Morning |
| 3 | Best performing store | Hell's Kitchen — R236,511 total revenue |
| 4 | Best revenue month | June — R166,485 |
| 5 | Top product category | Coffee — R269,952 |
| 6 | Busiest day of week | Monday — R101,677 |
| 7 | Average order value | R4.69 per transaction |
| 8 | Top product by volume | Earl Grey Rg — 4,708 units sold |

---

### Store Comparison

| Store | Revenue | Items Sold | Transactions |
|---|---|---|---|
| Hell's Kitchen | R236,511 | 71,737 | 50,735 |
| Astoria | R232,243 | 70,991 | 50,599 |
| Lower Manhattan | R230,057 | 71,742 | 47,782 |

> All 3 stores perform consistently. Lower Manhattan customers buy more items per visit but cheaper products, resulting in slightly lower revenue despite similar volume.

### Monthly Revenue Trend

| Month | Revenue |
|---|---|
| February | R76,145 |
| January | R81,677 |
| March | R98,834 |
| April | R118,941 |
| May | R156,727 |
| June | R166,485 |

> Revenue grew consistently every month, nearly doubling from February to June. April–June is the peak season.

---

## Overall Findings

Bright Coffee Shop generated R698,812 in total revenue across 149,116 transactions between January and June 2023, with an average order value of R4.69. Revenue grew consistently every month, nearly doubling from R76,145 in February to R166,485 in June, suggesting strong seasonal demand heading into summer.

Hell's Kitchen was the top performing store at R236,511 in revenue, leading consistently across all 6 months. Lower Manhattan presented the most interesting pattern, fewest customers walking in but the highest units sold per visit, indicating a loyal, high-frequency buying customer base.

Coffee dominated as the top revenue category at R269,952, accounting for 39% of total revenue, with Tea a distant second at R196,405. Coffee Beans emerged as a premium segment with the highest average order value at R22.63 per order, while Flavours raised a pricing concern, generating only R1.24 per item despite high sales volume.

Morning was the peak trading period across all stores, generating R388,288 more than the afternoon and evening combined. Monday and Friday were the strongest days while Saturday consistently underperformed, pointing to a predominantly weekday commuter customer base.

From a spend behaviour perspective, Mid Spenders drove the most revenue at R388,094 despite being outnumbered by Low Spenders who made up 60.8% of all transactions. High Spenders represented only 0.7% of customers but contributed R31,170, making them the most valuable segment per visit.

---

## Dashboard
Microsoft Excel dashboard completed with 5 analytical sheets and one summary dashboard covering store performance, category insights, time and day analysis, and spend category behaviour.

---

## Author
**Tshegofatso L. Senona**
Data Analyst | South Africa

---

## Status
🟡 Completed

