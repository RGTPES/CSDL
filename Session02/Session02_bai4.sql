	DROP DATABASE IF EXISTS Session02_bai4;
    DROP TABLE IF EXISTS Register;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Subject;

	create database Session02_bai4;
	use Session02_bai4;
	create table Subject(
	Ma_mon_hoc int primary key,
	Ten_mon_hoc varchar(30) ,
	So_tin_chi int not null

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

