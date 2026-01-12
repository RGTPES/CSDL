use datahad;

delimiter $$

create procedure checkIduser (
    in p_user_id int
)
begin
    select post_id,content,  created_at   from posts
    where user_id = p_user_id;
end $$

delimiter ;
call checkIduser(3);
drop procedure if exists checkIduser;
