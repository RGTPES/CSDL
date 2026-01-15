drop database if exists session14_1;
create database session14_1;
use session14_1;
create table users(
  user_id int primary key auto_increment,
  username varchar(50) not null,
  posts_count int default 0
);
create table posts(
  post_id int auto_increment not null,
  user_id int not null,
  content text not null,
  created_at datetime default current_timestamp(),
  primary key(post_id, user_id),
  foreign key (user_id) references users(user_id)
    on update cascade
    on delete cascade
);
insert into users(username, posts_count)
values ('john', 0), ('tom', 0);
start transaction;
insert into posts(user_id, content)
values (1, 'bai viet cua john');
update users set posts_count = posts_count + 1 where user_id = 1;
commit;
select * from users;
select * from posts;
start transaction;
insert into posts(user_id, content)
values (999, 'loi');
update users set posts_count = posts_count + 1 where user_id = 999;
rollback;
select * from users;
select * from posts;
