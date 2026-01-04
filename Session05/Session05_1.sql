DROP DATABASE IF EXISTS Session05_1;
CREATE DATABASE Session05_1;
USE Session05_1;
create table products(
product_id int 	,
product_name varchar(25),
price decimal(10,2),
stock int,
status enum('active' , 'inactive')
);
insert into products(product_id , product_name , price , stock , status)
values (1,"PC",10000000,3,'active'),(2,"LapTop",20000000,5,'inactive'),(3,"Mobile",30000,12,'active');
select * from products;
select * from products
where status = 'active';
select * from products
where price> 1000000;
select * from products
where status = 'active'
order by price ;
