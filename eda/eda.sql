--Analyze dimension and measure: find what is dimensions and what is measures.


--DB exploratory
	--Exxplore all objects in the Database:
	select * from information_schema.tables;
	--Explore all columns in the Database:
	select * from information_schema.columns where table_name  in ('dim_products', 'dim_customers', 'fact_sales');


--Dim exploratory: identifying the unique values (categories) in each dimensions.
--using DISTINCT to evaluate
	--dim_customers explore:
	--display all columns of dim_customers view:
	select table_name, column_name from information_schema.columns where table_name = 'dim_customers';
	--explore data of dim_customers view:
	select * from gold.dim_customers;
	--explore all countries where customers come from:
	select distinct country from gold.dim_customers;

	--dim_products explore:
	select table_name, column_name from information_schema.columns where table_name = 'dim_products';
	--explore all categories, subcategories and product_name
	select distinct category, subcategory, product_name from gold.dim_products;


--Date exploratory: identify the earliest and latesd dates (boundaries)
--understand the scope of data and the timespan
	--find the first and last order date of fact_sales:
	--how many years of sales are available:
	select 
		min(order_date) as first_order_date,
		max(order_date) as last_order_date,
		datediff(month, min(order_date), max(order_date)) as order_range_months
	from gold.fact_sales;
	
	--find the youngest and oldest customers:
	select 
		min(birthdate) as oldest_birtthdate,
		datediff(year, min(birthdate), getdate()) as oldest_age,
		max(birthdate) as youngest_birthdate,
		datediff(year, max(birthdate), getdate()) as youngest_age
	from gold.dim_customers;


--Measures exploratory:calculate the key metrics of the business (Big numbers) 
--Highest level of aggregation | Lowest level of details
select * from gold.fact_sales;
	--find the total sales
	select sum(sales_amount) as total_sales from gold.fact_sales;
	
	--find how many items are sold
	select sum(quantity) as total_quantity from gold.fact_sales;
	
	--find the average selling price
	select avg(price) as avg_price from gold.fact_sales;
	
	--find total number of orders
	select count(order_number) as total_orders from gold.fact_sales;
	select count(distinct order_number) as total_order_distinct from gold.fact_sales;
	
	--checking the diff between with distinct and without distinct
	select order_number, count(*) as nb_of_duplicates from gold.fact_sales group by order_number order by nb_of_duplicates;
	
	--find total number of products
	select * from gold.fact_sales;
	select count(distinct product_key) as total_fact_products from gold.fact_sales;
	select count(distinct product_key) as total_dim_products from gold.dim_products;

	-- find all products not being sold:
	select distinct product_key 
	from gold.dim_products 
	where product_key not in (select distinct product_key from gold.fact_sales);
	--another solutions:
	select distinct product_key from gold.dim_products
	except
	select distinct product_key from gold.fact_sales;
	--another solutions:
	select count(distinct product_key) as total_inven_products 
	from gold.dim_products dp
	where not exists (select * from gold.fact_sales fs where dp.product_key = fs.product_key);

	--find total number of customers
	select count(distinct customer_key) as total_customers from gold.dim_customers;
	select count(customer_key) as total_customers from gold.dim_customers;

	--find the total number of customers that has placed an order
	select count(distinct customer_key) as total_ordered_customers from gold.fact_sales; 
	-- conclusion: all customer placed at least an order.

	--generate a report that shows all key metrics of the business
	select 'Total Sales' as measure_name, sum(sales_amount) as measure_value from gold.fact_sales
	union 
	select 'Total Quanity' as measure_name, sum(quantity) as measure_value from gold.fact_sales
	union 
	select 'Average Price' as measure_name, avg(price) as measure_value from gold.fact_sales
	union 
	select 'Total Orders' as measure_name, count(distinct order_number) as measure_value from gold.fact_sales
	union 
	select 'Total Customers' as measure_name, count(distinct customer_key) as measure_value from gold.dim_customers
	union 
	select 'Total Products' as measure_name, count(distinct product_key) as measure_value from gold.dim_products
	order by measure_value desc;


-- Magnitude Analysis: compare the measure values by categories. Understand the importance of different categories.
--[Measure] by [Dimension]:
select * from gold.fact_sales;
	--total customer by country:
	select 
		country,
		count(distinct customer_key) as customer_per_country
	from gold.dim_customers
	group by country
	order by customer_per_country desc;

	--total customers by gender:
	select
		gender,
		count(distinct customer_key) as customers_per_gender
	from gold.dim_customers
	group by gender
	order by customers_per_gender desc;

	--total products by category:
	select 
		category_id, 
		category as category_name,
		count(distinct product_key) as products_per_category
	from gold.dim_products
	group by 
		category_id, category
	order by 
		products_per_category desc;

	--average costs in each category:
	select 
		category,
		avg(cost) as avg_cost_per_category
	from gold.dim_products
	group by 
		category
	order by 
		avg_cost_per_category desc;

	--total revenue generated for each category:
	select
		dp.category,
		coalesce(sum(fs.sales_amount), 0) as total_revenue_per_category
	from 
		gold.dim_products dp left join gold.fact_sales fs on dp.product_key = fs.product_key
	group by
		dp.category
	order by
		total_revenue_per_category desc;

	--total revenue generated by each customer:
	select
		dc.customer_key, dc.first_name + dc.last_name as full_name,
		coalesce(sum(fs.sales_amount), 0) as total_revenue_per_customer
	from
		gold.dim_customers dc left join gold.fact_sales fs on dc.customer_key = fs.customer_key
	group by
		dc.customer_key, dc.first_name + dc.last_name
	order by 
		total_revenue_per_customer desc;

	--distribution of sold items across countries:
	select
		dc.country,
		coalesce(sum(fs.quantity), 0) as total_items_per_country
	from
		gold.dim_customers dc left join gold.fact_sales fs on dc.customer_key = fs.customer_key
	group by
		dc.country
	order by 
		total_items_per_country desc;