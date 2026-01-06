DROP DATABASE IF EXISTS Session07_3;
create database Session07_3;
use Session07_3;
create table products(
    id int primary key,
    name varchar(255),
    price decimal(10,2)
    );
    create table order_items(
    order_id int ,
    product_id int ,
    quantity int 
    );
    
insert into products (id, name, price) values
(1, 'tai nghe bluetooth', 500000.00),
(2, 'chuot gaming', 350000.00),
(3, 'ban phim co', 1200000.00),
(4, 'man hinh 24 inch', 3000000.00),
(5, 'ssd 1tb', 2200000.00),
(6, 'loa bluetooth', 900000.00),
(7, 'webcam full hd', 750000.00);
insert into order_items (order_id, product_id, quantity) values
(1001, 1, 2),
(1001, 3, 1),
(1002, 2, 1),
(1003, 5, 1),
(1004, 6, 3),
(1005, 1, 1),
(1006, 4, 2);
select t.order_id,t.total_amount from ( select o.order_id, sum(p.price * o.quantity) as "total_amount" from order_items o , products p where o.product_id = p.id group by o.order_id) as t  where t.total_amount > (select avg(x.total_amount) from ( select sum(o.quantity * p.price) as total_amount from order_items o , products p 	where o.product_id = p.id group by o.order_id)as x);