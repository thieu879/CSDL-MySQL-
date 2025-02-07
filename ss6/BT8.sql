create database Bt8;
use Bt8;
-- Tạo bảng students
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
('Tran Thi Bich', 'tranthibich@example.com', '0912345678'),
('Le Van Cuong', 'levancuong@example.com', '0923456789'),
('Pham Minh Hoang', 'phamminhhoang@example.com', '0934567890'),
('Do Thi Ha', 'dothiha@example.com', '0945678901'),
('Hoang Quang Huy', 'hoangquanghuy@example.com', '0956789012');

-- Thêm bản ghi vào bảng cources
INSERT INTO courses (course_name, duration, fee)
VALUES
('Python Basics', 30, 300000),
('Web Development', 50, 1000000),
('Data Science', 40, 1500000);

-- Thêm bản ghi vào bảng enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date)
VALUES
(1, 1, '2025-01-10'), 
(2, 2, '2025-01-11'), 
(3, 3, '2025-01-12'), 
(4, 1, '2025-01-13'), 
(5, 2, '2025-01-14'), 
(6, 2, '2025-01-10'), 
(2, 3, '2025-01-17'), 
(3, 1, '2025-01-11'), 
(4, 3, '2025-01-19'); 


select s.student_id, 
	s.name as student_name, 
	s.email,
	c.course_name,
	e.enrollment_date
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
where s.student_id in (select student_id from enrollments group by student_id having count(*) > 1)
order by s.student_id asc, e.enrollment_date asc;


select 
	s.name as student_name, 
	s.email,
	e.enrollment_date,
    c.course_name,
    c.fee
from students s
join enrollments e on e.student_id = s.student_id
join courses c on c.course_id = e.course_id
where c.course_id in (
    select e2.course_id
    from enrollments e2
    join students s2 on e2.student_id = s2.student_id
    where s2.name = 'Nguyen Van An'
)
and s.name != 'Nguyen Van An';

select c.course_name,
       c.duration,
       c.fee,
       count(e.student_id) as total_students
from courses c
join enrollments e on c.course_id = e.course_id
group by c.course_name, c.duration, c.fee
having count(e.student_id) > 2;

select s.name as student_name,
       s.email,
       sum(c.fee) as total_fee_paid,
       count(distinct e.course_id) as courses_count
from students s
left join enrollments e on s.student_id = e.student_id
left join courses c on e.course_id = c.course_id
where c.duration > 30
group by s.name, s.email
having courses_count > 1;

