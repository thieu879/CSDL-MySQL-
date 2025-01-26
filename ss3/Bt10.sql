CREATE DATABASE bt10;
USE bt10;

CREATE TABLE Students (
    student_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(225) NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL,
);
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    student_id INT,
    course_name VARCHAR(255) NOT NULL,
    enrollment_date DATE NOT NULL
);

INSERT INTO Students (name, email, date_of_birth)
VALUES
('Nguyen Van A', 'nguyenvana@example.com', '2000-05-15'),
('Tran Thi B', 'tranthib@example.com', '1999-08-22'),
('Le Van C', 'levanc@example.com', '2001-01-10'),
('Pham Thi D', 'phamthid@example.com', '1998-12-05'),
('Hoang Van E', 'hoangvane@example.com', '2002-03-18');
 
INSERT INTO Enrollments (student_id, course_name, enrollment_date)
VALUES
(1, 'Math 101', '2025-01-10'),
(1, 'Physics 101', '2025-01-15'),
(2, 'Chemistry 101', '2025-01-12'),
(2, 'Biology 101', '2025-01-20'),
(3, 'History 101', '2025-02-01'),
(3, 'Geography 101', '2025-02-05'),
(4, 'Computer Science 101', '2025-03-01'),
(4, 'Programming Basics', '2025-03-10'),
(5, 'English Literature', '2025-04-01'),
(5, 'Creative Writing', '2025-04-05');

SELECT *
FROM Students
WHERE name LIKE '%Nguyen%' AND date_of_birth >= '2000-01-01';

UPDATE Students
SET email = 'updated_email@example.com'
WHERE name = 'Nguyen Van A';

SELECT *
FROM Enrollments
WHERE course_name LIKE '%101%';

DELETE FROM Enrollments
WHERE enrollment_date < '2025-02-01';
