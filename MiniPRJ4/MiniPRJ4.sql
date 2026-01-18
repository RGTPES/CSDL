drop database if exists social_network_exam;
create database social_network_exam;
use social_network_exam;

create table users (
    user_id int auto_increment primary key,
    username varchar(50) unique not null,
    password varchar(255) not null,
    email varchar(100) unique not null,
    created_at datetime default current_timestamp
) engine=innodb;

create table posts (
    post_id int auto_increment primary key,
    user_id int not null,
    content text not null,
    like_count int default 0,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id)
        on delete cascade
        on update cascade
) engine=innodb;

create table comments (
    comment_id int auto_increment primary key,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id)
        on delete cascade
        on update cascade,
    foreign key (user_id) references users(user_id)
        on delete cascade
        on update cascade
) engine=innodb;

create table likes (
    user_id int,
    post_id int,
    created_at datetime default current_timestamp,
    primary key (user_id, post_id),
    foreign key (user_id) references users(user_id)
        on delete cascade
        on update cascade,
    foreign key (post_id) references posts(post_id)
        on delete cascade
        on update cascade
) engine=innodb;

create table friends (
    user_id int,
    friend_id int,
    status varchar(20) default 'pending' check (status in ('pending','accepted')),
    created_at datetime default current_timestamp,
    primary key (user_id, friend_id),
    foreign key (user_id) references users(user_id)
        on delete cascade
        on update cascade,
    foreign key (friend_id) references users(user_id)
        on delete cascade
        on update cascade
) engine=innodb;

create table user_log (
    log_id int auto_increment primary key,
    user_id int,
    action varchar(50),
    log_time datetime default current_timestamp
) engine=innodb;

create table post_log (
    log_id int auto_increment primary key,
    post_id int,
    action varchar(50),
    log_time datetime default current_timestamp
) engine=innodb;

create table like_log (
    log_id int auto_increment primary key,
    user_id int,
    post_id int,
    action varchar(50),
    log_time datetime default current_timestamp
) engine=innodb;

create table friend_log (
    log_id int auto_increment primary key,
    user_id int,
    friend_id int,
    action varchar(50),
    log_time datetime default current_timestamp
) engine=innodb;

create table delete_log (
    log_id int auto_increment primary key,
    post_id int,
    deleted_by int,
    deleted_at datetime default current_timestamp
) engine=innodb;

delimiter $$

create procedure sp_register_user(
    in p_username varchar(50),
    in p_password varchar(255),
    in p_email varchar(100)
)
begin
    if p_username is null or length(trim(p_username)) = 0 then
        signal sqlstate '45000' set message_text = 'username cannot be empty';
    end if;

    if p_password is null or length(trim(p_password)) = 0 then
        signal sqlstate '45000' set message_text = 'password cannot be empty';
    end if;

    if p_email is null or length(trim(p_email)) = 0 then
        signal sqlstate '45000' set message_text = 'email cannot be empty';
    end if;

    if exists (select 1 from users where username = p_username) then
        signal sqlstate '45000' set message_text = 'username already exists';
    end if;

    if exists (select 1 from users where email = p_email) then
        signal sqlstate '45000' set message_text = 'email already exists';
    end if;

    insert into users(username, password, email)
    values (p_username, p_password, p_email);
end$$

create trigger trg_user_register
after insert on users
for each row
begin
    insert into user_log(user_id, action)
    values (new.user_id, 'register');
end$$

create procedure sp_create_post(
    in p_user_id int,
    in p_content text
)
begin
    if not exists (select 1 from users where user_id = p_user_id) then
        signal sqlstate '45000' set message_text = 'user not found';
    end if;

    if p_content is null or length(trim(p_content)) = 0 then
        signal sqlstate '45000' set message_text = 'content cannot be empty';
    end if;

    insert into posts(user_id, content)
    values (p_user_id, p_content);
end$$

create trigger trg_post_create
after insert on posts
for each row
begin
    insert into post_log(post_id, action)
    values (new.post_id, 'create_post');
end$$

create procedure sp_add_comment(
    in p_post_id int,
    in p_user_id int,
    in p_content text
)
begin
    if not exists (select 1 from posts where post_id = p_post_id) then
        signal sqlstate '45000' set message_text = 'post not found';
    end if;

    if not exists (select 1 from users where user_id = p_user_id) then
        signal sqlstate '45000' set message_text = 'user not found';
    end if;

    if p_content is null or length(trim(p_content)) = 0 then
        signal sqlstate '45000' set message_text = 'comment content cannot be empty';
    end if;

    insert into comments(post_id, user_id, content)
    values (p_post_id, p_user_id, p_content);
end$$

create procedure sp_like_post(
    in p_user_id int,
    in p_post_id int
)
begin
    declare v_owner int;

    if not exists (select 1 from users where user_id = p_user_id) then
        signal sqlstate '45000' set message_text = 'user not found';
    end if;

    if not exists (select 1 from posts where post_id = p_post_id) then
        signal sqlstate '45000' set message_text = 'post not found';
    end if;

    select user_id into v_owner from posts where post_id = p_post_id;

    if v_owner = p_user_id then
        signal sqlstate '45000' set message_text = 'cannot like your own post';
    end if;

    insert into likes(user_id, post_id)
    values (p_user_id, p_post_id);
end$$

create procedure sp_unlike_post(
    in p_user_id int,
    in p_post_id int
)
begin
    if not exists (select 1 from likes where user_id = p_user_id and post_id = p_post_id) then
        signal sqlstate '45000' set message_text = 'like not found';
    end if;

    delete from likes
    where user_id = p_user_id and post_id = p_post_id;
