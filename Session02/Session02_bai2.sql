DROP DATABASE IF EXISTS Session02_bai2;

create database Session02_bai2;
use Session02_bai2;
create table Class(
Ma_lop varchar(30) primary key,
Ten_Lop varchar(30) ,
Nam_Hoc varchar(100)

);
create table Student(
Ma_sinh_vien int primary key,
Ho_ten varchar(50) ,
Ngay_sinh varchar(100),
Ma_lop_hoc_thuoc_ve varchar(30),
constraint Fk_Student_Class
foreign key (Ma_lop_hoc_thuoc_ve) references Class(Ma_lop)
);

