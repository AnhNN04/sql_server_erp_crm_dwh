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
with base_query as (
--base query:retrieve all essential informations
select 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
concat(c.first_name, ' ', c.last_name) as customer_name,
c.birthdate,
datediff(year, c.birthdate, getdate()) as age
from gold.t_fact_sales f left join gold.t_dim_customers c on f.customer_key = c.customer_id
where f.order_date is not null),
customer_aggregation as ( 
--customer_agregation: summarized key metrics at the customer level
select 
base_query.customer_key,
base_query.customer_number,
base_query.customer_name,
base_query.birthdate,
base_query.age,
count(distinct base_query.order_number) as total_orders,
coalesce(sum(base_query.sales_amount), 0) as total_sales,
coalesce(sum(base_query.quantity), 0) as total_quantity,
count(distinct base_query.product_key) as total_products,
max(base_query.order_date) as last_order_date,
datediff(month, min(base_query.order_date), max(base_query.order_date)) as lifespan
from base_query
where customer_key is not null
group by customer_key, customer_number, customer_name, birthdate, age)

--main query 
select 
customer_key,
customer_number,
customer_name,
birthdate,
age,
case 
	when age < 20 then 'UNDER 20'
	when age between 20 and 29 then '20 - 29'
	when age between 30 and 39 then '30 - 39'
	when age between 40 and 49 then '40 - 49'
	else '50 AND ABOVE'
end as age_segment, 
case
	when lifespan >= 12 and total_sales > 5000 then 'VIP'
	when lifespan >= 12 and total_sales <= 5000 then 'REG'
	else 'NEW'
end as customer_segment,
last_order_date,
datediff(month, last_order_date, getdate()) as recency,
total_sales,
total_orders,
--compute average order value (AVO)
case 
	when total_orders = 0 then 0
	else total_sales / total_orders 
end as avg_order_value,
--compute average monthly spend
lifespan,
case 
	when lifespan = 0 then total_sales
	else total_sales / lifespan
end as avg_monthly_spend,
total_quantity,
total_products
into report.report_customer
from customer_aggregation;