-- create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
				(
				transactions_id INT Primary key, 
				sale_date DATE, 
				sale_time TIME, 
				customer_id INT, 
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),	
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
				);
-- DATA CLEANING
-- check contents in tables
select * from retail_sales
LIMIT 10 ;

-- count the number of rows/records
SELECT 
	COUNT(*)
FROM retail_sales;

-- checking for null in transcation 
select * from retail_sales
WHERE transactions_id IS NULL


-- checking for null  in sales_data 
select * from retail_sales
WHERE sale_date IS NULL

-- checking for null in all column at the same time, if its only one column with missing value in a row before dropping it check if aybe it was not left of purpose
select * from retail_sales
WHERE transactions_id IS NULL
OR
sale_date IS NULL
OR 
sale_time IS NULL
or 
customer_id IS NULL
or 
gender IS NULL
or 
category IS NULL
or 
quantiy IS NULL
or
price_per_unit IS NULL
or 
cogs IS NULL
or 
total_sale IS NULL; 

-- delete nulls
DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR
sale_date IS NULL
OR 
sale_time IS NULL
or 
customer_id IS NULL
or 
gender IS NULL
or 
category IS NULL
or 
quantiy IS NULL
or
price_per_unit IS NULL
or 
cogs IS NULL
or 
total_sale IS NULL; 


--- CHECK FOR THE COUNT OF RECORD / ROWS AFTER DELETIN NULLS
SELECT 
	COUNT(*)
FROM retail_sales;



---DATA EXPLORATION 

-- HOW MANY SALES DO WE HAVE 
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- how many customers do we have ( this approuch would work but what if customers id is being repited)
SELECT COUNT(*) AS customer_id FROM retail_sales

--how many unique customers do we have
SELECT COUNT(DISTINCT customer_id) as total_customers From retail_sales

-- how many unique catogories do we have
SELECT COUNT(DISTINCT category) as total_categories From retail_sales

-- the names of the 3 categories 
SELECT DISTINCT category as total_categories From retail_sales


select * from retail_sales



-- data analysis & solving business problems
--Business Goals:

--1. Which product category generates the highest revenue per transaction?
SELECT 
    category,
    ROUND(AVG(total_sale)::numeric, 2) AS avg_revenue_per_transaction
FROM retail_sales
GROUP BY category
ORDER BY avg_revenue_per_transaction DESC;

--2 Which day of the week has the highest average sales?
SELECT 
---- TRIM(TO_CHAR(sale_date, 'Day')) AS day_of_week: Converts sale_date to full day name (e.g., "Monday"), trims extra spaces, and labels it.
    TRIM(TO_CHAR(sale_date, 'Day')) AS day_of_week,
    ROUND(AVG(total_sale)::numeric, 2) AS avg_sales
FROM retail_sales
GROUP BY day_of_week
ORDER BY avg_sales DESC;


--Which age group spends the most on average?
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '50+'
    END AS age_group,
    ROUND(AVG(total_sale)::numeric, 2) AS avg_spend
FROM retail_sales
GROUP BY age_group
ORDER BY avg_spend DESC;

--who is the customer id with the most purcheses 
SELECT 
        category, 
        customer_id, 
        COUNT(*) AS purchase_count
    FROM retail_sales
    GROUP BY category, customer_id
	ORDER BY purchase_count DESC;




--Which category has the highest repeat customers?
SELECT 
    category,
    COUNT(*) FILTER (WHERE purchase_count > 1) AS repeat_customers
FROM (
    SELECT 
        category, 
        customer_id, 
        COUNT(*) AS purchase_count
    FROM retail_sales
    GROUP BY category, customer_id
) AS subquery
GROUP BY category
ORDER BY repeat_customers DESC;

--Which time of day generates the highest revenue?
-- Build a temporary table
WITH hourly_sales AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    SUM(total_sale) AS total_revenue
FROM hourly_sales
GROUP BY shift
ORDER BY total_revenue DESC;

--Which customers are most valuable (Top 1% by sales)
WITH customer_sales AS (
    SELECT 
        customer_id,
        SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY customer_id
),
sales_percentile AS (
    SELECT 
        PERCENTILE_CONT(0.99) 
        WITHIN GROUP (ORDER BY total_sales) AS threshold
    FROM customer_sales
)
SELECT 
    cs.customer_id,
    cs.total_sales
FROM customer_sales cs, sales_percentile sp
WHERE cs.total_sales >= sp.threshold
ORDER BY cs.total_sales DESC;

--What is the overall conversion of quantity to revenue?
SELECT 
    SUM(quantiy) AS total_units_sold,
    SUM(total_sale) AS total_revenue,
    ROUND(
        (SUM(total_sale) / SUM(quantiy))::numeric, 
        2
    ) AS revenue_per_unit
FROM retail_sales;

--Which month generates the highest total revenue?
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY year, month
ORDER BY total_revenue DESC;

--What is the customer retention rate?
SELECT 
    COUNT(*) FILTER (WHERE purchase_count > 1) * 100.0 / COUNT(*) AS retention_rate_percentage
FROM (
    SELECT customer_id, COUNT(*) AS purchase_count
    FROM retail_sales
    GROUP BY customer_id
) subquery;

--Which gender generates higher revenue per customer?
SELECT 
    gender,
    ROUND((SUM(total_sale) / COUNT(DISTINCT customer_id))::numeric, 2) AS revenue_per_customer
FROM retail_sales
GROUP BY gender
ORDER BY revenue_per_customer DESC;


