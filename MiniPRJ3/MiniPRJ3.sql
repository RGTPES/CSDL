use StudentDB;
create or replace view View_StudentBasic   as 
select s.StudentID,s.FullName ,d.DeptName from  Student s join Department d 
on s.DeptID = d.DeptID;
select * from View_StudentBasic;
create index idx_student_fullname
on Student (FullName);
delimiter $$
drop procedure if exists GetStudentsIT;
create procedure GetStudentsIT ()
begin	
	select s.FullName , d.DeptName from Student s 
 join Department d on s.DeptID = d.DeptID 
where d.DeptName = "Information Technology";
end $$
delimiter ;
call GetStudentsIT();	
create or replace view View_StudentCountByDept  as 
select DeptName, count(*) as TotalStudents  
from Department d 
join Student s
 on d.DeptID = s.DeptID
 group by d.DeptName ;
 select * from View_StudentCountByDept;
 select * from View_StudentCountByDept 
 order by TotalStudents desc 
 limit 1;
 
delimiter $$
drop procedure if exists GetTopScoreStudent ;
create procedure GetTopScoreStudent(in p_CourseID char(6))
begin
select s.StudentID, s.FullName, c.CourseName, e.Score
from Student s
join Enrollment e on s.StudentID = e.StudentID
join Course c on c.CourseID = e.CourseID
where e.CourseID = p_CourseID
and e.Score = (
select max(e2.Score)
from Enrollment e2
where e2.CourseID = p_CourseID
);
end $$
delimiter ;
 call  GetTopScoreStudent('C00001');
