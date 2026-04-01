
--CREATE TABLE
DROP TABLE IF EXISTS retail_sale;
Create Table retail_sales
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,	
				sale_time TIME,	
				customer_id INT,
				gender VARCHAR(25),
				age INT,
				category VARCHAR(25),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
		);
SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*)
FROM retail_sales;


--Data cleaning
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--Data exploration
--How many sales do we have?
SELECT COUNT(*) AS total_sales
FROM retail_sales;

--How many(unique) customers do we have?
SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

--What categories do we have?
SELECT DISTINCT category
FROM retail_sales;


-- Q.1 Retrieve all columns for sales made on '2022-11-05
-- Q.2 Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Calculate the total sales (total_sale) for each category.
-- Q.4 Find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Find all transactions where the total_sale is greater than 1000.
-- Q.6 Find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Find the top 5 customers based on the highest total sales in the clothing category
-- Q.9 Find the number of unique customers who purchased items from each category.
-- Q.10 Write a query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
--Q.11: Which customers contribute the most revenue?
--Q.12: Which age group generate the highest revenue?
--Q13: How does revenue change month to month?


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT * FROM retail_sales
WHERE TO_CHAR (sale_date,'YYYY-MM')='2022-11'
	AND 
	quantiy >=4
	AND 
	category = 'Clothing';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,
	SUM (total_sale) AS total_sales
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2)AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales
WHERE total_sale >1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, 
	COUNT(*) AS no_of_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT year,
		month,
		avg_monthly_sales
FROM 
(

SELECT
	AVG (total_sale) AS avg_monthly_sales,
	EXTRACT(month FROM sale_date) AS month,
	EXTRACT(year FROM sale_date) AS year,
	RANK()OVER (PARTITION BY EXTRACT(year FROM sale_date)ORDER BY AVG (total_sale)DESC ) AS rank
FROM retail_sales
GROUP BY year,month
) AS t1
WHERE rank = 1
 
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales in the clothing category
SELECT
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
WHERE category = 'Clothing'
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	COUNT(DISTINCT customer_id) AS customer_id,
			category
FROM retail_sales
GROUP BY category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH sales_per_shift
AS
(
SELECT *,
	CASE  
		WHEN EXTRACT(HOUR FROM sale_time)<=12  THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time)BETWEEN 12 AND 17  THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) AS total_orders
FROM sales_per_shift
GROUP BY shift

--Q.11: Which customers contribute the most revenue?

SELECT 
    customer_id,
    SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;

--Q.12: Which age group generate the highest revenue?
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 50 THEN '36-50'
        ELSE '50+'
    END AS age_group,
    SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY age_group
ORDER BY total_revenue DESC;

--Q13: How does revenue change month to month?
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    SUM(total_sale) AS monthly_revenue
FROM retail_sales
GROUP BY year, month
ORDER BY year, month;

--End of project
