create database Bt5;
use Bt5;

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15)
);

-- Tạo bảng courses
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    duration INT NOT NULL,
    fee DECIMAL(10, 2) NOT NULL
);

-- Tạo bảng enrollments
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
-- Thêm bản ghi vào bảng students
INSERT INTO students (name, email, phone)
VALUES
('Nguyen Van An', 'nguyenvanan@example.com', '0901234567'),
('Tran Thi Bich', NULL, '0912345678'),
('Le Van Cuong', 'levancuong@example.com', NULL),
('Pham Minh Hoang', 'phamminhhoang@example.com', '0934567890'),
('Do Thi Ha', NULL, NULL),
('Hoang Quang Huy', 'hoangquanghuy@example.com', '0956789012');



-- Thêm bản ghi vào bảng cources
INSERT INTO courses (course_name, duration, fee)
VALUES
('Python Basics', 30, 500000),
('Web Development', 50, 1000000),
('Data Science', 40, 1500000),
('Machine Learning', 60, 2000000),
('UI/UX Design', 20, 800000);

-- Thêm bản ghi vào bảng enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date)
VALUES
(1, 1, '2025-01-10'), 
(2, 2, '2025-01-11'), 
(3, 3, '2025-01-12'), 
(4, 1, '2025-01-13'), 
(6, 2, '2025-01-15'), 
(1, 2, '2025-01-16'), 
(2, 3, '2025-01-17'), 
(3, 1, '2025-01-18');

select 
    students.name as student_name, 
    students.email, 
    courses.course_name, 
    courses.fee, 
    enrollments.enrollment_date
from enrollments
join students on enrollments.student_id = students.student_id
join courses on enrollments.course_id = courses.course_id
where enrollments.enrollment_date between '2025-01-12' and '2025-01-18'
and courses.fee > 800000
order by courses.fee desc;

select 
    students.name as student_name, 
    courses.course_name, 
    courses.fee
from enrollments
join students on enrollments.student_id = students.student_id
join courses on enrollments.course_id = courses.course_id
where courses.fee < 1000000 or courses.course_name <> 'python basics'
limit 5;

select 
    students.name as student_name, 
    courses.course_name, 
    courses.fee, 
    enrollments.enrollment_date
from enrollments
join students on enrollments.student_id = students.student_id
join courses on enrollments.course_id = courses.course_id
where courses.course_name in ('web development', 'data science')
order by enrollments.enrollment_date asc
limit 3;
 



