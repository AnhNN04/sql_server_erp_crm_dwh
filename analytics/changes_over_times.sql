-- checking all information of data warehouse:
select catalog_name, schema_name, schema_owner from information_schema.SCHEMATA where schema_owner = 'dbo';

-- gold lalyer initialization from views:
-- convention: t_name is table_name. 
-- prefix t_ means this object is a table.
select * into gold.t_dim_products from gold.dim_products;
select * into gold.t_dim_customers from gold.dim_customers;
select * into gold.t_fact_sales from gold.fact_sales;

-- checking data after initialization:
select top 10 * from gold.t_dim_products;
select top 10 * from gold.t_dim_customers;
select top 10 * from gold.t_fact_sales;

-- Analytical process:
--1.Changes over time analysis: measure by date dimension
--a: by year
select
	case 
		when year(order_date) is null then 'Undefined Year'
		else cast(year(order_date) as varchar(4))
	end as order_year,
	-- aggregate calculation:
	coalesce(sum(sales_amount), 0) as total_sales,
	count(distinct customer_key) as total_customers,
	coalesce(sum(quantity), 0) as total_quanity
from 
	gold.t_fact_sales
group by 
	case 
		when year(order_date) is null then 'Undefined Year'
		else cast(year(order_date) as varchar(4))
	end
order by 
	order_year;
--b. by month
select
	case 
		when year(order_date) is null then 'Undefined Year'
		else cast(year(order_date) as varchar(4))
	end as order_year,
	case 
		when month(order_date) is null then 'Undefined Month'
		else cast(month(order_date) as varchar(4))
	end as order_month,
	-- aggregate calculation:
	coalesce(sum(sales_amount), 0) as total_sales,
	count(distinct customer_key) as total_customers,
	coalesce(sum(quantity), 0) as total_quanity
from 
	gold.t_fact_sales
group by 
	case 
		when year(order_date) is null then 'Undefined Year'
		else cast(year(order_date) as varchar(4))
	end,
	case 
		when month(order_date) is null then 'Undefined Month'
		else cast(month(order_date) as varchar(4))
	end
order by 
	order_year, order_month;

--using datetrunc(unit, col)
--by month:
select
	case 
		when datetrunc(month, order_date) is null then 'Undefined Time'
		else cast(datetrunc(month,order_date) as varchar(10))
	end as order_time,
	-- aggregate calculation:
	coalesce(sum(sales_amount), 0) as total_sales,
	count(distinct customer_key) as total_customers,
	coalesce(sum(quantity), 0) as total_quanity
from 
	gold.t_fact_sales
group by 
	case 
		when datetrunc(month, order_date) is null then 'Undefined Time'
		else cast(datetrunc(month, order_date) as varchar(10))
	end
order by 
	order_time;

--by year:
select
	case 
		when datetrunc(year, order_date) is null then 'Undefined Time'
		else cast(datetrunc(year,order_date) as varchar(10))
	end as order_time,
	-- aggregate calculation:
	coalesce(sum(sales_amount), 0) as total_sales,
	count(distinct customer_key) as total_customers,
	coalesce(sum(quantity), 0) as total_quanity
from 
	gold.t_fact_sales
group by 
	case 
		when datetrunc(year, order_date) is null then 'Undefined Time'
		else cast(datetrunc(year, order_date) as varchar(10))
	end
order by 
	order_time;

--using format():
select
	case 
		when format(order_date, 'yyyy-MMM') is null then 'Undefined Time'
		else cast(format(order_date, 'yyyy-MMM') as varchar(10))
	end as order_time,
	-- aggregate calculation:
	coalesce(sum(sales_amount), 0) as total_sales,
	count(distinct customer_key) as total_customers,
	coalesce(sum(quantity), 0) as total_quanity
from 
	gold.t_fact_sales
group by 
	case 
		when format(order_date, 'yyyy-MMM') is null then 'Undefined Time'
		else cast(format(order_date, 'yyyy-MMM') as varchar(10))
	end
order by 
	order_time;