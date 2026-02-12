<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Retail Sales Analysis - SQL Project</title>
    <style>
        body { font-family: Arial, sans-serif; line-height: 1.6; margin: 20px; }
        h1, h2, h3, h4 { color: #2c3e50; }
        pre { background-color: #f4f4f4; padding: 10px; border-radius: 5px; overflow-x: auto; }
        code { font-family: Consolas, monospace; color: #e74c3c; }
        ul { margin-left: 20px; }
        .query { margin-bottom: 20px; }
        .insight { background-color: #ecf0f1; padding: 10px; border-left: 4px solid #3498db; margin-bottom: 10px; }
    </style>
</head>
<body>

<h1>Retail Sales Analysis – SQL Project</h1>

<p><strong>Author:</strong> Angela Mokhele</p>
<p><strong>Database:</strong> <code>retail_project</code></p>
<p><strong>Tool:</strong> pgAdmin 4</p>
<p><strong>Project Type:</strong> Business-Focused Data Analysis</p>

<hr>

<h2> Project Overview</h2>
<p>This project analyzes retail sales data using PostgreSQL to uncover insights related to:</p>
<ul>
    <li>Revenue performance</li>
    <li>Customer purchasing behavior</li>
    <li>Product category trends</li>
    <li>Seasonal sales patterns</li>
    <li>Operational efficiency</li>
</ul>
<p>All analysis is structured around real business questions that retail stakeholders would ask to drive data-informed decisions.</p>

<hr>

<h2> Business Objectives</h2>
<ul>
    <li><strong>Revenue Performance:</strong> Identify which products and periods drive revenue.</li>
    <li><strong>Customer Behavior:</strong> Determine who the most valuable customers are.</li>
    <li><strong>Product Insights:</strong> Discover top-performing categories.</li>
    <li><strong>Time-Based Trends:</strong> Identify peak days and shifts for sales.</li>
    <li><strong>Operational Optimization:</strong> Inform staffing and marketing strategies.</li>
</ul>

<hr>

<h2> Database Setup</h2>

<h3>1. Create Database</h3>
<pre><code>CREATE DATABASE retail_project;</code></pre>

<h3>2. Create Table</h3>
<pre><code>CREATE TABLE retail_sales (
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
);</code></pre>

<hr>

<h2> Data Cleaning & Validation</h2>
<ul>
    <li>Check total records and unique customers</li>
    <li>Identify null or missing values</li>
    <li>Delete incomplete records for analysis accuracy</li>
</ul>

<pre><code>-- Total Records
SELECT COUNT(*) AS total_records FROM retail_sales;

-- Unique Customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

-- Check for NULLs
SELECT * FROM retail_sales
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL 
   OR gender IS NULL OR age IS NULL OR category IS NULL 
   OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Delete NULL records
DELETE FROM retail_sales
WHERE sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL 
   OR gender IS NULL OR age IS NULL OR category IS NULL 
   OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;</code></pre>

<hr>

<h2> Business Analysis & SQL Queries</h2>

<div class="query">
<h3>1️ Highest Revenue per Category</h3>
<p><strong>Goal:</strong> Identify high-value categories to prioritize inventory and marketing.</p>
<pre><code>SELECT 
    category,
    ROUND(AVG(total_sale)::numeric, 2) AS avg_revenue_per_transaction
FROM retail_sales
GROUP BY category
ORDER BY avg_revenue_per_transaction DESC;</code></pre>
</div>

<div class="query">
<h3>2️ Best Day of the Week</h3>
<p><strong>Goal:</strong> Understand weekly demand for staffing and promotions.</p>
<pre><code>SELECT 
    TRIM(TO_CHAR(sale_date, 'Day')) AS day_of_week,
    ROUND(AVG(total_sale)::numeric, 2) AS avg_sales
FROM retail_sales
GROUP BY day_of_week
ORDER BY avg_sales DESC;</code></pre>
</div>

<div class="query">
<h3>3️ Highest Spending Age Group</h3>
<p><strong>Goal:</strong> Segment customers for targeted marketing and retention.</p>
<pre><code>SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '50+'
    END AS age_group,
    ROUND(AVG(total_sale)::numeric, 2) AS avg_spend
FROM retail_sales
GROUP BY age_group
ORDER BY avg_spend DESC;</code></pre>
</div>

<div class="query">
<h3>4️ Categories with Most Repeat Customers</h3>
<p><strong>Goal:</strong> Identify loyalty strength by category.</p>
<pre><code>SELECT 
    category,
    COUNT(*) FILTER (WHERE purchase_count > 1) AS repeat_customers
FROM (
    SELECT category, customer_id, COUNT(*) AS purchase_count
    FROM retail_sales
    GROUP BY category, customer_id
) AS subquery
GROUP BY category
ORDER BY repeat_customers DESC;</code></pre>
</div>

<div class="query">
<h3>5️ Revenue by Time of Day</h3>
<p><strong>Goal:</strong> Optimize staffing and marketing timing.</p>
<pre><code>WITH hourly_sales AS (
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
ORDER BY total_revenue DESC;</code></pre>
</div>

<div class="query">
<h3>6️ Top 1% Customers by Revenue</h3>
<pre><code>WITH customer_sales AS (
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
ORDER BY cs.total_sales DESC;</code></pre>
</div>

<div class="query">
<h3>7️ Revenue per Unit</h3>
<pre><code>SELECT 
    SUM(quantity) AS total_units_sold,
    SUM(total_sale) AS total_revenue,
    ROUND((SUM(total_sale) / SUM(quantity))::numeric, 2) AS revenue_per_unit
FROM retail_sales;</code></pre>
</div>

<div class="query">
<h3>8️ Month with Highest Revenue</h3>
<pre><code>SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY year, month
ORDER BY total_revenue DESC;</code></pre>
</div>

<div class="query">
<h3>9️ Customer Retention Rate</h3>
<pre><code>SELECT 
    COUNT(*) FILTER (WHERE purchase_count > 1) * 100.0 / COUNT(*) AS retention_rate_percentage
FROM (
    SELECT customer_id, COUNT(*) AS purchase_count
    FROM retail_sales
    GROUP BY customer_id
) subquery;</code></pre>
</div>

<div class="query">
<h3>10 Revenue by Gender per Customer</h3>
<pre><code>SELECT 
    gender,
    ROUND(SUM(total_sale) / COUNT(DISTINCT customer_id), 2) AS revenue_per_customer
FROM retail_sales
GROUP BY gender
ORDER BY revenue_per_customer DESC;</code></pre>
</div>

<hr>

<h2> Key Findings</h2>
<div class="insight">Evening shift generates the highest revenue (42% of total sales).</div>
<div class="insight">Customers aged 26–35 spend the most per transaction on average.</div>
<div class="insight">Top 1% of customers contribute 18% of total revenue.</div>
<div class="insight">Beauty and Electronics categories have the highest repeat customers.</div>
<div class="insight">Monthly revenue peaks in November, indicating a seasonal trend.</div>

<hr>

<h2> Skills Demonstrated</h2>
<ul>
    <li>PostgreSQL & pgAdmin 4</li>
    <li>Data Cleaning & Validation</li>
    <li>CTEs & Subqueries</li>
    <li>Window Functions & Percentiles</li>
    <li>Customer Segmentation & Retention Analysis</li>
    <li>Time-Based Sales Analysis</li>
    <li>Revenue & Product Performance Analytics</li>
</ul>

<hr>

<h2> Conclusion</h2>
<p>This project demonstrates how SQL can transform raw transactional data into actionable business insights. Through structured queries, segmentation, and time-based analysis, it provides a clear view of revenue drivers, high-value customers, and operational efficiency. The results can inform marketing, inventory, and staffing decisions.</p>

</body>
</html>




   
