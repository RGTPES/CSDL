DROP DATABASE IF EXISTS Session05_4;
CREATE DATABASE Session05_4;
USE Session05_4;
create table products(
product_id int 	,
product_name varchar(25),
price decimal(10,2),
stock int,
sold_quantity int,
status enum('active' , 'inactive')
);
insert into products(product_id , product_name , price , stock ,sold_quantity , status)
values (1,"PC",10000000,2,5,'active'),(2,"LapTop",20000000,5,4,'inactive'),(3,"Mobile",30000,12,3,'active'),(4,"Mouse",150000,50,20,'active'), (5,"Keyboard",350000,30,15,'active'), (6,"Monitor",2500000,10,8,'active'), (7,"Headphone",500000,20,12,'active'), (8,"Webcam",700000,15,5,'inactive'), (9,"Speaker",1200000,25,18,'active'), (10,"Tablet",8000000,8,7,'active'), (11,"SmartWatch",4500000,12,9,'active'), (12,"Printer",3000000,5,2,'inactive'), (13,"Router",900000,15,6,'active'), (14,"USB",200000,100,50,'active'), (15,"HDD",1000000,20,10,'active'), (16,"SSD",1500000,20,15,'active'), (17,"VGA",15000000,3,4,'active'), (18,"Mainboard",4000000,10,5,'active'), (19,"CPU",7000000,10,12,'active'), (20,"Case",1000000,15,8,'inactive');
select * from products
where status = 'active'
order by sold_quantity desc
limit 5;

select * from products
where status = 'active'
order by sold_quantity desc
limit 5 offset 5;

select * from products
where status = 'active'
order by sold_quantity desc
limit 5 offset 10;


