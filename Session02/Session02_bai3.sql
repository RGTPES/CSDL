DROP DATABASE IF EXISTS Session02_bai3;

create database Session02_bai3;
use Session02_bai3;
create table Subject(
Ma_mon_hoc varchar(30) primary key,
Ten_mon_hoc varchar(30) ,
So_tin_chi int not null

);
create table Student(
Ma_sinh_vien int primary key,
Ho_ten varchar(50) 
);

