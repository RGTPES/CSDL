use datahad;
delimiter $$ 
create procedure totalLike ( in  p_post_id int , out total_likes int )
begin 
	select count(*)  from likes
    where 	post_id = p_post_id;
    end $$ 
    delimiter ;
    call totalLike ( 102 , @total);