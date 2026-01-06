DROP DATABASE IF EXISTS Session07_2;
create database Session07_2;
use Session07_2;
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
select name from products where id in (select distinct product_id from order_items );