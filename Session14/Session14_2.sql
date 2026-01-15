use Session14_1;
alter table posts
  add column likes_count int default 0;
alter table posts
  add unique key uq_posts_post_id (post_id);
drop table if exists likes;
create table likes(
like_id int auto_increment primary key,
post_id int not null,
user_id int not null,
unique key unique_like (post_id, user_id),
foreign key (user_id) references users(user_id)
on update cascade
 on delete cascade,
foreign key (post_id) references posts(post_id)
on update cascade
on delete cascade
) ;
insert into posts(user_id, content) values (1, 'post test like');
start transaction;
insert into likes(post_id, user_id)
values (1, 2);
update posts
set likes_count = likes_count + 1
where post_id = 1;
commit;
select * from likes where post_id = 1 and user_id = 2;
select post_id, likes_count from posts where post_id = 1;
start transaction;
insert into likes(post_id, user_id)
values (1, 2);
update posts
set likes_count = likes_count + 1
where post_id = 1;
rollback;
select * from likes where post_id = 1 and user_id = 2;
select post_id, likes_count from posts where post_id = 1;
