DROP DATABASE IF EXISTS Session06_1;
create database Session06_1;
use Session06_1;
create table Customers (
customer_id int ,
full_name varchar(255),
city varchar(255)
);
create table Orders(
order_id int ,
customer_id int ,
order_date date,
status enum ('pending' , 'completed','cancelled')
);
insert into Customers ( customer_id , full_name , city)
values (1,"Nguyen Van A","Ha Noi"),(2,"Nguyen Van B","Ha Noi"),(3,"Nguyen Van C","TP.HCM"),(4,"Nguyen Van D" , "Ha Noi"),(5,"Nguyen Van E" , "TP.HCM");
insert into Orders (order_id, customer_id, order_date, status)
values
(1,1,'2026-12-25','pending'),
(2,1,'2026-12-25','completed'),
(3,2,'2026-12-25','pending'),
(4,5,'2026-12-25','completed'),
(5,3,'2026-12-25','cancelled');
select o.order_id,c.full_name   from  Customers c join Orders o  on o.customer_id = c.customer_id ;
select
c.customer_id,
c.full_name,
COUNT(o.order_id) as total_orders
from Customers c
join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.full_name;
select 
c.customer_id,
c.full_name,
COUNT(o.order_id) as total_orders
from Customers c
join Orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.full_name
having COUNT(o.order_id) >= 1;
