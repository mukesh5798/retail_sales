CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
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

select * from retail_sales

select * from retail_sales limit 10

select count(*) from retail_sales 

delete from retail_sales where 
	transactions_id is null or 
	sale_date is null or
	customer_id is null or
	sale_time is null or 
	gender is null or
	-- age is null or
	category is null or
	quantity is null or
	price_per_unit is null or
	cogs is null or
	total_sale is null
	
-- How many sales we have
select count(*) as Total_sales from retail_sales

-- how many unique customer we have
select count(distinct customer_id) as total_sales from retail_Sales

select distinct customer_id, sum(total_sale) as Tota_Sales,count(*) as countNum
	from retail_Sales 
	group by customer_id order by customer_id asc


select distinct category from retail_Sales

-- Data analysis & Business Key Problems & Answers

-- Write a SQL Query to retrieve all columns for sales made on '2022-11-05'

select * from retail_sales where sale_date = '2022-11-05'

-- Write a SQL Query to retrieve all transactions where the category is 
	-- 'Clothing' and the Quantity sold is more than 10 in the month of nov-2022.

-- select category,sum(quantity) from retail_Sales
-- 	where category='Clothing' and to_char(sale_date,'yyyy-11')='2022-11'
-- 	group by 1

select * from retail_Sales
	where category='Clothing' 
	and 
	to_char(sale_date,'yyyy-11')='2022-11'
	and
	quantity >= 4
	group by 1

-- Write a SQL query to calculate the total sales (total_sale) for each category

select category,sum(total_sale) as Total_Sales,count(*) as total_orders 
	from retail_sales
	group by category

-- Write a SQL Query to find the average age of customers who purchased items from the 'Beauty' category

select round(avg(age),2) as Avg_age from retail_sales 
	where category = 'Beauty'

-- Write a SQL Query to find all transactions where the total_sale is greater than 1000

select * from retail_sales where total_sale > 1000

-- Write a SQL Query to find the total_number of transactions (transaction_id)
-- made by each gender in each category

select category,gender,count(*) as total_transaction 
	from retail_sales group by category,gender order by category asc

-- Write a SQL Query to calculate the average sale for each month,find out best selling month in each year

with cte as (select extract(year from sale_date) as years,
	extract(month from sale_date) as months,
	avg(total_sale) as avg_sales_month,
	rank() over (partition by extract(year from sale_date) order by avg(total_sale) desc) as rnk
	from retail_sales 
	group by years,months)

select * from cte where rnk = 1

-- Write a SQL Query to find the top 5 customers based on the highest total sales

select customer_id,sum(total_sale) as Total_Sales from retail_sales
	group by customer_id order by Total_Sales desc limit 5

-- Write a SQL Query to find the number of unique customers who purchased items from each category.

with cte as (select customer_id, category, sum(total_sale)as total_sales,
	rank() over (partition by customer_id order by sum(total_sale) desc) as rnk
	from retail_sales
	group by customer_id,category)
select * from cte where rnk = 1

-- Write a SQL Query to create each shift and number of orders[example morning<12, afternoon between 12&17, evening >17]

select *,
	case
	when extract(hour from sale_time) < 12 then 'Morning'
	when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
	End as shift
from retail_sales