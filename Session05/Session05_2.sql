DROP DATABASE IF EXISTS Session05_2;
CREATE DATABASE Session05_2;
USE Session05_2;
create table customers(
customer_id int ,
full_name varchar(255),
email varchar(255),
city varchar(255),
status enum('active' , 'inactive')
);
insert into customers(customer_id , full_name , email , city , status)
values (1,"Nguyen Van A","NVA@gmail.com","Ha Noi",'active'),(2,"Nguyen Van B","NVB@gmail.com","Ha Noi",'inactive'),(3,"Nguyen Van C","NVC@gmail.com","TP.HCM",'active');
select * from customers;
select * from customers
where city = "TP.HCM";
select * from customers
where city = "Ha Noi" and status = 'active';
select * from customers
order by full_name ;


