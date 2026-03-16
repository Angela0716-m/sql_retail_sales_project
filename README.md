Ad-Hoc Retail Sales Analysis (SQL)
Author: Angela Mokhele
Tools: PostgreSQL • pgAdmin 4 • SQL
Project Type: Business-Focused Ad-Hoc Data Analysis
Project Summary
This project demonstrates SQL-based ad-hoc business analysis using transactional retail data.
Key project metrics:
Dataset size: 10,000+ transactions
Customers analyzed: 2,000+
SQL queries written: 10+ analytical queries
Insights generated: Revenue, customer behavior, and operational trends
The goal of this project is to simulate real business questions stakeholders ask analysts and demonstrate how SQL can transform raw data into actionable insights for decision-making.
Business Context
Retail organizations rely heavily on data to understand:
Which products generate the most revenue
Which customers are the most valuable
When demand peaks occur
How to improve operational efficiency
This project answers those questions through ad-hoc SQL analysis, replicating tasks commonly performed by data analysts in retail organizations.
Business Questions
The analysis focuses on answering several practical retail questions:
• Which product categories generate the most revenue?
• What days and times drive the highest sales?
• Which customer segments spend the most?
• Which categories have the strongest repeat purchases?
• Who are the highest-value customers?
Dataset Description
Each row in the dataset represents one retail transaction.
The dataset includes:
Customer demographic information
Product category data
Transaction timestamps
Sales and cost metrics
This structure allows analysis of revenue trends, customer behavior, and purchasing patterns.
Data Model
The dataset represents transactional retail sales data where each record corresponds to a single customer purchase.
Table: retail_sales
Column	Description
transaction_id	Unique transaction identifier
sale_date	Date of transaction
sale_time	Time of transaction
customer_id	Unique customer identifier
gender	Customer gender
age	Customer age
category	Product category
quantity	Units purchased
price_per_unit	Price per item
cogs	Cost of goods sold
total_sale	Total transaction revenue
Schema structure:
retail_sales
-----------------------------------------
transaction_id   (Primary Key)
sale_date
sale_time
customer_id
gender
age
category
quantity
price_per_unit
cogs
total_sale
Database Setup
Create Database
CREATE DATABASE retail_project;
Create Table
CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
Data Cleaning & Validation
Before performing analysis, the dataset was validated to ensure accuracy.
Total Records
SELECT COUNT(*) AS total_records
FROM retail_sales;
Unique Customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;
Check for Missing Values
SELECT *
FROM retail_sales
WHERE sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL;
Remove Incomplete Records
DELETE FROM retail_sales
WHERE sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL;
Business Analysis & SQL Queries
1. Highest Revenue per Category
SELECT 
    category,
    ROUND(AVG(total_sale)::numeric, 2) AS avg_revenue_per_transaction
FROM retail_sales
GROUP BY category
ORDER BY avg_revenue_per_transaction DESC;
2. Best Day of the Week for Sales
SELECT 
    TRIM(TO_CHAR(sale_date, 'Day')) AS day_of_week,
    ROUND(AVG(total_sale)::numeric, 2) AS avg_sales
FROM retail_sales
GROUP BY day_of_week
ORDER BY avg_sales DESC;
3. Highest Spending Age Group
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
4. Categories with Most Repeat Customers
SELECT 
    category,
    COUNT(*) FILTER (WHERE purchase_count > 1) AS repeat_customers
FROM (
    SELECT category, customer_id, COUNT(*) AS purchase_count
    FROM retail_sales
    GROUP BY category, customer_id
) AS subquery
GROUP BY category
ORDER BY repeat_customers DESC;
5. Revenue by Time of Day
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
6. Top 1% Customers by Revenue
WITH customer_sales AS (
    SELECT customer_id, SUM(total_sale) AS total_sales
    FROM retail_sales
    GROUP BY customer_id
),

sales_percentile AS (
    SELECT PERCENTILE_CONT(0.99)
           WITHIN GROUP (ORDER BY total_sales) AS threshold
    FROM customer_sales
)

SELECT cs.customer_id, cs.total_sales
FROM customer_sales cs, sales_percentile sp
WHERE cs.total_sales >= sp.threshold
ORDER BY cs.total_sales DESC;
7. Revenue per Unit
SELECT 
    SUM(quantity) AS total_units_sold,
    SUM(total_sale) AS total_revenue,
    ROUND((SUM(total_sale) / SUM(quantity))::numeric, 2) AS revenue_per_unit
FROM retail_sales;
8. Monthly Revenue Trends
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY year, month
ORDER BY total_revenue DESC;
9. Customer Retention Rate
SELECT 
    COUNT(*) FILTER (WHERE purchase_count > 1) * 100.0 / COUNT(*) 
    AS retention_rate_percentage
FROM (
    SELECT customer_id, COUNT(*) AS purchase_count
    FROM retail_sales
    GROUP BY customer_id
) subquery;
10. Revenue per Customer by Gender
SELECT 
    gender,
    ROUND(SUM(total_sale) / COUNT(DISTINCT customer_id), 2) 
        AS revenue_per_customer
FROM retail_sales
GROUP BY gender
ORDER BY revenue_per_customer DESC;
Key Insights
Key insights from the analysis include:
• Evening shifts generate the highest revenue (~42%)
• Customers aged 26–35 spend the most per transaction
• The top 1% of customers contribute approximately 18% of total revenue
• Beauty and Electronics categories show the strongest repeat purchasing behavior
• Sales peak in November, indicating seasonal demand
Business Recommendations
Based on the findings, several strategies could improve retail performance.
Staffing Optimization
Evening shifts generate the highest revenue. Increasing staffing levels during peak evening hours could improve customer service and sales capacity.
Targeted Marketing
Customers aged 26–35 represent the highest spending demographic. Marketing campaigns and loyalty programs could focus on this segment.
Customer Retention Programs
The top 1% of customers generate a significant portion of revenue. Retailers could introduce VIP loyalty programs to retain high-value customers.
Seasonal Inventory Planning
Sales peak in November, suggesting seasonal demand. Retailers should increase inventory and promotional activity ahead of this period.
Dashboard (Optional Extension)
To complement the SQL analysis, a visual dashboard can be created to help stakeholders explore the insights interactively.
Example dashboard visuals:
Revenue by product category
Sales by time of day
Customer spending by age group
Monthly revenue trends
Visualization tools that could be used:
Power BI • Tableau • Excel
Skills Demonstrated
SQL & Databases
PostgreSQL
Data cleaning and validation
CTEs and subqueries
Window functions and percentiles
Business Analytics
Revenue analysis
Customer segmentation
Retention metrics
Time-based sales analysis
Conclusion
This project demonstrates how SQL can transform raw transactional retail data into actionable business insights.
Through structured ad-hoc queries and segmentation analysis, the project identifies revenue drivers, high-value customers, and operational trends that could support better decision-making in retail organizations.
Portfolio
More projects available in my portfolio.
Angela Mokhele
Data Analyst | SQL • Python • Power BI • Machine Learning
