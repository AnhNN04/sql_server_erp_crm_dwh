/*
==========================================================
Customer report
==========================================================
Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages and transaction details
	2. Segments customers into categories (VIP, REG, NEW) and age groups
	2. Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates caluable KIPs:
		- recency (months since last order)
		- average order value
		- average monthly spend
==========================================================
*/

--1: base query for essential informatin rertrival
select 
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_key,
	c.customer_number,
	c.first_name,
	c.last_name,
	c.birthdate,
	datediff(year, c.birthdate, getdate()) as age
into gold.#base_informations
from gold.t_fact_sales f left join gold.t_dim_customers c on f.customer_key = c.customer_key
where order_date is not null

--2: transformed informations
select 
	customer_key,
	customer_number,
	first_name + ' ' + last_name as fullname,
	age,
	count(distinct order_number) as total_orders,
	sum(sales_amount) as total_sales,
	sum(quantity) as total_quantity,
	count(distinct product_key) as total_products,
	max(order_date) as last_order,
	datediff(month, min(order_date), max(order_date)) as lifespan
into gold.#transformed_informations
from gold.#base_informations
group by 
	customer_key,
	customer_number,
	first_name + ' '+ last_name,
	age;

-- starting analytical processes.
 