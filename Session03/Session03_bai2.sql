	DROP DATABASE IF EXISTS Session03_bai2;
    	create database Session03_bai2;
	use Session03_bai2;
    create table Student (
    student_id int primary key,
    full_name varchar(50) not null,
    date_of_birth date,
    email varchar(100) unique 
    );
    insert into Student(student_id,full_name,date_of_birth,email)
    values(1,"Nguyễn Văn A" , "2001-7-4","nva@gmail.com"),
    (2,"Nguyễn Văn B" , "2001-8-4","nvb@gmail.com"),
    (3,"Nguyễn Văn C" , "2001-9-4","nvc@gmail.com");
    
    select * from Student;
    select student_id , full_name from Student