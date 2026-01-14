use Session13_1;
create table post_history (
history_id int auto_increment primary key,
post_id int not null,
old_content text,
new_content text,
changed_at datetime,
changed_by_user_id int,
foreign key (post_id) references posts(post_id)
on delete cascade
);
delimiter $$
drop trigger if exists trg_posts_before_update_history $$
create trigger trg_posts_before_update_history
before update on posts
for each row
begin
if not (new.content <=> old.content) then
insert into post_history (
post_id,
old_content,
new_content,
changed_at,
changed_by_user_id
)
values (
old.post_id,
old.content,
new.content,
now(),
old.user_id
);
end if;
end $$
delimiter ;
update posts
set content = 'noi dung moi lan 1'
where post_id = 1;
update posts
set content = 'noi dung moi lan 2'
where post_id = 1;
select *
from post_history
order by changed_at desc;
insert into likes (user_id, post_id, liked_at)
values (2, 1, now());
select post_id, like_count
from posts
where post_id = 1;
update posts
set content = 'noi dung moi lan 3'
where post_id = 1;
select post_id, content, like_count
from posts
where post_id = 1;
delete from likes
where user_id = 2 and post_id = 1;
select post_id, like_count
from posts
where post_id = 1;
