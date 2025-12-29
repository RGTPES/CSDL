	DROP DATABASE IF EXISTS Session03_bai3;
    	create database Session03_bai3;
	use Session03_bai3;
    create table Student (
    student_id int primary key auto_increment,
    full_name varchar(50) not null,
    date_of_birth date,
    email varchar(100) unique 
    );
    insert into Student(student_id,full_name,date_of_birth,email)
    values(1,"Nguyễn Văn A" , "2001-7-4","nva@gmail.com"),
    (2,"Nguyễn Văn B" , "2001-8-4","nvb@gmail.com"),
    (3,"Nguyễn Văn C" , "2001-9-4","nvc@gmail.com"),
    (4,"Nguyễn Văn D" , "2001-10-4","nvd@gmail.com"),
    (5,"Nguyễn Văn E" , "2001-11-4","nve@gmail.com");
     select * from Student;
    update Student
    set email= "NGva@gmail.com"
    where student_id = 3;
     update Student
    set date_of_birth= "2001-8-9"
    where student_id = 2;
    delete from Student
    where student_id = 5;
    select * from Student;