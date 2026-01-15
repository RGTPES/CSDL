use session14_1;
alter table users
add column following_count int default 0,
add column followers_count int default 0;
create table followers(
follower_id int not null,
followed_id int not null,
primary key (follower_id, followed_id),
foreign key (follower_id) references users(user_id)
on update cascade
on delete cascade,
foreign key (followed_id) references users(user_id)
on update cascade
on delete cascade
) ;
create table follow_log (
log_id int auto_increment primary key,
follower_id int,
followed_id int,
error_message varchar(255) not null,
logged_at datetime default current_timestamp()
) ;
delimiter $$
drop procedure if exists sp_follow_user $$
create procedure sp_follow_user(in p_follower_id int, in p_followed_id int)
sp: begin
declare v_exists_follower int default 0;
declare v_exists_followed int default 0;
declare v_already_followed int default 0;
declare v_err varchar(255);
declare exit handler for sqlexception
begin
rollback;
insert into follow_log(follower_id, followed_id, error_message)
values (p_follower_id, p_followed_id, 'sql exception');
end;
start transaction;
select count(*) into v_exists_follower from users where user_id = p_follower_id;
select count(*) into v_exists_followed from users where user_id = p_followed_id;
if v_exists_follower = 0 or v_exists_followed = 0 then
set v_err = 'user not found';
insert into follow_log(follower_id, followed_id, error_message)
values (p_follower_id, p_followed_id, v_err);
rollback;
leave sp;
end if;
if p_follower_id = p_followed_id then
set v_err = 'cannot follow yourself';
insert into follow_log(follower_id, followed_id, error_message)
values (p_follower_id, p_followed_id, v_err);
rollback;
leave sp;
end if;
select count(*) into v_already_followed
from followers
where follower_id = p_follower_id and followed_id = p_followed_id;
if v_already_followed > 0 then
set v_err = 'already followed';
insert into follow_log(follower_id, followed_id, error_message)
values (p_follower_id, p_followed_id, v_err);
rollback;
leave sp;
end if;
insert into followers(follower_id, followed_id)
values (p_follower_id, p_followed_id);
update users set following_count = following_count + 1 where user_id = p_follower_id;
update users set followers_count = followers_count + 1 where user_id = p_followed_id;
commit;
end $$
delimiter ;
call sp_follow_user(2, 1);
call sp_follow_user(2, 1);
call sp_follow_user(1, 1);
call sp_follow_user(999, 1);
select * from users;
select * from followers;