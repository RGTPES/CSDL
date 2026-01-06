DROP DATABASE IF EXISTS Session07_1;
create database Session07_1;
use Session07_1;
create table customer(
id int primary key not null,
name varchar(255) not null,
email varchar(255) not null
);
create table orders(
id int ,
customer_id int not null,
order_date date not null,
total_amount decimal(10,2) not null,
primary key (id , customer_id),
foreign key  (customer_id) references customer(id)
);
insert into customer (id, name, email) values
(1, 'nguyen van a', 'a@gmail.com'),
(2, 'nguyen van b', 'b@gmail.com'),
(3, 'nguyen van c', 'c@gmail.com'),
(4, 'nguyen van d', 'd@gmail.com'),
(5, 'nguyen van e', 'e@gmail.com'),
(6, 'nguyen van f', 'f@gmail.com'),
(7, 'nguyen van g', 'g@gmail.com');
insert into orders (id, customer_id, order_date, total_amount) values
(101, 1, '2026-01-01', 1500000.00),
(102, 4, '2026-01-02', 2000000.00),
(103, 7, '2026-01-03', 500000.00),
(104, 3, '2026-01-04', 3000000.00),
(105, 5, '2026-01-05', 1200000.00),
(106, 2, '2026-01-06', 800000.00),
(107, 6, '2026-01-07', 950000.00);

select id,name,email  from customer where id in ( select distinct customer_id from orders);