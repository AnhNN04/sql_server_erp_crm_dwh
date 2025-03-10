-- cumulative analysis: using window functions

--calculate the total sales per month and the running total of sales over time
select
	*,
	sum(total_sales) over(partition by datetrunc(year, order_date) order by order_date) as running_total_sales,
	avg(avg_price) over(order by order_date) as moving_average_price
from
	(
	select 
		datetrunc(year, order_date) as order_date,
		coalesce(sum(sales_amount), 0) as total_sales,
		avg(price) as avg_price
	from gold.t_fact_sales
	where order_date is not null
	group by datetrunc(year, order_date)
	) as t