use datahad;

drop procedure if exists createpostwithvalidation;
delimiter $$

create procedure createpostwithvalidation(
    in  p_user_id int,
    in  p_content text,
    out result_message varchar(255)
)
begin
    if p_content is null or char_length(trim(p_content)) < 5 then
        set result_message = 'nội dung quá ngắn';
    else
        insert into posts(user_id, content)
        values (p_user_id, p_content);

        set result_message = 'thêm bài viết thành công';
    end if;
end$$

delimiter ;

set @msg = '';
call createpostwithvalidation(1, 'hi', @msg);
select @msg as result_message;

set @msg = '';
call createpostwithvalidation(1, '   a  ', @msg);
select @msg as result_message;

set @msg = '';
call createpostwithvalidation(1, 'hôm nay học stored procedure!', @msg);
select @msg as result_message;

set @msg = '';
call createpostwithvalidation(2, 'bài viết mới hợp lệ nè', @msg);
select @msg as result_message;

select post_id, user_id, content, created_at
from posts
order by post_id desc
limit 10;

select post_id, user_id, content, created_at
from posts
where content in ('hôm nay học stored procedure', 'bài viết mới hợp lệ nè')
order by post_id desc;

drop procedure if exists createpostwithvalidation;
