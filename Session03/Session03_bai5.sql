DROP DATABASE IF EXISTS Session03_bai5;
create database Session03_bai5;	

	use Session03_bai5;
    create table Student (
    student_id int primary key auto_increment,
    full_name varchar(50) not null,
    date_of_birth date,
    email varchar(100) unique 
    );
     create table Subject(
    subject_id int auto_increment primary key ,
    subject_name varchar(50),
    credit int not null
    );
    create table Enrollment(
    student_id int ,
    subject_id int,
    enroll_date varchar ( 100),
    primary key ( student_id , subject_id),
    foreign key (student_id) references Student(student_id),
    foreign key (subject_id) references Subject(subject_id)
    );
    insert into Student(student_id,full_name,date_of_birth,email)
    values(1,"Nguyễn Văn A" , "2001-7-4","nva@gmail.com"),
    (2,"Nguyễn Văn B" , "2001-8-4","nvb@gmail.com"),
    (3,"Nguyễn Văn C" , "2001-9-4","nvc@gmail.com"),
    (4,"Nguyễn Văn D" , "2001-10-4","nvd@gmail.com"),
    (5,"Nguyễn Văn E" , "2001-11-4","nve@gmail.com");
     insert into Subject ( subject_id , subject_name , credit)
    values (1 , "Toan" , 3),
    (2 , "Văn" , 3),
    (3 , "Anh" , 3);
    insert into Enrollment (  student_id, subject_id,enroll_date)
    values ( 1 , 1 , current_date()),( 2 , 1 , current_date());
    select * from Enrollment;
select * from Enrollment
where student_id = 1;