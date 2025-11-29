create database dmart_analysis;
use dmart_analysis;
select * from dmart_sales;

-- Find the total number of orders placed by each customer. 
-- Show Customer ID and total orders,sorted by highest orders first.
select customer_id, count(order_id) as total_orders
from dmart_sales
group by customer_id
order by total_orders desc;
-- Calculate the total revenue generated each year. Use Total Order Value and group by Year.
SELECT 
    year, ROUND(SUM(total_order_value), 0) AS revenue
FROM
    dmart_sales
GROUP BY year
ORDER BY revenue DESC;
-- Find the top 5 products which provided the highest average discount (MRP - Discount Price)
SELECT 
    product_name, ROUND(AVG(mrp - discount_price), 2) AS agg
FROM
    dmart_sales
GROUP BY product_name
ORDER BY agg DESC
LIMIT 5;
-- Group customers into age groups (e.g., 18–25, 26–35, 36–45, 46–60, 60+) and 
-- find total orders per age group.
select count(order_id) as cc,
case 
when customer_age between 18 and 25 then "18-25"
when customer_age between 26 and 35 then "26-35"
when customer_age between 36 and 45 then "36-45"
when customer_age between 46 and 60 then "46-60"
else "60+"
end as age_group
from dmart_sales
group by age_group;

-- Show category-wise total revenue and number of products sold. 
-- Sort by revenue in descending order.
select category,
count(product_id) as product_sold,
round(sum(total_order_value),0) as revenue
from dmart_sales
group by category 
order by revenue,product_sold desc;
-- Find the count of orders for each Payment Method and show which method is used the most.
select payment_method,
count(order_id) as count
from dmart_sales
group by payment_method
order by count desc;
-- Calculate the average delivery time (Delivery Date – Order Date) for each State.
select state,
avg(datediff(
str_to_date(delivery_date,"%d-%m-%y"),
str_to_date(order_date,"%d-%m-%y")
)) as average_delivery_time
from dmart_sales
where delivery_date is not null
group by state
order by average_delivery_time desc;

-- Find the cancellation percentage of orders by State.
-- Formula: (Cancelled Orders / Total Orders) × 100

select state,count(order_id) as total_order,
(sum(case when cancellation_date is not null then 1 else 0 end)/count(order_id)*100) as cancel_percentage
from dmart_sales
group by state;
-- Find the Top 10 most frequently purchased products across all years.
select product_name,count(order_id) as count
from dmart_sales
group by product_name
order by count desc
limit 10;
-- Compare the average Total Order Value of orders with Shipping Charges = 0 vs > 0.
select 
case 
when shipping_charges =0 then "free shipping" else "paid"
end as shipping,
round(avg(total_order_value)),
count(order_id)
from dmart_sales
group by shipping;
