CREATE DATABASE IF NOT EXISTS quanlybanhang;
USE quanlybanhang;
#3.1
alter table customers
    add column email varchar(100) not null unique;
#3.2
alter table employees
    drop column birthday;
#4
INSERT INTO Customers (customer_name, phone, email, address)
VALUES ('Nguyễn Văn An', '0901234567', 'an@gmail.com', 'Hà Nội'),
       ('Trần Thị Bình', '0902345678', 'binh@gmail.com', 'Hải Phòng'),
       ('Lê Văn Cường', '0903456789', 'cuong@gmail.com', 'Đà Nẵng'),
       ('Phạm Thị Dung', '0904567890', 'dung@gmail.com', 'TP Hồ Chí Minh'),
       ('Hoàng Văn Em', '0905678901', 'em@gmail.com', NULL);

INSERT INTO Products (product_name, price, quantity, category)
VALUES ('Laptop Dell', 15000000.00, 10, 'Điện tử'),
       ('Chuột Logitech', 350000.00, 50, 'Phụ kiện'),
       ('Bàn phím cơ', 1200000.00, 30, 'Phụ kiện'),
       ('Tai nghe Sony', 2500000.00, 20, 'Âm thanh'),
       ('Màn hình Samsung', 5000000.00, 15, 'Điện tử');
INSERT INTO Employees (employee_name, position, salary, revenue)
VALUES ('Nguyễn Thị Hoa', 'Bán hàng', 8000000.00, 0),
       ('Trần Văn Long', 'Quản lý', 15000000.00, 0),
       ('Lê Thị Mai', 'Bán hàng', 7500000.00, 0),
       ('Phạm Văn Nam', 'Kho', 7000000.00, 0),
       ('Hoàng Thị Oanh', 'Kế toán', 9000000.00, 0);
INSERT INTO Orders (customer_id, employee_id, total_amount)
VALUES (1, 1, 0),
       (2, 2, 0),
       (3, 1, 0),
       (4, 3, 0),
       (5, 2, 0);
INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price)
VALUES (1, 1, 1, 15000000.00),
       (1, 2, 2, 350000.00),
       (2, 3, 1, 1200000.00),
       (3, 4, 1, 2500000.00),
       (4, 5, 2, 5000000.00);
#5.1
select * from customers;
#5.2
update products
set product_name='Laptop Dell XPS',price=99.99
where product_id=1;
#5.3
select * from orderdetails;
#6.1
select customer_id,customer_name, (select count(*) from orders where orders.customer_id=customers.customer_id) as total from customers;
#6.2
select employee_id,employee_name,salary from employees;
#6.3
select product_id,product_name,
(select count(*) from orderdetails where products.product_id=orderdetails.product_id ) as total
from products
order by price desc;
SELECT
    c.customer_id,
    c.customer_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
SELECT
    product_id,
    product_name,
    price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products);
SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING total_spent = (
    SELECT MAX(total_per_customer)
    FROM (
        SELECT SUM(total_amount) AS total_per_customer
        FROM Orders
        GROUP BY customer_id
    ) temp
);
create or replace view view_order_list as
select
    o.order_id,
    c.customer_name,
    e.employee_name,
    o.total_amount,
    o.order_date
from orders o
join customers c on o.customer_id = c.customer_id
join employees e on o.employee_id = e.employee_id
order by o.order_date desc;
create or replace view view_order_detail_product as
select
    od.order_detail_id,
    p.product_name,
    od.quantity,
    od.unit_price
from orderdetails od
join products p on od.product_id = p.product_id
order by od.quantity desc;
delimiter $$

create procedure proc_insert_employee (
    in p_employee_name varchar(100),
    in p_position varchar(50),
    in p_salary decimal(10,2),
    out p_employee_id int
)
begin
    insert into employees(employee_name, position, salary, revenue)
    values (p_employee_name, p_position, p_salary, 0);

    set p_employee_id = last_insert_id();
end$$

delimiter ;

delimiter $$

create procedure proc_get_orderdetails (
    in p_order_id int
)
begin
    select *
    from orderdetails
    where order_id = p_order_id;
end$$

delimiter ;

delimiter $$

create trigger trigger_after_insert_order_details
before insert on orderdetails
for each row
begin
    declare current_quantity int;

    select quantity
    into current_quantity
    from products
    where product_id = new.product_id;

    if current_quantity < new.quantity then
        signal sqlstate '45000'
        set message_text = 'so luong san pham trong kho khong du';
    else
        update products
        set quantity = quantity - new.quantity
        where product_id = new.product_id;
    end if;
end$$

delimiter ;
delimiter $$

create procedure proc_insert_order_details (
    in p_order_id int,
    in p_product_id int,
    in p_quantity int,
    in p_unit_price decimal(10,2)
)
begin
    declare order_exists int default 0;

    start transaction;

    select count(*)
    into order_exists
    from orders
    where order_id = p_order_id;

    if order_exists = 0 then
        rollback;
        signal sqlstate '45000'
        set message_text = 'khong ton tai ma hoa don';
    end if;

    insert into orderdetails(order_id, product_id, quantity, unit_price)
    values (p_order_id, p_product_id, p_quantity, p_unit_price);

    update orders
    set total_amount = total_amount + (p_quantity * p_unit_price)
    where order_id = p_order_id;

    commit;
end$$

delimiter ;
delimiter $$

create procedure proc_insert_order_details (
    in p_order_id int,
    in p_product_id int,
    in p_quantity int,
    in p_unit_price decimal(10,2)
)
begin
    declare order_exists int default 0;

    start transaction;

    select count(*)
    into order_exists
    from orders
    where order_id = p_order_id;

    if order_exists = 0 then
        rollback;
        signal sqlstate '45000'
        set message_text = 'khong ton tai ma hoa don';
    end if;

    insert into orderdetails(order_id, product_id, quantity, unit_price)
    values (p_order_id, p_product_id, p_quantity, p_unit_price);

    update orders
    set total_amount = total_amount + (p_quantity * p_unit_price)
    where order_id = p_order_id;

    commit;
end$$

delimiter ;