end$$

create trigger trg_like_insert
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;

    insert into like_log(user_id, post_id, action)
    values (new.user_id, new.post_id, 'like');
end$$

create trigger trg_like_delete
after delete on likes
for each row
begin
    update posts
    set like_count = case when like_count > 0 then like_count - 1 else 0 end
    where post_id = old.post_id;

    insert into like_log(user_id, post_id, action)
    values (old.user_id, old.post_id, 'unlike');
end$$

create procedure sp_send_friend_request(
    in p_sender int,
    in p_receiver int
)
begin
    if not exists (select 1 from users where user_id = p_sender) then
        signal sqlstate '45000' set message_text = 'sender not found';
    end if;

    if not exists (select 1 from users where user_id = p_receiver) then
        signal sqlstate '45000' set message_text = 'receiver not found';
    end if;

    if p_sender = p_receiver then
        signal sqlstate '45000' set message_text = 'cannot send request to yourself';
    end if;

    if exists (
        select 1 from friends
        where (user_id = p_sender and friend_id = p_receiver)
           or (user_id = p_receiver and friend_id = p_sender)
    ) then
        signal sqlstate '45000' set message_text = 'friend request or relation already exists';
    end if;

    insert into friends(user_id, friend_id, status)
    values (p_sender, p_receiver, 'pending');
end$$

create trigger trg_friend_insert
after insert on friends
for each row
begin
    insert into friend_log(user_id, friend_id, action)
    values (new.user_id, new.friend_id, concat('request_', new.status));
end$$

create trigger trg_friend_accept_sym
after update on friends
for each row
begin
    if old.status = 'pending' and new.status = 'accepted' then
        insert ignore into friends(user_id, friend_id, status)
        values (new.friend_id, new.user_id, 'accepted');

        insert into friend_log(user_id, friend_id, action)
        values (new.user_id, new.friend_id, 'accepted');
    end if;
end$$

create procedure sp_accept_friend_request(
    in p_sender int,
    in p_receiver int
)
begin
    start transaction;

    if not exists (
        select 1 from friends
        where user_id = p_sender and friend_id = p_receiver and status = 'pending'
    ) then
        rollback;
        signal sqlstate '45000' set message_text = 'pending request not found';
    end if;

    update friends
    set status = 'accepted'
    where user_id = p_sender and friend_id = p_receiver;

    commit;
end$$

create procedure sp_remove_friend(
    in p_user1 int,
    in p_user2 int
)
begin
    start transaction;

    if not exists (
        select 1 from friends
        where (user_id = p_user1 and friend_id = p_user2)
           or (user_id = p_user2 and friend_id = p_user1)
    ) then
        rollback;
        signal sqlstate '45000' set message_text = 'friend relation not found';
    end if;

    delete from friends
    where (user_id = p_user1 and friend_id = p_user2)
       or (user_id = p_user2 and friend_id = p_user1);

    insert into friend_log(user_id, friend_id, action)
    values (p_user1, p_user2, 'removed');

    commit;
end$$

create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    start transaction;

    if not exists (select 1 from posts where post_id = p_post_id) then
        rollback;
        signal sqlstate '45000' set message_text = 'post not found';
    end if;

    if not exists (select 1 from posts where post_id = p_post_id and user_id = p_user_id) then
        rollback;
        signal sqlstate '45000' set message_text = 'not post owner';
    end if;

    delete from likes where post_id = p_post_id;
    delete from comments where post_id = p_post_id;
    delete from posts where post_id = p_post_id;

    insert into delete_log(post_id, deleted_by)
    values (p_post_id, p_user_id);

    commit;
end$$

create procedure sp_delete_user(
    in p_user_id int
)
begin
    start transaction;

    if not exists (select 1 from users where user_id = p_user_id) then
        rollback;
        signal sqlstate '45000' set message_text = 'user not found';
    end if;

    delete from friends where user_id = p_user_id or friend_id = p_user_id;
    delete from likes where user_id = p_user_id;
    delete from comments where user_id = p_user_id;
    delete from posts where user_id = p_user_id;
    delete from users where user_id = p_user_id;

    commit;
end$$

delimiter ;

call sp_register_user('alice','123','alice@gmail.com');
call sp_register_user('bob','123','bob@gmail.com');
call sp_register_user('carol','123','carol@gmail.com');
call sp_register_user('david','123','david@gmail.com');

call sp_create_post(1,'post 1 from alice');
call sp_create_post(1,'post 2 from alice');
call sp_create_post(2,'post 1 from bob');
call sp_create_post(3,'post 1 from carol');
call sp_create_post(4,'post 1 from david');

call sp_add_comment(1,2,'bob comment');
call sp_add_comment(1,3,'carol comment');

call sp_like_post(2,1);
call sp_like_post(3,1);
call sp_like_post(4,1);
call sp_like_post(1,3);

call sp_unlike_post(3,1);

call sp_send_friend_request(1,2);
call sp_send_friend_request(3,4);

-- call sp_accept_friend_request(1,2);

select * from users;
select * from posts;
select * from comments;
select * from likes;
select * from friends;

select * from user_log;
select * from post_log;
select * from like_log;
select * from friend_log;
select * from delete_log;

call sp_delete_post(1,1);

select * from posts;
select * from comments;
select * from likes;
select * from delete_log;

call sp_delete_user(4);

select * from users;
select * from posts;
select * from friends;