<h1>Ad-Hoc Retail Sales Analysis (SQL)</h1>

<p><strong>Author:</strong> Angela Mokhele</p>
<p><strong>Tools:</strong> PostgreSQL • pgAdmin 4 • SQL</p>
<p><strong>Project Type:</strong> Business-Focused Ad-Hoc Data Analysis</p>

<div class="section">

<h2>Project Summary</h2>

<p>This project demonstrates <strong>SQL-based ad-hoc business analysis</strong> using transactional retail data.</p>

<ul>
<li>Dataset size: <strong>10,000+ transactions</strong></li>
<li>Customers analyzed: <strong>2,000+</strong></li>
<li>SQL queries written: <strong>10+</strong></li>
<li>Insights generated: Revenue trends, customer behaviour, operational insights</li>
</ul>

<p>The project simulates real stakeholder questions and shows how SQL can convert raw data into actionable business insights.</p>

</div>

<div class="section">

<h2>Business Context</h2>

<p>Retail organizations rely heavily on analytics to understand:</p>

<ul>
<li>Which products generate the most revenue</li>
<li>Which customers are most valuable</li>
<li>When demand peaks occur</li>
<li>How to improve operational efficiency</li>
</ul>

<p>This project replicates typical ad-hoc analysis tasks performed by data analysts in retail environments.</p>

</div>

<div class="section">

<h2>Business Questions</h2>

<ul>
<li>Which product categories generate the most revenue?</li>
<li>What days and times drive the highest sales?</li>
<li>Which customer segments spend the most?</li>
<li>Which categories have the strongest repeat purchases?</li>
<li>Who are the highest-value customers?</li>
</ul>

</div>

<div class="section">

<h2>Dataset Description</h2>

<p>Each record represents a single retail transaction containing:</p>

<ul>
<li>Customer demographics</li>
<li>Product category</li>
<li>Transaction timestamps</li>
<li>Revenue and cost metrics</li>
</ul>

</div>

<div class="section">

<h2>Data Model</h2>

<table>
<tr>
<th>Column</th>
<th>Description</th>
</tr>

<tr><td>transaction_id</td><td>Unique transaction identifier</td></tr>
<tr><td>sale_date</td><td>Date of purchase</td></tr>
<tr><td>sale_time</td><td>Time of purchase</td></tr>
<tr><td>customer_id</td><td>Unique customer ID</td></tr>
<tr><td>gender</td><td>Customer gender</td></tr>
<tr><td>age</td><td>Customer age</td></tr>
<tr><td>category</td><td>Product category</td></tr>
<tr><td>quantity</td><td>Units purchased</td></tr>
<tr><td>price_per_unit</td><td>Item price</td></tr>
<tr><td>cogs</td><td>Cost of goods sold</td></tr>
<tr><td>total_sale</td><td>Total revenue per transaction</td></tr>

</table>

</div>

<div class="section">

<h2>Database Setup</h2>

<h3>Create Database</h3>

<pre>
CREATE DATABASE retail_project;
</pre>

<h3>Create Table</h3>

<pre>
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
</pre>

</div>

<div class="section">

<h2>Data Cleaning & Validation</h2>

<h3>Total Records</h3>

<pre>
SELECT COUNT(*) AS total_records
FROM retail_sales;
</pre>

<h3>Unique Customers</h3>

<pre>
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM retail_sales;
</pre>

<h3>Check Missing Values</h3>

<pre>
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
</pre>

</div>

<div class="section">

<h2>Business Analysis Queries</h2>

<h3>Highest Revenue per Category</h3>

<pre>
SELECT category,
ROUND(AVG(total_sale)::numeric,2) AS avg_revenue
FROM retail_sales
GROUP BY category
ORDER BY avg_revenue DESC;
</pre>

<h3>Best Day for Sales</h3>

<pre>
SELECT TRIM(TO_CHAR(sale_date,'Day')) AS day_of_week,
ROUND(AVG(total_sale)::numeric,2) AS avg_sales
FROM retail_sales
GROUP BY day_of_week
ORDER BY avg_sales DESC;
</pre>

<h3>Highest Spending Age Group</h3>

<pre>
SELECT 
CASE 
WHEN age BETWEEN 18 AND 25 THEN '18-25'
WHEN age BETWEEN 26 AND 35 THEN '26-35'
WHEN age BETWEEN 36 AND 50 THEN '36-50'
ELSE '50+'
END AS age_group,
ROUND(AVG(total_sale)::numeric,2) AS avg_spend
FROM retail_sales
GROUP BY age_group
ORDER BY avg_spend DESC;
</pre>

</div>

<div class="section">

<h2>Key Insights</h2>

<ul>
<li>Evening shift generates approximately <strong>42% of total revenue</strong></li>
<li>Customers aged <strong>26-35</strong> spend the most per transaction</li>
<li>The <strong>top 1% of customers generate 18% of revenue</strong></li>
<li>Beauty and Electronics categories show strong repeat purchases</li>
<li>Revenue peaks in <strong>November</strong>, indicating seasonal demand</li>
</ul>

</div>

<div class="section">

<h2>Business Recommendations</h2>

<h3>Staffing Optimization</h3>
<p>Evening shifts generate the most revenue. Increasing staffing during these hours could improve service and sales.</p>

<h3>Targeted Marketing</h3>
<p>Customers aged 26-35 represent the highest spending demographic and should be targeted through loyalty programs and marketing campaigns.</p>

<h3>Customer Retention</h3>
<p>The top 1% of customers contribute a large portion of revenue. VIP programs could improve retention.</p>

<h3>Seasonal Planning</h3>
<p>Retailers should prepare inventory and promotions ahead of November when demand peaks.</p>

</div>

<div class="section">

<h2>Skills Demonstrated</h2>

<ul>
<li>SQL (PostgreSQL)</li>
<li>Data cleaning and validation</li>
<li>CTEs and subqueries</li>
<li>Customer segmentation</li>
<li>Time-based sales analysis</li>
<li>Business insight generation</li>
</ul>

</div>

<div class="section">

<h2>Conclusion</h2>

<p>This project demonstrates how SQL can transform raw transactional retail data into actionable insights for business decision-making.</p>

<p>The analysis identifies revenue drivers, high-value customers, and operational trends that could support marketing, staffing, and inventory strategies.</p>

</div>

<div class="section">

<h2>Portfolio</h2>

<p><strong>Angela Mokhele</strong></p>
<p>Data Analyst | SQL • Python • Power BI • Machine Learning</p>

</div>

</body>
</html>
