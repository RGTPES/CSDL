	DROP DATABASE IF EXISTS Session02_bai6;
    	create database Session02_bai6;
	use Session02_bai6;
      create table Teacher(
  Ma_giang_vien int primary key,
  Ho_ten varchar(50),
  Email varchar(100)
  );
	create table Subject(
	Ma_mon_hoc int primary key,
	Ten_mon_hoc varchar(30) ,
	So_tin_chi int not null,
    Ma_giang_vien int,
    foreign key (Ma_giang_vien) references Teacher(Ma_giang_vien)
    

	);
	create table Student(
	Ma_sinh_vien int primary key,
	Ho_ten varchar(50) 
	);


	create table Register(
	Ma_sinh_vien int not null ,
	Ma_mon_hoc int not null ,
    PRIMARY KEY (Ma_sinh_vien, Ma_mon_hoc),
	Ngay_dang_ky date default (current_date()),
	foreign key (Ma_sinh_vien) references Student(Ma_sinh_vien),
    foreign key (Ma_mon_hoc) references Subject(Ma_mon_hoc)
	);
    	create table Score(
    Ma_sinh_vien int,
    Ma_mon_hoc int ,
    Diem_so Decimal(4,2),
    primary key (Ma_sinh_vien,Ma_mon_hoc),
    check(Diem_so between 0 and 10),
    foreign key (Ma_sinh_vien,Ma_mon_hoc) references Register(Ma_sinh_vien,Ma_mon_hoc)
    
    
    );
 INSERT INTO Teacher (Ma_giang_vien, Ho_ten, Email) 
VALUES (3, 'Nguyen Van A', 'vna@gmail.com');
    insert into Subject (Ma_mon_hoc, Ten_mon_hoc,So_tin_chi,Ma_giang_vien)
    values( 1 , "TiengAnh" , 2 , 3),
    ( 2 , "TiengViet" , 2 , 3),
    ( 3 , "TiengDuc" , 2 , 3);
       select 	*  from Subject;
       
    
  

