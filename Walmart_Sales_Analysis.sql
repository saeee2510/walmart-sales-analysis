use walmartSales1;

-- Create table
CREATE TABLE IF NOT EXISTS walmartsales1(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12, 4),
    rating FLOAT
);

-- Data cleaning
select *
from walmartsales1;

-- Add the time_of_the_day column
SELECT time,
(CASE
	WHEN 'time' between "00:00:00" and "12:00:00" THEN "Morning"
    WHEN 'time' between "12:00:00" and "16:00:00:" THEN "Afternoon"
    ELSE "Evening"
    END) as time_of_the_day
FROM walmartsales1;

ALTER table walmartsales1
ADD COLUMN time_of_the_day VARCHAR(20);

UPDATE walmartsales1
SET time_of_the_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- ADD DAY NAME COLUMN
SELECT date,
DAYNAME(date)
FROM walmartsales1;

ALTER TABLE walmartsales1 ADD COLUMN day_name VARCHAR(10);

UPDATE walmartsales1
SET day_name = DAYNAME(date);

-- ADD MONTH NAME COLUMN
SELECT date,
MONTHNAME(date)
FROM walmartsales1;

ALTER TABLE walmartsales1 ADD COLUMN month_name VARCHAR(10);

UPDATE walmartsales1
SET month_name = MONTHNAME(date);

-- -------------------------------------------------------------------- --
-- ---------------------------- GENERIC ------------------------------- --
-- -------------------------------------------------------------------- --

-- 1. How many unique cities does the data have?
SELECT DISTINCT city
FROM walmartsales1;

-- 2. In which city is each branch?
SELECT Distinct  city, branch
FROM walmartsales1;

-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------

-- 1. How many unique product lines does the data have?
SELECT DISTINCT product_line
FROM walmartsales1;

-- 2. What is the most common payment method?
SELECT payment , COUNT(payment) as total_no
FROM walmartsales1
GROUP BY payment
ORDER by total_no DESC;

-- 3. What is the most selling product line?
SELECT product_line, count(product_line) as total_count
FROM walmartsales1
GROUP BY product_line
ORDER BY total_count desc;

-- 4. What is the total revenue by month?
SELECT month_name as month, sum(total ) as total_revenue
FROM walmartsales1
GROUP BY month
ORDER BY total_revenue desc;

-- 5. What month had the largest COGS?
SELECT month_name as month, sum(cogs) as cogs
FROM walmartsales1
GROUP BY month
ORDER BY cogs desc
LIMIT 1;

-- 6. What product line had the largest revenue?
SELECT product_line, sum(total) as revenue
FROM walmartsales1
GROUP BY product_line
ORDER BY revenue
LIMIT 1;

-- 7. What is the city with the largest revenue?
SELECT city, sum(total) as revenue
FROM walmartsales1
GROUP BY city
ORDER BY revenue
LIMIT 1;

-- 8. What product line had the largest VAT?
SELECT product_line, AVG(tax_pct) as avg_tax
FROM walmartsales1
GROUP BY product_line
ORDER BY avg_tax desc;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT AVG(quantity) as avg_qnty
FROM walmartsales1;

SELECT product_line,
CASE WHEN AVG(quantity)> 5.51 then "good"
else "bad"
END as remark	
FROM walmartsales1
GROUP BY product_line; 

-- 10. Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM walmartsales1
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM walmartsales1);

-- 11.  What is the most common product line by gender
SELECT gender,product_line, COUNT(gender) as total_cnt
FROM walmartsales1
GROUP BY gender, product_line
ORDER BY total_cnt;

-- 12. What is the average rating of each product line
SELECT product_line, round(avg(rating),2) as rating
FROM walmartsales1
GROUP BY product_line
ORDER BY rating desc;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Sales -------------------------------
-- --------------------------------------------------------------------

-- 1. Number of sales made in each time of the day per weekday
SELECT
	time_of_the_day,
	COUNT(*) AS total_sales
FROM walmartsales1
WHERE day_name != "sunday"
GROUP BY time_of_the_day 
ORDER BY total_sales DESC;

-- 2. Which of the customer types brings the most revenue?
select customer_type, count(*) as total_sales
from walmartsales1
group by customer_type
order by total_sales desc;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?
select city, round(avg(tax_pct),2) as avg_tax_pct
from walmartsales1
group by city
order by avg_tax_pct desc
limit 1;

-- 4. Which customer type pays the most in VAT?
select customer_type, round(avg(tax_pct),2) as VAT
from walmartsales1
group by customer_type
order by VAT desc
limit 1;

-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- 1. How many unique customer types does the data have?
select distinct customer_type
from walmartsales1;

-- 2. How many unique payment methods does the data have?
select distinct payment
from walmartsales1;

-- 3. What is the most common customer type?
select customer_type, count(*) as count
from walmartsales1
group by customer_type
order by count desc;

-- 4. Which customer type buys the most?
select customer_type, count(*)  as count
from walmartsales1
group by customer_type
order by count desc;

-- 5. What is the gender of most of the customers?
select gender, count(*) as count
from walmartsales1
group by gender
order by count desc;

-- 6. What is the gender distribution per branch?
select gender, branch, count(*) as count
from walmartsales1
group by gender, branch
order by count desc;

-- 7. Which time of the day do customers give most ratings?
select time_of_the_day as time, round(avg(rating),2) as avg_rating
from walmartsales1
group by time_of_the_day
order by avg_rating desc;

-- 8. Which time of the day do customers give most ratings per branch?
select time_of_the_day as time, branch, round(avg(rating),2) as avg_rating
from walmartsales1
group by time_of_the_day, branch
order by avg_rating desc;

-- 9. Which day fo the week has the best avg ratings?
SELECT
	day_name,
	round(AVG(rating),2) AS avg_rating
FROM walmartsales1
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- 10. Which day of the week has the best average ratings per branch?
select day_name as day,branch, round(avg(rating),2) as avg_rating
from walmartsales1
group by day_name, branch
order by avg_rating desc;








