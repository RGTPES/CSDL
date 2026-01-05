DROP DATABASE IF EXISTS Session06_4;
create database Session06_4;
use Session06_4;
create table products (
product_id int primary key ,
product_name varchar(255),
price decimal(10,2)
);
create table order_items(
order_id int ,
product_id int,
quantity int,
primary key (order_id , product_id),
foreign key (product_id) references products(product_id)
);
insert into products (product_id, product_name, price) 
values
(1, 'PC', 10000000.00),
(2, 'Laptop', 20000000.00),
(3, 'Mobile', 7000000.00),
(4, 'Mouse', 200000.00),
(5, 'Keyboard',500000.00);
insert into order_items (order_id, product_id, quantity)
values
(101,1, 1),   
(101,4, 2),   
(102,3, 1),   
(102,5, 2),   
(103,3, 2),   
(104,4, 5),  
(105,2, 1),   
(105,3, 1); 
select p.product_name , sum(o.quantity) as 'sold' from products p join order_items o on p.product_id = o.product_id group by p.product_id, p.product_name; 
select p.product_name , sum(o.quantity * p.price) as "total_price" from products p join order_items o on p.product_id = o.product_id group by p.product_id, p.product_name; 
select p.product_name , sum(o.quantity * p.price) as "total_price" from products p join order_items o on p.product_id = o.product_id group by p.product_id, p.product_name having total_price>5000000; 