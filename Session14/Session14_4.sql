use session14_1;
alter table posts
  add column comments_count int default 0;
  create table comments(
	comment_id int auto_increment,
	post_id int not null,
	user_id int not null,
	content text not null,
	created_at datetime default current_timestamp(),
	primary key(comment_id, post_id, user_id),
	foreign key (user_id) references users(user_id)
		on update cascade
		on delete cascade,
	foreign key (post_id) references posts(post_id)
		on update cascade
		on delete cascade
);
delimiter $$
drop procedure if exists sp_post_comment $$
create procedure sp_post_comment(in p_post_id int, in p_user_id int, in p_content text)
proc: begin
  declare exit handler for sqlexception
  begin
    rollback;
  end;
  start transaction;
  insert into comments(post_id, user_id, content)
  values (p_post_id, p_user_id, p_content);
  savepoint after_insert;
  update posts
  set comments_count = comments_count + 1
  where post_id = p_post_id;
  commit;
end $$
delimiter ;
call sp_post_comment(1, 2, 'comment thanh cong');
set @old_sql_safe_updates = @@sql_safe_updates;
set sql_safe_updates = 0;
update posts set post_id = post_id + 1000 where post_id = 1;
set sql_safe_updates = @old_sql_safe_updates;
select * from posts;
select * from comments order by created_at desc;
select * from users;
select * from followers;
