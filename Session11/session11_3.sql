use datahad ; 

delimiter $$
create procedure CalculateBonusPoints (in p_user_id int , 	inout p_bonus_points int )
begin 
declare totalPost	 int default 0 ;
select count(* ) into  totalPost from posts 
where p_user_id  = user_id;
if totalPost >= 20 then
	set  p_bonus_points = p_bonus_points+100;
elseif totalPost >= 10 then
set  p_bonus_points = p_bonus_points+50;
end if;

end $$
delimiter ;
set @totalPoint = 0;
call CalculateBonusPoints(1, @totalPoint);       
select @totalPoint as total_bonus_points; 


