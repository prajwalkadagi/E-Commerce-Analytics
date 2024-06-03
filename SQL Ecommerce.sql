create database ecommerce;
use ecommerce;
select * from olist_customers_dataset;
select * from olist_geolocation_dataset;
select * from olist_order_items_dataset;
select * from olist_order_payments_dataset;
select * from olist_order_reviews_dataset;
select * from olist_orders_dataset;
select * from olist_products_dataset;
select * from olist_sellers_dataset;
select * from product_category_name_translation;


------# 1 Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

select * from olist_order_payments_dataset;
select * from olist_orders_dataset;
 
 select kpi1.day_end, concat(round(kpi1.total_payment / (select sum(payment_value) from olist_order_payments_dataset)
 * 100,2),'%') as percentage_payments_values
 from 
  (select ord.day_end, sum(pmt.payment_value) as total_payment
  from olist_order_payments_dataset as pmt
  join
 (select distinct order_id,
 case 
 when weekday(order_purchase_timestamp) in (5,6) then "Weekend"
 else "Weekday"
 end as Day_end
 from olist_orders_dataset) as ord
 on ord.order_id = pmt.order_id
 group by ord.day_end)as kpi1 ;
 
------#2 Number of Orders with review score 5 and payment type as credit card.
select * from olist_order_reviews_dataset;
select * from olist_order_payments_dataset;

select
count(pmt.order_id) as Total_Orders
from olist_order_payments_dataset pmt
inner join olist_order_reviews_dataset rev on pmt.order_id = rev.order_id
where
rev.review_score = 5
and pmt.payment_type = 'credit_card' ;


------#3   Average number of days taken for order_delivered_customer_date for pet_shop
select * from olist_orders_dataset;
select * from olist_order_items_dataset;
select 
prod.product_category_name,
round(avg(datediff(ord.order_delivered_customer_date, ord.order_purchase_timestamp)),0)  as Avg_delivery_days
from olist_orders_dataset ord
join
(select product_id, Order_id, product_category_name
from olist_products_dataset
join olist_order_items_dataset using(product_id)) as prod
on ord.order_id = prod.order_id
where prod.product_category_name = "Pet_shop" 
group by prod.product_category_name;


------#4 Average price and payment values from customers of sao paulo city
select * from olist_order_payments_dataset;
select * from olist_customers_dataset;
select * from  olist_order_items_dataset; 

SELECT round(AVG(od.price)) AS average_price,round(AVG(op.payment_value)) AS average_payment_value FROM olist_order_items_dataset od
JOIN olist_orders_dataset o ON od.order_id = o.order_id
JOIN olist_order_payments_dataset op ON o.order_id = op.order_id
JOIN olist_customers_dataset oc ON o.customer_id = oc.customer_id
WHERE oc.customer_city = 'Sao Paulo';


------#5 Relationship between shipping days (order_delivered_customer_date , order_purchase_timestamp) Vs review scores.

select
rew.review_score,
round(avg(datediff(ord.order_delivered_customer_date, order_purchase_timestamp)),0) as "Avg shipping days" 
from olist_orders_dataset as ord
join olist_order_reviews_dataset as rew on rew.order_id = ord.order_id
group by rew.review_score
order by rew.review_score desc ;
