drop database if exists miniPRJ4;
create database miniPRJ4;
use miniPRJ4;
CREATE TABLE Students (
    StudentID CHAR(5) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    TotalDebt DECIMAL(10,2) DEFAULT 0
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID CHAR(5) PRIMARY KEY,
    SubjectName VARCHAR(50) NOT NULL,
    Credits INT CHECK (Credits > 0)
);

-- Table: Grades
CREATE TABLE Grades (
    StudentID CHAR(5),
    SubjectID CHAR(5),
    Score DECIMAL(4,2) CHECK (Score BETWEEN 0 AND 10),
    PRIMARY KEY (StudentID, SubjectID),
    CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Grades_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Table: GradeLog
CREATE TABLE GradeLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID CHAR(5),
    OldScore DECIMAL(4,2),
    NewScore DECIMAL(4,2),
    ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 2. SEED DATA
-- =============================================

-- Insert Students
INSERT INTO Students (StudentID, FullName, TotalDebt) VALUES 
('SV01', 'Ho Khanh Linh', 5000000),
('SV03', 'Tran Thi Khanh Huyen', 0);

-- Insert Subjects
INSERT INTO Subjects (SubjectID, SubjectName, Credits) VALUES 
('SB01', 'Co so du lieu', 3),
('SB02', 'Lap trinh Java', 4),
('SB03', 'Lap trinh C', 3);

-- Insert Grades
INSERT INTO Grades (StudentID, SubjectID, Score) VALUES 
('SV01', 'SB01', 8.5), -- Passed
('SV03', 'SB02', 3.0); -- Failed
drop trigger if exists tg_CheckScore;
delimiter $$
create trigger tg_CheckScore
before insert on Grades
for each row
begin
if new.Score < 0 then
set new.Score = 0;
elseif new.Score > 10 then
set new.Score = 10;
end if;
end $$
delimiter ;
start transaction;
insert into Students (StudentID, FullName, TotalDebt)
values ('SV02', 'Ha Bich Ngoc', 0);
update Students
set TotalDebt = 5000000
where StudentID = 'SV02';
commit;
drop trigger if exists tg_LogGradeUpdate;
delimiter $$
create trigger tg_LogGradeUpdate
after update on Grades
for each row
begin
if not (old.Score <=> new.Score) then
insert into GradeLog (StudentID, OldScore, NewScore, ChangeDate)
values (old.StudentID, old.Score, new.Score, now());
end if;
end $$
delimiter ;
drop procedure if exists sp_PayTuition;
delimiter $$
create procedure sp_PayTuition()
begin
declare v_debt decimal(10,2);
start transaction;
update Students
set TotalDebt = TotalDebt - 2000000
where StudentID = 'SV01';
select TotalDebt into v_debt
from Students
where StudentID = 'SV01'
for update;
if v_debt < 0 then
rollback;
else
commit;
end if;
end $$
delimiter ;
drop trigger if exists tg_PreventPassUpdate;
delimiter $$
create trigger tg_PreventPassUpdate
before update on Grades
for each row
begin
if old.Score >= 4.0 then
signal sqlstate '45000'
set message_text = 'khong duoc sua diem khi da qua mon';
end if;
end $$
delimiter ;
drop procedure if exists sp_Deletestudentgrade;
delimiter $$
create procedure sp_Deletestudentgrade(in p_studentid char(5), in p_subjectid char(5))
begin
declare v_score decimal(4,2);
start transaction;
select Score into v_score
from Grades
where StudentID = p_studentid and SubjectID = p_subjectid
for update;
delete from Grades
where StudentID = p_studentid and SubjectID = p_subjectid;
if row_count() = 0 then
rollback;
else
insert into GradeLog(StudentID, OldScore, NewScore, ChangeDate)
values (p_studentid, v_score, null, now());
commit;
end if;
end $$
delimiter ;
call sp_PayTuition();
update Grades
set Score = 6.5
where StudentID = 'SV03' and SubjectID = 'SB02';
call sp_Deletestudentgrade('SV03', 'SB02');
