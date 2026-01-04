DROP DATABASE IF EXISTS Session05_3;
CREATE DATABASE Session05_3;
USE Session05_3;
create table orders(
 order_id int,
 customer_id int,
 total_amount decimal(10,2),
 order_date date,
 status enum('pending', 'completed', 'cancelled')
 );
insert into orders(order_id, customer_id, total_amount, order_date, status) 
values (1, 1, 6000000, "2024-06-01", 'completed'), (2, 2, 4500000, "2024-06-02", 'pending'), (3, 1, 5500000, "2024-06-03", 'completed'), (4, 3, 2000000, "2024-06-04", 'cancelled'), (5, 1, 8000000, "2024-06-05", 'completed'), (6, 2, 3000000, "2024-06-06", 'pending');
select * from orders
where status = 'completed';
select * from orders
 where total_amount > 5000000;
select * from orders
 order by order_date desc limit 5;
select * from orders 
where status = 'completed' order by total_amount desc;