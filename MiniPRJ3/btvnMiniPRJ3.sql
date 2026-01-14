use social_network_mini;
-- bai 1
insert into users (username, password, email, created_at) values
('anh.mai',   'pass123', 'anh.mai@gmail.com',   '2026-01-01 09:10:00');
select * from users;
-- bai 2
create or replace view  vw_public_users  as
select user_id, username, created_at 
from users;
select * from vw_public_users;
-- khi truy van thang tt vo users thi minh co the thay doi tren table 
-- con o view thi ko the thay doi
-- loi ich cua view la ko the thay doi tt
-- bai 3
create index id_Users on Users(username);
select *
from users
where username = 'chi.le' ;
-- bai 4
delimiter $$
drop procedure if exists sp_create_post;
create procedure sp_create_post(in p_user_id int , in p_content text)
begin
    if exists (select 1 from users where user_id = p_user_id) 
    then
 insert into posts(user_id, content)
values (p_user_id, p_content);

 select u.username, p.content	from users u
join posts p on u.user_id = p.user_id	
where p.user_id = p_user_id	
order by p.post_id desc	
limit 1;
else
select 'User không tồn tại, không thể đăng bài' as message;
    end if;

end $$
delimiter ;
call sp_create_post(1 , "Hoc" ) ;
-- bai 5
create or replace view vw_recent_posts as    
select post_id ,  content from posts 
where created_at >= now() - interval 7 day;
select * from vw_recent_posts;
-- bai 6
create index idex_User_id  on Posts(user_id  ,  created_at);
select content from  Posts 
where user_id = 1 
order by created_at desc;
-- bai 7
  delimiter $$
 drop procedure if exists sp_count_posts $$
 create procedure sp_count_posts( in p_user_id int , out p_total int)
 begin
 select count(*)
 into p_total
 from posts 
 where user_id = p_user_id ;
 end $$
 delimiter ;
 call sp_count_posts(1 , @p_total);
 select @p_total as total_posts;
 -- bai 8 
drop view if exists vw_active_users;
create view vw_active_users as
select u.user_id, u.username, u.created_at
from users u
where exists (
  select 1
  from posts p
  where p.user_id = u.user_id
and p.created_at >= now() - interval 30 day
)
with check option;

-- bai 9 
delimiter $$

drop procedure if exists sp_add_friend $$
create procedure sp_add_friend(in p_user_id int, in p_friend_id int)
begin
  if p_user_id = p_friend_id then
signal sqlstate '45000'
	set message_text = 'không thể kết bạn với chính mình';  else
insert into friends(user_id, friend_id, status)
values (p_user_id, p_friend_id, 'pending');
end if;
end $$
delimiter ;
call sp_add_friend(2, 3);
-- bai 10
delimiter $$
drop procedure if exists sp_suggest_friends $$
create procedure sp_suggest_friends(in p_user_id int, inout p_limit int)
begin
  declare v_count int default 0;
  drop temporary table if exists tmp_suggest;
  create temporary table tmp_suggest (
    user_id int,
    username varchar(50)
  );
  insert into tmp_suggest(user_id, username)
select u.user_id, u.username
  from users u
  where u.user_id <> p_user_id
and not exists (
select 1 from friends f
	where (f.user_id = p_user_id and f.friend_id = u.user_id)
or (f.user_id = u.user_id and f.friend_id = p_user_id)
    )
  order by u.user_id;
suggest_loop: while v_count < p_limit do
set v_count = v_count + 1;
if (select count(*) from tmp_suggest) < v_count then
	leave suggest_loop;
end if;
  end while suggest_loop;
select * from tmp_suggest limit p_limit;
end $$
delimiter ;
set @lim = 3;
call sp_suggest_friends(1, @lim);
create index idx_likes_post_id on likes(post_id);
-- bai 11
delimiter $$
drop procedure if exists sp_like_post $$
create procedure sp_like_post(in p_user_id int, in p_post_id int)
begin
  declare v_exists int default 0;
select count(*) into v_exists
from likes
where user_id = p_user_id and post_id = p_post_id;
if v_exists > 0 then
set message_text = 'user đã thích post này rồi';
else
insert into likes(user_id, post_id) values (p_user_id, p_post_id);
end if;
end $$
delimiter ;
call sp_like_post(1, 1);
call sp_like_post(2, 1);
call sp_like_post(3, 2);

