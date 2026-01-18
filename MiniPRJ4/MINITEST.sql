drop database if exists miniPRJ4Test;
create database miniPRJ4Test;
use miniPRJ4Test;
create table users (
user_id int auto_increment primary key,
username varchar(50) not null unique,
password varchar(255) not null,
email varchar(100) not null unique,
created_at datetime default current_timestamp
);
create table posts (
post_id int auto_increment primary key,
user_id int not null,
content text not null,
created_at datetime default current_timestamp,
constraint fk_posts_users
foreign key (user_id) references users(user_id)
on delete cascade
on update cascade
);
create table comments (
comment_id int auto_increment primary key,
post_id int not null,
user_id int not null,
content text not null,
created_at datetime default current_timestamp,
constraint fk_comments_posts
foreign key (post_id) references posts(post_id)
on delete cascade
on update cascade,
constraint fk_comments_users
foreign key (user_id) references users(user_id)
on delete cascade
on update cascade
);
create table likes (
user_id int not null,
post_id int not null,
created_at datetime default current_timestamp,
primary key (user_id, post_id),
constraint fk_likes_users
foreign key (user_id) references users(user_id)
on delete cascade
on update cascade,
constraint fk_likes_posts
foreign key (post_id) references posts(post_id)
on delete cascade
on update cascade
);
create table friends (
user_id int not null,
friend_id int not null,
status varchar(20) default 'pending',
created_at datetime default current_timestamp,
primary key (user_id, friend_id),
constraint chk_friends_status
check (status in ('pending', 'accepted')),
constraint fk_friends_user
foreign key (user_id) references users(user_id)
on delete cascade
on update cascade,
constraint fk_friends_friend
foreign key (friend_id) references users(user_id)
on delete cascade
on update cascade
) ;