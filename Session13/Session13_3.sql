use Session13_1;
delimiter $$
drop trigger if exists trg_likes_before_insert $$
create trigger trg_likes_before_insert
before insert on likes
for each row
begin
declare post_owner_id int;
select user_id
into post_owner_id
from posts
where post_id = new.post_id;
if new.user_id = post_owner_id then
signal sqlstate '45000' 
set message_text = 'khong duoc like bai viet cua chinh minh';
end if;
end $$

drop trigger if exists trg_likes_after_update $$
create trigger  trg_likes_after_update after update on likes
for each row
begin
 if old.post_id <> new.post_id then
update posts
set like_count = if(like_count > 0, like_count - 1, 0)
where post_id = old.post_id;
update posts
set like_count = like_count + 1
where post_id = new.post_id;
end if;
end $$
delimiter ;
insert into likes (user_id, post_id, liked_at) values (2, 1, now());
select * from posts where post_id = 1;
select * from user_statistics;

select * from likes;
update likes
set post_id = 4
where user_id = 2 and post_id = 1;
select * from posts where post_id in (1, 4);
select * from user_statistics;

delete from likes where user_id = 2 and post_id = 4;
select * from posts where post_id = 4;
select * from user_statistics;

select * from posts order by post_id;
select * from user_statistics order by user_id;



