use Session13_1;
create table likes (
like_id int auto_increment primary key,
user_id int ,
post_id int ,
liked_at datetime ,
foreign key (user_id) references users(user_id),
foreign key (post_id) references posts(post_id)
on delete cascade
on update cascade
);

 

INSERT INTO likes (user_id, post_id, liked_at) VALUES

(2, 1, '2025-01-10 11:00:00'),

(3, 1, '2025-01-10 13:00:00'),

(1, 3, '2025-01-11 10:00:00'),

(3, 4, '2025-01-12 16:00:00');
delimiter $$
drop trigger if exists trg_likes_after_insert $$
create trigger trg_likes_after_insert after insert on likes
for each row
begin 
update posts set like_count = like_count + 1 where post_id = new.post_id;
end $$
drop trigger if exists trg_likes_after_delete $$
create trigger trg_likes_after_delete after delete on likes
for each row
begin 
update posts set like_count =  if(like_count > 0 , like_count-1,0) where post_id = old.post_id;
end $$
create or replace view user_statistics as
select u.user_id, u.username, u.post_count, coalesce(sum(p.like_count), 0) as total_likes
from users u
join posts p on p.user_id = u.user_id
group by u.user_id, u.username, u.post_count;

insert into likes (user_id, post_id, liked_at) values (2, 4, now());
select * from posts where post_id = 4;
select * from user_statistics;
delete from likes where user_id = 2 and post_id = 4;
select * from posts where post_id = 4;
select * from user_statistics;
