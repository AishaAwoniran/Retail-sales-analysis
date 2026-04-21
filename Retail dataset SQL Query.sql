use Dataset_Practice

select * from sys.tables

select *  from [retail dataset]

--handling null values
select * from [retail dataset]
where unit_price is null

delete from [retail dataset]
where unit_price is null

select  * from [retail dataset]
where city is null

update [retail dataset]
set city = 'Unknown'
where city is null

--
alter table [retail dataset]
alter column discount decimal(10,2)

alter table [retail dataset]
alter column unit_price decimal(10,2)

alter table [retail dataset]
alter column revenue decimal(10,2)

select * from [retail dataset];

--
alter table[retail dataset]
add Record_id
	int
	identity(1,1);

--
with tblresult as
(
select quantity,
	unit_price,
	revenue,
	(quantity * unit_price) as Rrevenue
from [retail dataset]
)
select * from tblresult
where revenue != Rrevenue;

--discount was never applied
--applying discount


update [retail dataset]
set revenue = quantity * unit_price * (1-discount;

select * from [retail dataset];

--Standardizing text format
update [retail dataset]
set product_name= UPPER(product_name);

update [retail dataset]
set category = UPPER(category);

update [retail dataset]
set city= UPPER(city);

update [retail dataset]
set payment_method= UPPER(payment_method);

select * from [retail dataset]

alter table [retail dataset]
drop column order_id

alter table [retail dataset]
add cleaned_order_date date

update [retail dataset]
set cleaned_order_date = 
	coalesce(
		TRY_CONVERT(date, order_date,120),
		try_convert(date, order_date, 103)
		);
--
alter table [retail dataset]
drop column order_date;

--removing future date
delete from [retail dataset]
where cleaned_order_date > GETDATE();


select * from [retail dataset]

--invalid rows
delete from [retail dataset]
where unit_price <= 0
or revenue <= 0

--Total revenue per store
select
store,
SUM(revenue) as Sum_of_revenue
from [retail dataset]
group by store

select
store,
SUM(revenue) as Sum_of_revenue
into store_revenue_summary
from [retail dataset]
group by store

--Top-selling products
select top(2) product_name,
sum(revenue) as Sum_of_revenue
from [retail dataset]
group by product_name


select product_name,
sum(revenue) as Sum_of_revenue
into product_revenue_summary
from [retail dataset]
group by product_name

--Monthly sales trends
select 
	YEAR(cleaned_order_date) as Year,
	MONTH(cleaned_order_date) as month,
	sum(revenue) as Total_revenue
from [retail dataset]
group by
	YEAR(cleaned_order_date),
	MONTH(cleaned_order_date)
order by Year, month;


select 
	YEAR(cleaned_order_date) as Year,
	MONTH(cleaned_order_date) as month,
	sum(revenue) as Total_revenue
into Monthly_sales_trend
from [retail dataset]
group by
	YEAR(cleaned_order_date),
	MONTH(cleaned_order_date)
order by Year, month;

--total revenue
create view VW_revenue_summary
as
select SUM(revenue) as Total_revenue
from [retail dataset];


--Customer purchase behavior
select * from [retail dataset]

CREATE VIEW vw_customer_behavior AS
SELECT 
    customer_id,
    COUNT(DISTINCT Record_id) AS total_orders,
    SUM(revenue) AS total_spent,
    AVG(revenue) AS avg_order_value,
    CASE 
        WHEN SUM(revenue) > 5000 THEN 'High Value'
        WHEN SUM(revenue) BETWEEN 2000 AND 5000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM [retail dataset]
GROUP BY customer_id;

--total no of customer
select count(distinct customer_id) as total_no_of_customer
into Total_no_of_customer
from [retail dataset]
