-- part-to-whole analysis
-- 1: measure / total(measure) * 100 by dimension
-- 2: sales/total_sales * 100 by category
-- 3: quantity / total-quantity * 100 by country

--1: which categories contribute the most to overall sales:
with category_sales as (
	select 
	category,
	sum(sales_amount) as total_sales
	from 
		gold.t_fact_sales f left join gold.t_dim_products p on f.product_key = p.product_key
	group by category
	)
select 
category,
total_sales,
sum(total_sales) over() overall_sales,
concat(round((cast(total_sales as float) * 100 / sum(total_sales) over()), 2), '%') as percentage_of_total
from category_sales 
order by total_sales desc;
