drop database if exists Session13_1;
create database Session13_1;
use Session13_1;
create table users (
user_id int auto_increment primary key,
username varchar(50) unique not null,
email varchar(50) unique not null,
created_at date ,
follower_count int default 0,
post_count int default 0
);
create table posts (
post_id int auto_increment primary key,
user_id int not null,
content text,
created_at datetime,
like_count int default 0,
foreign key (user_id) references users(user_id)
on delete cascade
on update cascade
);
INSERT INTO users (username, email, created_at) VALUES

('alice', 'alice@example.com', '2025-01-01'),

('bob', 'bob@example.com', '2025-01-02'),

('charlie', 'charlie@example.com', '2025-01-03');

delimiter $$
drop  trigger if exists trg_posts_after_insert $$
create  trigger  trg_posts_after_insert 
after insert on  posts for each row
begin
 update users set post_count = post_count + 1 where user_id=new.user_id;
 end $$
 
 drop trigger if exists trg_posts_after_delete $$
 create trigger trg_posts_after_delete
 after delete on posts for each row
 begin 
update users set post_count = if(post_count>0, post_count-1,0) where user_id = old.user_id;
 end $$
 delimiter ;
 INSERT INTO posts (user_id, content, created_at) VALUES

(1, 'Hello world from Alice!', '2025-01-10 10:00:00'),

(1, 'Second post by Alice', '2025-01-10 12:00:00'),

(2, 'Bob first post', '2025-01-11 09:00:00'),

(3, 'Charlie sharing thoughts', '2025-01-12 15:00:00');

select * from users;

delete from posts where post_id = 2;

select * from users;