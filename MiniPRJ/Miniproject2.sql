drop database if exists miniproject2;
create database miniproject2;
use miniproject2;


CREATE TABLE guests (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_name VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type VARCHAR(50),
    price_per_day DECIMAL(10,0)
);

CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

INSERT INTO guests (guest_name, phone) VALUES
('Nguyễn Văn An', '0901111111'),
('Trần Thị Bình', '0902222222'),
('Lê Văn Cường', '0903333333'),
('Phạm Thị Dung', '0904444444'),
('Hoàng Văn Em', '0905555555');

INSERT INTO rooms (room_type, price_per_day) VALUES
('Standard', 500000),
('Standard', 500000),
('Deluxe', 800000),
('Deluxe', 800000),
('VIP', 1500000),
('VIP', 2000000);

INSERT INTO bookings (guest_id, room_id, check_in, check_out) VALUES
(1, 1, '2024-01-10', '2024-01-12'),
(1, 3, '2024-03-05', '2024-03-10'),
(2, 2, '2024-02-01', '2024-02-03'),
(2, 5, '2024-04-15', '2024-04-18'),
(3, 4, '2023-12-20', '2023-12-25'), 
(3, 6, '2024-05-01', '2024-05-06'),
(4, 1, '2024-06-10', '2024-06-11');

-- phan1
select guest_name, phone from guests;

select room_type from rooms;

select room_type, price_per_day from rooms order by price_per_day asc;

select room_type, price_per_day from rooms where price_per_day > 1000000;

select * from bookings where year(check_in) = 2024;

select room_type, count(*) as so_luong_phong from rooms group by room_type;

-- phan2
select g.guest_name, r.room_type, b.check_in from bookings b 
join guests g on b.guest_id = g.guest_id
join rooms r on b.room_id  = r.room_id
order by b.check_in;

select g.guest_id, g.guest_name, count(b.booking_id) as so_lan_dat
from guests g
left join bookings b on g.guest_id = b.guest_id
group by g.guest_id, g.guest_name;

select b.booking_id, r.room_type, datediff(b.check_out, b.check_in) as so_ngay_o, r.price_per_day, datediff(b.check_out, b.check_in) * r.price_per_day as doanh_thu
from bookings b
join rooms r on b.room_id = r.room_id;

select r.room_type, sum(datediff(check_out, check_in) * r.price_per_day) as tong_doanh_thu
from bookings b
join rooms r on b.room_id=r.room_id
group by r.room_type;

select g.guest_name, count(b.booking_id) as so_lan_dat
from guests g
join bookings b on g.guest_id = b.guest_id
group by g.guest_name
having count(b.booking_id) >= 2;


select r.room_type, count(*) as so_luot_dat
from bookings b
join rooms r on b.room_id = r.room_id
group by r.room_type
order by so_luot_dat desc
limit 1;

-- phan3
select room_type, price_per_day
from rooms
where price_per_day > (select avg(price_per_day) from rooms);

select guest_name, phone
from guests 
where guest_id not in ( select guest_id from bookings);