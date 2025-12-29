	DROP DATABASE IF EXISTS Session03_bai4;
    	create database Session03_bai4;
	use Session03_bai4;
    create table Subject(
    subject_id int auto_increment primary key ,
    subject_name varchar(50),
    credit int not null
    );
    insert into Subject ( subject_id , subject_name , credit)
    values (1 , "Toan" , 3),
    (2 , "Văn" , 3),
    (3 , "Anh" , 3);
    update Subject
    set credit=4
    where subject_id = 2;
    update Subject
    set subject_name="Ngoại ngữ"
    where subject_id = 3;
    select * from Subject;
    
    