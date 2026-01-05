DROP DATABASE IF EXISTS Session06_2;
create database Session06_2;
use Session06_2;
create table Customers (
customer_id int ,
full_name varchar(255),
city varchar(255)
);
create table Orders(
order_id int ,
customer_id int ,
order_date date,
total_amount decimal (10,2),
status enum ('pending' , 'completed','cancelled')
);
insert into Customers ( customer_id , full_name , city)
values (1,"Nguyen Van A","Ha Noi"),(2,"Nguyen Van B","Ha Noi"),(3,"Nguyen Van C","TP.HCM"),(4,"Nguyen Van D" , "Ha Noi"),(5,"Nguyen Van E" , "TP.HCM");
insert into Orders (order_id, customer_id, order_date, total_amount,status)
values
(1,1,'2026-12-25', 1500000,'pending'),
(2,1,'2026-12-25', 3000000,'completed'),
(3,2,'2026-12-25', 2000000,'pending'),
(4,5,'2026-12-25', 5000000,'completed'),
(5,3,'2026-12-25', 1000000,'cancelled');
select c.customer_id , c.full_name , sum(o.total_amount) as 'total_spent' from Customers c join Orders o on c.customer_id = o.customer_id group by c.customer_id, c.full_name;
select c.customer_id , c.full_name , max(o.total_amount) as 'total_spent_max' from Customers c join Orders o on c.customer_id = o.customer_id group by c.customer_id, c.full_name ;
select c.customer_id , c.full_name , max(o.total_amount) as 'total_spent_max_order' from Customers c join Orders o on c.customer_id = o.customer_id group by c.customer_id, c.full_name order by total_spent_max_order desc;