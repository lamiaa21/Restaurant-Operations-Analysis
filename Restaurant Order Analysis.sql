-- Explore the items table...................................................................................................
-- View the menu_items table and write a query to find the number of items on the menu
select * from menu_items;

select count(menu_item_id) from menu_items;

-- What are the least and most expensive items on the menu?
select item_name,price
from menu_items
order by price
limit 1;

select item_name,price
from menu_items
order by price desc
limit 1;

-- How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?
select count(menu_item_id) as italian_deshes
from menu_items
where category = 'Italian';

select item_name,price
from menu_items
where category = 'Italian'
order by price desc;

-- How many dishes are in each category? What is the average dish price within each category?
select category,count(menu_item_id) as count_items, avg(price) as avg_price
from menu_items
group by category;

-- Explore the orders table....................................................................................
-- View the order_details table. What is the date range of the table?
select max(order_date),min(order_date) from order_details;

-- How many orders were made within this date range? How many items were ordered within this date range?
select count(order_details_id) as total_items,
	   count(distinct order_id) as total_orders
from order_details;

-- Which orders had the most number of items?
select order_id, count(order_details_id) as total_items
from order_details
group by order_id
order by total_items desc;

-- How many orders had more than 12 items?
select order_id, count(order_details_id) as total_items
from order_details
group by order_id
having total_items >12
order by total_items desc;

-- Analyze customer behavior..........................................................................
-- Combine the menu_items and order_details tables into a single table
select *
from order_details left join menu_items on order_details.item_id = menu_items.menu_item_id;

-- What were the least and most ordered items? What categories were they in?
select menu_items.item_name, menu_items.category, count(order_details.item_id)
from order_details left join menu_items on order_details.item_id = menu_items.menu_item_id
group by menu_items.item_name, menu_items.category
having count(order_details.item_id) > 0
order by count(order_details.item_id);

-- What were the top 5 orders that spent the most money?
select order_details.order_id, sum(menu_items.price)
from order_details left join menu_items on order_details.item_id = menu_items.menu_item_id
group by order_details.order_id
order by sum(menu_items.price) desc
limit 5;

-- View the details of the highest spend order. Which specific items were purchased?
with top_order as (select  sum(menu_items.price) as totals, order_details.order_id as orders
from order_details inner join menu_items on order_details.item_id = menu_items.menu_item_id
group by order_details.order_id
order by totals desc
limit 1)
select menu_items.menu_item_id, menu_items.item_name, menu_items.price, order_details.order_id
from menu_items inner join order_details on order_details.item_id = menu_items.menu_item_id
where order_details.order_id = (select orders from top_order);

-- View the details of the top 5 highest spend orders
with top_order as (select  sum(menu_items.price) as totals, order_details.order_id as orders
from order_details inner join menu_items on order_details.item_id = menu_items.menu_item_id
group by order_details.order_id
order by totals desc
limit 5)
select menu_items.menu_item_id, menu_items.item_name, menu_items.price, order_details.order_id
from menu_items inner join order_details on order_details.item_id = menu_items.menu_item_id
where order_details.order_id in (select orders from top_order);