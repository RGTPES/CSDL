DROP DATABASE IF EXISTS Session04_MNPRJ;
CREATE DATABASE Session04_MNPRJ;
USE Session04_MNPRJ;

CREATE TABLE student (
  student_id  VARCHAR(20) PRIMARY KEY,
  full_name   VARCHAR(100) NOT NULL,
  dob         DATE NOT NULL,
  email       VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE teacher (
  teacher_id  VARCHAR(20) PRIMARY KEY,
  full_name   VARCHAR(100) NOT NULL,
  email       VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE course (
  course_id     VARCHAR(20) PRIMARY KEY,
  course_name   VARCHAR(120) NOT NULL,
  short_desc    VARCHAR(255),
  sessions      INT NOT NULL,
  teacher_id    VARCHAR(20) NOT NULL,
  CHECK (sessions > 0),
  CONSTRAINT fk_course_teacher
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
);

CREATE TABLE enrollment (
  enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id    VARCHAR(20) NOT NULL,
  course_id     VARCHAR(20) NOT NULL,
  enroll_date   DATE NOT NULL,
  CONSTRAINT uq_enrollment UNIQUE (student_id, course_id),
  CONSTRAINT fk_enroll_student
    FOREIGN KEY (student_id) REFERENCES student(student_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_enroll_course
    FOREIGN KEY (course_id) REFERENCES course(course_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE result (
  student_id   VARCHAR(20) NOT NULL,
  course_id    VARCHAR(20) NOT NULL,
  mid_score    DECIMAL(4,2) NOT NULL,
  final_score  DECIMAL(4,2) NOT NULL,
  CHECK (mid_score >= 0 AND mid_score <= 10),
  CHECK (final_score >= 0 AND final_score <= 10),
  PRIMARY KEY (student_id, course_id),
  CONSTRAINT fk_result_student
    FOREIGN KEY (student_id) REFERENCES student(student_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_result_course
    FOREIGN KEY (course_id) REFERENCES course(course_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

INSERT INTO student (student_id, full_name, dob, email) VALUES
('SV101', 'Nguyễn Minh Đức',  '2005-02-18', 'duc.sv101@uni.edu'),
('SV102', 'Trần Ngọc Hân',    '2005-06-09', 'han.sv102@uni.edu'),
('SV103', 'Lê Quốc Bảo',      '2004-12-25', 'bao.sv103@uni.edu'),
('SV104', 'Phạm Thu Trang',   '2005-04-03', 'trang.sv104@uni.edu'),
('SV105', 'Vũ Anh Khoa',      '2004-08-14', 'khoa.sv105@uni.edu');

INSERT INTO teacher (teacher_id, full_name, email) VALUES
('GV101', 'TS. Đặng Hoàng',     'hoang.gv101@uni.edu'),
('GV102', 'ThS. Nguyễn Bích',   'bich.gv102@uni.edu'),
('GV103', 'TS. Phan Thành',     'thanh.gv103@uni.edu'),
('GV104', 'ThS. Lưu Hồng',      'hong.gv104@uni.edu'),
('GV105', 'TS. Trịnh Mai',      'mai.gv105@uni.edu');

INSERT INTO course (course_id, course_name, short_desc, sessions, teacher_id) VALUES
('C101', 'Nhập môn SQL',        'Truy vấn, JOIN, thiết kế cơ bản', 10, 'GV101'),
('C102', 'Web Frontend',        'HTML/CSS/JS + bài tập dự án', 16, 'GV102'),
('C103', 'CTDL & Giải thuật',   'Mảng, stack/queue, cây, đồ thị', 14, 'GV103'),
('C104', 'An ninh mạng',        'Mã hóa, tấn công cơ bản, phòng thủ', 12, 'GV104'),
('C105', 'Phân tích thiết kế',  'UML, use case, mô hình hóa', 11, 'GV105');

INSERT INTO enrollment (student_id, course_id, enroll_date) VALUES
('SV101', 'C101', '2025-11-28'),
('SV101', 'C102', '2025-12-02'),
('SV102', 'C101', '2025-11-28'),
('SV102', 'C103', '2025-12-04'),
('SV103', 'C102', '2025-12-02'),
('SV103', 'C104', '2025-12-06'),
('SV104', 'C105', '2025-12-08'),
('SV105', 'C101', '2025-12-01');

INSERT INTO result (student_id, course_id, mid_score, final_score) VALUES
('SV101', 'C101', 7.25, 8.50),
('SV101', 'C102', 6.75, 7.80),
('SV102', 'C101', 8.20, 8.90),
('SV102', 'C103', 7.10, 7.60),
('SV103', 'C102', 9.10, 9.50),
('SV103', 'C104', 6.40, 7.10),
('SV104', 'C105', 8.00, 8.70),
('SV105', 'C101', 5.60, 6.30);

SELECT * FROM student;
SELECT * FROM teacher;
SELECT * FROM course;
SELECT * FROM enrollment;
SELECT * FROM result;
