-- data segmentation: using case when statements
--segment products into cost ranges and count how many products fall into each segment
with product_segment as (
	select 
		product_key,
		product_name,
		cost,
		case
			when cost < 100 then 'Below 100'
			when cost between 100 and 500 then '100-500'
			when cost between 500 and 1000 then '500-1000'
			else 'Above 1000'
		end as cost_range
	from gold.t_dim_products 
	)

select
	cost_range,
	count(distinct product_key) as total_products
from product_segment
group by cost_range
order by total_products desc;

--group customers into three segments based on their spending behavior:
	--VIP: customers with at least 12 months of history and spending more than 5000
	--REG(Regular): customers with at least 12 months of history but spending 5000 or less
	--NEW: customer with lifespan less than 12 months
--and find the total number of customers by each groups
with customer_spending as (
	select 
		c.customer_key,
		coalesce(sum(f.sales_amount), 0) as total_spending,
		min(f.order_date) as first_date,
		max(f.order_date) as last_order,
		datediff(month, min(order_date), max(order_date)) as lifespan
	from gold.t_fact_sales f left join gold.t_dim_customers c on f.customer_key = c.customer_key
	group by c.customer_key
	)
select
	customer_segment,
	count(distinct customer_key) as total_customers
	from 
	(select 
		customer_key,
		case 
			when lifespan >= 12 and total_spending > 5000 then 'VIP'
			when lifespan >= 12 and total_spending <= 5000 then 'REG'
			else 'NEW'
		end as customer_segment
	from customer_spending
	) t
group by customer_segment 
order by total_customers desc;