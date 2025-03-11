use sales_analysis_project;
select * from sales_data;
select * from cus_data;
select * from pro_data;

-- Making primary key in each table
Alter table sales_data
Add primary key (order_id);

Alter table cus_data
Add primary key (customer_id);

Alter table pro_data
Add primary key (product_id);

-- Adding a auto-increment column in each table
Alter table sales_data
add column id int unique key auto_increment;

Alter table cus_data
add column id int unique key auto_increment;

Alter table pro_data
add column id int unique key auto_increment;

Select * from pro_data where product_id = 819;

-- making total_amount new column to nulify null values
Create table sales1_data as 
SELECT 
    s.id,order_id, customer_id, s.product_id, order_date, quantity, s.`discount_in_%`, (s.quantity * p.`price_in_$`) * round((1 - CAST(s.`discount_in_%` AS DECIMAL) / 100),2) AS total_amount, payment_method, shipping_cost, s.status
FROM 
    sales_data s 
INNER JOIN 
    pro_data p 
ON 
    p.product_id = s.product_id;

-- best customer 
with t as (
Select n.customer_id from 
(SELECT 
    s.id,order_id, customer_id, s.product_id, order_date, quantity, s.`discount_in_%`, (s.quantity * p.`price_in_$`) * round((1 - CAST(s.`discount_in_%` AS DECIMAL) / 100),2) AS total_amount, payment_method, shipping_cost, s.status
FROM 
    sales_data s 
INNER JOIN 
    pro_data p 
ON 
    p.product_id = s.product_id) n
group by 1
order by sum(n.total_amount) desc limit 5) ,
s as (
select customer_id, product_id, sum(total_amount) as total from (
SELECT 
    s.id,order_id, customer_id, s.product_id, order_date, quantity, s.`discount_in_%`, (s.quantity * p.`price_in_$`) * round((1 - CAST(s.`discount_in_%` AS DECIMAL) / 100),2) AS total_amount, payment_method, shipping_cost, s.status
FROM 
    sales_data s 
INNER JOIN 
    pro_data p 
ON 
    p.product_id = s.product_id
where customer_id in (select * from t)) s
group by 1,2 order by 1,3 desc)
select *, sum(total) over (partition by customer_id) as grand_total from s;



--
Select n.customer_id, n.product_name, sum(n.total_amount) as total_purchase from 
(SELECT 
    s.id,order_id, customer_id, s.product_id, order_date, quantity, s.`discount_in_%`, (s.quantity * p.`price_in_$`) * round((1 - CAST(s.`discount_in_%` AS DECIMAL) / 100),2) AS total_amount, payment_method, shipping_cost, s.status, p.product_name
FROM 
    sales_data s 
INNER JOIN 
    pro_data p 
ON 
    p.product_id = s.product_id) n
group by 1,2
order by 3;













select *
FROM 
    sales_data s 
INNER JOIN 
    pro_data p 
ON 
    p.product_id = s.product_id
where customer_id in (
Select n.customer_id from 
(SELECT 
    s.id,order_id, customer_id, s.product_id, order_date, quantity, s.`discount_in_%`, (s.quantity * p.`price_in_$`) * round((1 - CAST(s.`discount_in_%` AS DECIMAL) / 100),2) AS total_amount, payment_method, shipping_cost, s.status
FROM 
    sales_data s 
INNER JOIN 
    pro_data p 
ON 
    p.product_id = s.product_id) n
group by 1
order by 2 desc limit 5);
